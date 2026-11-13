import { readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import type { ContextUsage, ExtensionAPI, ExtensionContext } from "@earendil-works/pi-coding-agent";
import { stripTerminalSequences, truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

/** Values for the currently selected model and the whole session (not just its active branch). */
export interface FooterMetrics {
	modelName: string;
	thinkingLevel: string;
	percent: number | null;
	usedTokens: number | null;
	maxTokens: number | null;
	provider: string;
	cost: number | null;
}

function inline(text: string, fallback: string): string {
	return stripTerminalSequences(text).replace(/[\x00-\x1f\x7f-\x9f]/g, " ").replace(/\s+/g, " ").trim() || fallback;
}

const aliasesPath = fileURLToPath(new URL("./model-aliases.json", import.meta.url));

/** Load exact provider/model-id aliases once per interactive session, not on each render. */
export function loadModelAliases(path = aliasesPath): Record<string, string> {
	let data: unknown;
	try {
		data = JSON.parse(readFileSync(path, "utf8"));
	} catch (error) {
		if ((error as NodeJS.ErrnoException).code === "ENOENT") return Object.create(null);
		throw error;
	}
	if (!data || typeof data !== "object" || Array.isArray(data)) {
		throw new Error("Footer model aliases must be a JSON object");
	}
	const aliases = Object.create(null) as Record<string, string>;
	for (const [key, value] of Object.entries(data)) {
		if (!key.trim() || typeof value !== "string" || !inline(value, "")) {
			throw new Error(`Invalid footer model alias for ${JSON.stringify(key)}`);
		}
		aliases[key] = inline(value, "");
	}
	return aliases;
}

function tokenCount(value: number | null): string {
	if (value === null || !Number.isFinite(value) || value < 0) return "?";
	if (value < 1000) return Math.round(value).toString();
	if (value < 10000) return `${(value / 1000).toFixed(1)}k`;
	if (value < 1000000) return `${Math.round(value / 1000)}k`;
	if (value < 10000000) return `${(value / 1000000).toFixed(1)}M`;
	return `${Math.round(value / 1000000)}M`;
}

function sessionCost(ctx: ExtensionContext): number {
	// Match Pi's built-in footer and /session: count all billed entries, including
	// abandoned branches, compactions, tool results, and cache-warming calls.
	let cost = 0;
	for (const entry of ctx.sessionManager.getEntries()) {
		let amount: number | undefined;
		if (entry.type === "usage" || entry.type === "compaction" || entry.type === "branch_summary") {
			amount = entry.usage?.cost.total;
		} else if (entry.type === "message" && (entry.message.role === "assistant" || entry.message.role === "toolResult")) {
			amount = entry.message.usage?.cost.total;
		}
		if (amount !== undefined && Number.isFinite(amount)) cost += amount;
	}
	return cost;
}

export function readFooterMetrics(ctx: ExtensionContext, aliases: Readonly<Record<string, string>> = {}): FooterMetrics {
	const model = ctx.model;
	const key = model ? `${model.provider}/${model.id}` : "";
	const alias = Object.prototype.hasOwnProperty.call(aliases, key) ? aliases[key] : undefined;
	const modelName = inline(alias || "", "") || inline(model?.name || model?.id || "", "no model");
	const usage: ContextUsage | undefined = ctx.getContextUsage();
	const max = usage?.contextWindow || model?.contextWindow;
	return {
		modelName,
		thinkingLevel: inline(ctx.thinkingLevel || "off", "off"),
		percent: usage?.percent ?? null,
		usedTokens: usage?.tokens ?? null,
		maxTokens: max && max > 0 ? max : null,
		provider: inline(model?.provider || "", "no provider"),
		cost: sessionCost(ctx),
	};
}

function usageBar(width: number, percent: number | null): string {
	if (width <= 0) return "";
	const framed = width >= 3;
	const bodyWidth = width - (framed ? 2 : 0);
	let body: string;
	if (percent === null || !Number.isFinite(percent) || percent < 0) {
		body = "─".repeat(bodyWidth); // Unknown usage is distinct from an empty, 0% bar.
	} else {
		const filled = Math.min(bodyWidth, Math.max(0, Math.round(bodyWidth * percent / 100)));
		body = "█".repeat(filled) + "░".repeat(bodyWidth - filled);
	}
	return framed ? `[${body}]` : body;
}

function clip(text: string, width: number, ellipsis = ""): string {
	// Pi's ANSI-aware truncate helper appends terminal resets even for plain text.
	// Remove them before coloring the completed line with the current theme.
	return stripTerminalSequences(truncateToWidth(text, width, ellipsis));
}

function joinFields(fields: readonly string[], separators: readonly string[]): string {
	return fields.map((field, i) => i === 0 ? field : separators[i - 1] + field).join("");
}

/** Render one terminal line; only the bar receives spare columns. */
export function renderFooterLine(metrics: FooterMetrics, availableWidth: number): string {
	const width = Math.max(0, Math.trunc(availableWidth));
	if (width === 0) return "";

	const percentage = metrics.percent !== null && Number.isFinite(metrics.percent) && metrics.percent >= 0
		? `${metrics.percent.toFixed(1)}%` : "?";
	const fields = [
		inline(metrics.modelName, "no model"),
		inline(metrics.thinkingLevel, "off"),
		percentage,
		tokenCount(metrics.usedTokens),
		tokenCount(metrics.maxTokens),
		metrics.cost !== null && Number.isFinite(metrics.cost) ? `$${metrics.cost.toFixed(3)}` : "$?",
		inline(metrics.provider, "no provider"),
	];
	const left = fields.slice(0, 4).join("·");
	const right = fields.slice(4).join("·");
	const fixed = visibleWidth(left) + visibleWidth(right);
	if (fixed + 2 <= width) {
		return `${left} ${usageBar(width - fixed - 2, metrics.percent)} ${right}`;
	}
	if (fixed + 1 <= width) return `${left}·${right}`;

	// When the bar disappears, a single divider separates every field.
	// Drop dividers only when even one column per field will not fit.
	let separators = Array(6).fill("·");
	let separatorWidth = 6;
	if (width < separatorWidth + fields.length) {
		separators = Array(6).fill("");
		separatorWidth = 0;
	}
	if (width < fields.length) {
		return clip(fields.map((field) => clip(field, 1)).join(""), width);
	}

	const lengths = fields.map(visibleWidth);
	const allocations = fields.map(() => 1);
	let remaining = width - separatorWidth - fields.length;
	while (remaining > 0) {
		const expandable = allocations.map((n, i) => n < lengths[i] ? i : -1).filter((i) => i >= 0);
		if (expandable.length === 0) break;
		const share = Math.max(1, Math.floor(remaining / expandable.length));
		for (const i of expandable) {
			const increase = Math.min(remaining, share, lengths[i] - allocations[i]);
			allocations[i] += increase;
			remaining -= increase;
			if (remaining === 0) break;
		}
	}
	const shortened = fields.map((field, i) => clip(field, allocations[i], allocations[i] > 1 ? "…" : ""));
	return clip(joinFields(shortened, separators), width);
}

export default function (pi: ExtensionAPI): void {
	pi.on("session_start", (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		let aliases: Record<string, string>;
		try {
			aliases = loadModelAliases();
		} catch (error) {
			ctx.ui.notify(`Could not load footer model aliases: ${error instanceof Error ? error.message : String(error)}`, "warning");
			aliases = Object.create(null);
		}
		ctx.ui.setFooter((_tui, theme) => ({
			// Pi calls render on resize and on its normal session/UI updates. The
			// context getters are live, so there is no stale cached footer state.
			render(width: number): string[] {
				return [theme.fg("dim", renderFooterLine(readFooterMetrics(ctx, aliases), width))];
			},
			invalidate() {},
		}));
	});
}
