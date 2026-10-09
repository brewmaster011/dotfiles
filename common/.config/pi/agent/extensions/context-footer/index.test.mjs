import assert from "node:assert/strict";
import { mkdtempSync, readFileSync, rmSync, writeFileSync } from "node:fs";
import { homedir, tmpdir } from "node:os";
import { createRequire } from "node:module";
import { join } from "node:path";
import { fileURLToPath, pathToFileURL } from "node:url";
import test from "node:test";

// Load the extension next to this file just as Pi does, using the active Pi
// release's TUI alias (found through the agent dir, like Pi itself).
const agentDir = process.env.PI_CODING_AGENT_DIR || join(homedir(), ".pi", "agent");
const version = readFileSync(join(agentDir, "install", "current-version"), "utf8").trim();
const packageJson = join(agentDir, "install", "releases", version, "node_modules", "@earendil-works", "pi-coding-agent", "package.json");
const requirePi = createRequire(packageJson);
const { createJiti } = requirePi("jiti");
const tuiEntry = requirePi.resolve("@earendil-works/pi-tui");
const jiti = createJiti(import.meta.url, { moduleCache: false, alias: { "@earendil-works/pi-tui": tuiEntry } });
const { default: register, loadModelAliases, readFooterMetrics, renderFooterLine } = await jiti.import(fileURLToPath(new URL("./index.ts", import.meta.url)));
const { visibleWidth } = await import(pathToFileURL(tuiEntry).href);

const metrics = {
	modelName: "GPT-5.4",
	thinkingLevel: "high",
	percent: 25,
	usedTokens: 50_000,
	maxTokens: 200_000,
	provider: "github-copilot",
	cost: 0.457,
};

function barAt(line) {
	const match = line.match(/\[([█░─]+)\]/);
	assert.ok(match, `Missing bar: ${line}`);
	return match[1];
}

test("full layout keeps the specified field order and gives every spare column to the bar", () => {
	const left = "GPT-5.4·high·25.0%·50k";
	const right = "200k·$0.457·github-copilot";
	for (const width of [70, 80, 110, 200]) {
		const line = renderFooterLine(metrics, width);
		assert.equal(visibleWidth(line), width);
		assert.ok(line.startsWith(left + " ["), line);
		assert.ok(line.endsWith("] " + right), line);
		assert.doesNotMatch(line, /[ \t]·|·[ \t]/);
		const body = barAt(line);
		const expected = width - visibleWidth(left) - visibleWidth(right) - 4; // 2 spaces + 2 brackets
		assert.equal(body.length, expected);
		assert.match(body, /^█*░*$/);
		assert.equal([...body].filter((c) => c === "█").length, Math.round(expected * 0.25));
	}
});

test("bar fill follows 0%, 50%, 100%, and caps overflow", () => {
	for (const [percent, expectedRatio] of [[0, 0], [50, 0.5], [100, 1], [150, 1]]) {
		const line = renderFooterLine({ ...metrics, percent }, 110);
		const body = barAt(line);
		assert.equal([...body].filter((c) => c === "█").length, Math.round(body.length * expectedRatio));
	}
	assert.ok(renderFooterLine({ ...metrics, percent: 150 }, 110).includes("150.0%"));
});

test("all terminal widths stay on one line and never overflow, including wide glyphs", () => {
	for (const sample of [metrics, { ...metrics, modelName: "\x1b[31m模型🧠 foo\nbar\x1b[0m", provider: "𝒫-提供者" }]) {
		for (let width = 0; width <= 160; width++) {
			const line = renderFooterLine(sample, width);
			assert.ok(!/[\r\n]/.test(line), `Wrapped at width ${width}`);
			assert.ok(visibleWidth(line) <= width, `Overflow at width ${width}: ${line}`);
		}
	}
	// At narrow widths the bar disappears before any of the surrounding text is lost.
	const fullText = renderFooterLine(metrics, 150).replace(/ \[[█░]+\] /, "·");
	assert.equal(renderFooterLine(metrics, visibleWidth(fullText)), fullText);
	assert.ok(!renderFooterLine(metrics, 25).includes("["), renderFooterLine(metrics, 25));
});

test("unknown usage is not shown as zero, and an invalid percent cannot fill the bar", () => {
	for (const percent of [null, -1, Number.NaN]) {
		const line = renderFooterLine({ ...metrics, percent, usedTokens: null, maxTokens: null, cost: null }, 100);
		assert.ok(line.includes("·?·? "), line);
		assert.ok(line.includes("?·$?·github-copilot"), line);
		assert.match(barAt(line), /^─+$/);
	}
});

test("missing model and context show placeholders rather than invented usage", () => {
	const ctx = {
		model: undefined,
		thinkingLevel: undefined,
		getContextUsage() { return undefined; },
		sessionManager: { getEntries() { return []; } },
	};
	const missing = readFooterMetrics(ctx);
	assert.deepEqual(missing, {
		modelName: "no model", thinkingLevel: "off", percent: null, usedTokens: null,
		maxTokens: null, provider: "no provider", cost: 0,
	});
	const line = renderFooterLine(missing, 100);
	assert.ok(line.includes("no model·off·?·?"));
	assert.ok(line.endsWith("?·$0.000·no provider"));
	assert.match(barAt(line), /^─+$/);
});

test("model aliases load from JSON, sanitize labels, and reject invalid values", () => {
	const dir = mkdtempSync(join(tmpdir(), "pi-context-footer-"));
	try {
		const path = join(dir, "model-aliases.json");
		writeFileSync(path, JSON.stringify({ "provider-A/a": "  Short\x1b[31m A\n ", "provider-B/b": "B" }));
		const aliases = loadModelAliases(path);
		assert.equal(aliases["provider-A/a"], "Short A");
		assert.deepEqual(Object.keys(aliases).sort(), ["provider-A/a", "provider-B/b"]);
		assert.deepEqual(Object.keys(loadModelAliases(join(dir, "missing.json"))), []);
		writeFileSync(path, '{"provider-A/a": 7}');
		assert.throws(() => loadModelAliases(path), /Invalid footer model alias/);
	} finally {
		rmSync(dir, { recursive: true, force: true });
	}
});

test("aliases use exact provider/model IDs and leave unlisted names untouched", () => {
	const ctx = {
		model: { name: "A very long model name", id: "a", provider: "provider-A", contextWindow: 100 },
		getContextUsage() { return undefined; },
		sessionManager: { getEntries() { return []; } },
	};
	const aliases = { "provider-A/a": "Short A", "provider-B/a": "Short B" };
	assert.equal(readFooterMetrics(ctx, aliases).modelName, "Short A");
	const shortLine = renderFooterLine(readFooterMetrics(ctx, aliases), 90);
	const longLine = renderFooterLine(readFooterMetrics(ctx), 90);
	assert.ok(shortLine.startsWith("Short A·"));
	assert.equal(visibleWidth(shortLine), 90);
	assert.equal(barAt(shortLine).length - barAt(longLine).length,
		visibleWidth("A very long model name") - visibleWidth("Short A"));
	ctx.model.provider = "provider-B";
	assert.equal(readFooterMetrics(ctx, aliases).modelName, "Short B");
	ctx.model.provider = "provider-C";
	assert.equal(readFooterMetrics(ctx, aliases).modelName, "A very long model name");
});

test("registered footer reads current model/thinking/context/cost at render time, not startup", () => {
	const handlers = new Map();
	register({ on(event, handler) { handlers.set(event, handler); } });
	assert.ok(handlers.has("session_start"));
	let model = { name: "Model A", id: "a", provider: "provider-A", contextWindow: 100 };
	let thinkingLevel = "low";
	let usage = { tokens: 10, contextWindow: 100, percent: 10 };
	const entries = [
		{ type: "message", message: { role: "assistant", usage: { cost: { total: 0.1 } } } },
		{ type: "message", message: { role: "toolResult", usage: { cost: { total: 0.2 } } } },
		{ type: "usage", usage: { cost: { total: 0.3 } } },
		{ type: "compaction", usage: { cost: { total: 0.4 } } },
		{ type: "branch_summary", usage: { cost: { total: 0.5 } } },
	];
	let factory;
	const ctx = {
		mode: "tui",
		ui: { setFooter(f) { factory = f; } },
		get model() { return model; },
		get thinkingLevel() { return thinkingLevel; },
		getContextUsage() { return usage; },
		sessionManager: { getEntries() { return entries; } },
	};
	const start = handlers.get("session_start");
	start({}, { ...ctx, mode: "print", ui: { setFooter() { throw new Error("Non-TUI footer"); } } });
	assert.equal(factory, undefined);
	start({}, ctx);
	assert.equal(typeof factory, "function");
	const component = factory({}, { fg: (_color, text) => text }, {});
	assert.deepEqual(component.render(90), [renderFooterLine(readFooterMetrics(ctx), 90)]);
	assert.ok(component.render(90)[0].includes("Model A·low·10.0%·10"));
	assert.ok(component.render(90)[0].endsWith("$1.500·provider-A"));

	model = { name: "Model B", id: "b", provider: "provider-B", contextWindow: 200 };
	thinkingLevel = "high";
	usage = { tokens: 120, contextWindow: 200, percent: 60 };
	entries.push({ type: "usage", usage: { cost: { total: 0.25 } } });
	const changed = component.render(110)[0];
	assert.ok(changed.includes("Model B·high·60.0%·120"), changed);
	assert.ok(changed.endsWith("200·$1.750·provider-B"), changed);
	assert.equal(visibleWidth(changed), 110);

	usage = { tokens: null, contextWindow: 200, percent: null }; // After compaction
	const unknown = component.render(110)[0];
	assert.ok(unknown.includes("·?·? "), unknown);
	assert.match(barAt(unknown), /^─+$/);
});
