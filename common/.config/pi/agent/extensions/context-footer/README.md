# Footer model aliases

Edit `model-aliases.json` to give models short labels in the Pi footer. Keys are exact `provider/model-id` pairs (as shown by Pi's model catalog), and values are the labels to display. For example:

```json
{
  "github-copilot/claude-haiku-4.5": "Haiku 4.5",
  "github-copilot/gpt-6-sol": "GPT-6 Sol"
}
```

Unlisted models keep their normal Pi name (or ID). The provider field and model selection are unchanged. After editing aliases, run `/reload` in Pi; aliases are loaded once per interactive session.

Tests: `node --test index.test.mjs` in this directory (uses the jiti and TUI
packages of Pi's managed install, found through `PI_CODING_AGENT_DIR`).
