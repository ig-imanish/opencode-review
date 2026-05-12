# Free model options

All of these work with OpenCode. Pick one based on your situation.

---

## Ollama — completely free, fully local, private

Best for: teams with data privacy requirements, no internet dependency, zero ongoing cost.

```bash
# Install
curl -fsSL https://ollama.ai/install.sh | bash

# Pull a model (one time)
ollama pull qwen2.5-coder:7b      # Best free coding model, 4.7GB
ollama pull qwen2.5-coder:14b     # Better quality, needs 8GB+ RAM
ollama pull codellama:13b          # Alternative, good for code review

# Configure OpenCode
# In .opencode/config.json:
{
  "model": "ollama/qwen2.5-coder:7b"
}
```

**Quality:** Very good for finding real bugs. Slightly weaker on nuanced security issues compared to frontier models, but honest and consistent. Good enough for daily use.

**Speed:** Depends on your hardware. M-series Mac or RTX 3080+ → fast enough. Older hardware → slow but works.

---

## OpenRouter free tier — free, cloud, easy

Best for: getting started fast without local setup.

```bash
# 1. Sign up at openrouter.ai (no credit card required for free tier)
# 2. Get API key from openrouter.ai/keys
export OPENROUTER_API_KEY=sk-or-...

# In .opencode/config.json:
{
  "model": "openrouter/google/gemini-flash-1.5",
  "providers": {
    "openrouter": {
      "apiKey": "${OPENROUTER_API_KEY}"
    }
  }
}
```

**Free models on OpenRouter (as of 2025):**
- `google/gemini-flash-1.5` — fast, very capable, generous free tier
- `meta-llama/llama-3.1-8b-instruct:free` — open weights, solid
- `mistralai/mistral-7b-instruct:free` — fast, good for smaller reviews
- `qwen/qwen-2.5-coder-32b-instruct:free` — best free coding model on OpenRouter

Check current free models at: openrouter.ai/models?q=free

**Limits:** Free tier has rate limits. Fine for personal use, might hit limits on large codebases.

---

## Google AI Studio — free, no credit card

```bash
# 1. Get key at aistudio.google.com/apikey
export GOOGLE_API_KEY=...

# In .opencode/config.json:
{
  "model": "google/gemini-1.5-flash",
  "providers": {
    "google": {
      "apiKey": "${GOOGLE_API_KEY}"
    }
  }
}
```

**Gemini 1.5 Flash free tier:** 15 requests/min, 1M tokens/day. More than enough for code review.

---

## OpenCode Go — $5 first month, curated models

Best for: reliable access to strong open-source coding models without managing API keys.

```bash
# Subscribe at opencode.ai/go
# Run /connect inside OpenCode TUI → select OpenCode Go → paste key

# Good models for review:
{
  "model": "opencode-go/deepseek-v4-flash"   # fast, cheap
  "model": "opencode-go/qwen3.6-plus"         # stronger reasoning
  "model": "opencode-go/kimi-k2.6"            # very good at code
}
```

---

## Model comparison for code review

| Model | Cost | Speed | Review quality | Security audit |
|---|---|---|---|---|
| `ollama/qwen2.5-coder:14b` | Free | Slow (local) | ★★★★ | ★★★ |
| `ollama/qwen2.5-coder:7b` | Free | Medium (local) | ★★★ | ★★★ |
| `openrouter/qwen/qwen-2.5-coder-32b:free` | Free | Fast | ★★★★ | ★★★ |
| `openrouter/google/gemini-flash-1.5` | Free | Very fast | ★★★★ | ★★★★ |
| `opencode-go/deepseek-v4-flash` | ~$0.01/review | Fast | ★★★★ | ★★★★ |
| `opencode-go/kimi-k2.6` | ~$0.05/review | Medium | ★★★★★ | ★★★★★ |
| `anthropic/claude-sonnet-4-5` | ~$0.10/review | Fast | ★★★★★ | ★★★★★ |

For most teams: start with Gemini Flash (free, fast, good). Upgrade to a paid model for security audits on important code.

---

## Switching models mid-session

In the OpenCode TUI, press `/models` to switch models without restarting. Useful for:
- Quick review with a free model → detailed security audit with a stronger model
- Comparing results from two models on the same diff
