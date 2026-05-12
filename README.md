# opencode-review

> AI-powered code review, security audit, and codebase explainer — built entirely inside [OpenCode](https://opencode.ai). No separate tool. No subscription. Works with free models.

Drop these files into any project and get `/review`, `/review-security`, and `/explain` commands inside OpenCode's TUI.

---

## What this is

A set of production-grade OpenCode custom commands and a project context template that turn OpenCode into a serious code review tool. It uses OpenCode's existing context — your git diff, open files, LSP diagnostics, file tree, import graph — so the AI has full project understanding before it says anything.

**Three commands:**

| Command | What it does |
|---|---|
| `/review` | Full review: bugs, security, performance, style, tests |
| `/review-security` | Focused security audit: injection, auth, secrets, data exposure |
| `/explain` | Deep codebase explanation: architecture, data flow, patterns, where to find things |

**Works with free models:**
- `ollama/qwen2.5-coder:7b` — completely free, runs locally
- `openrouter/google/gemini-flash-1.5` — free tier, very capable
- `opencode-go/deepseek-v4-flash` — fast, cheap via OpenCode Go
- Any model OpenCode supports (Claude, GPT-4, Gemini Pro, etc.)

---

## Installation

### Option A — one-liner (recommended)

**Install globally** (works in every project):
```bash
curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash
```

**Install into current project only:**
```bash
curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash -s -- --project
```

### Option B — manual

```bash
git clone https://github.com/ig-imanish/opencode-review.git
cp -r opencode-review/.opencode YOUR_PROJECT/.opencode
cp opencode-review/CONTEXT.md YOUR_PROJECT/CONTEXT.md
```

---

## Setup

### 1. Install OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
# or
npm i -g opencode-ai@latest
```

### 2. Configure a free model

**Option A — Ollama (completely free, local, private)**

```bash
curl -fsSL https://ollama.ai/install.sh | bash
ollama pull qwen2.5-coder:7b
```

Then set in `.opencode/config.json`:
```json
{ "model": "ollama/qwen2.5-coder:7b" }
```

**Option B — OpenRouter free tier**

```bash
export OPENROUTER_API_KEY=sk-or-...   # free key at openrouter.ai
```

Then set in `.opencode/config.json`:
```json
{ "model": "openrouter/google/gemini-flash-1.5" }
```

**Option C — Google AI Studio (free, no credit card)**

```bash
export GOOGLE_API_KEY=...   # free key at aistudio.google.com/apikey
```

Then set in `.opencode/config.json`:
```json
{ "model": "google/gemini-1.5-flash" }
```

### 3. Fill in CONTEXT.md

Open `CONTEXT.md` and describe your project's conventions — this is what makes the review smart instead of generic:

```markdown
## What this project is
A SaaS billing API in Go. REST endpoints, PostgreSQL, Stripe.

## Coding conventions
- Errors wrapped with fmt.Errorf("doing X: %w", err)
- All DB queries go through internal/repo, never directly in handlers
- Every endpoint requires auth middleware unless marked `// public`
```

### 4. Run it

```bash
cd your-project
opencode
```

Type `/review`, `/review-security`, or `/explain` in the TUI.

---

## How it works

OpenCode already collects full project context before any session — git diff, open files, LSP diagnostics, file tree, import graph, and your `CONTEXT.md`. The commands add structured prompting on top, telling the model exactly what to look for, how to format findings, and what severity means.

```
You type /review
       ↓
OpenCode loads context (diff + files + LSP + CONTEXT.md)
       ↓
Structured review prompt fires in Plan mode (read-only)
       ↓
Findings sorted by severity with concrete fix suggestions
```

No external API calls. No separate process. No code leaves your machine (with Ollama).

---

## Usage

### Review before a PR
```bash
git add .
opencode
> /review
```

### Security audit on sensitive changes
```bash
opencode
> /review-security
```

### Understand a new codebase
```bash
cd some-project-you-just-cloned
opencode
> /explain
```

### Narrow the scope
You can append instructions to any command:
```
> /review — focus only on src/auth/middleware.go
> /review-security — ignore the legacy/ directory
> /explain — focus on how the payment flow works
```

---

## Project structure

```
opencode-review/
├── .opencode/
│   ├── commands/
│   │   ├── review.md            # /review — full code review
│   │   ├── review-security.md   # /review-security — security audit
│   │   └── explain.md           # /explain — codebase explanation
│   └── config.json              # OpenCode config with free model setup
├── CONTEXT.md                   # Project conventions template (fill this in)
├── install.sh                   # One-liner installer
├── README.md                    # This file
└── docs/
    ├── CUSTOMISING.md           # How to write your own commands
    ├── FREE_MODELS.md           # Guide to free model options
    └── EXAMPLES.md              # Example review outputs
```

---

## Customising

The commands are plain markdown files — edit them for your team.

Add framework-specific rules to the checklist in `review.md`:
```markdown
**Django-specific**
- QuerySet evaluated in a loop without select_related
- Missing @login_required on views
- Migration missing on model field change
```

Create new commands by adding a `.md` file to `.opencode/commands/`. See [docs/CUSTOMISING.md](docs/CUSTOMISING.md) for a full guide.

---

## Contributing

Contributions welcome — especially:
- Framework-specific review commands (Django, Rails, Next.js, Laravel, Spring...)
- Language-specific rules (Rust, Go, Python, TypeScript...)
- Example outputs for `docs/EXAMPLES.md`
- Improvements to the base prompts

Open an issue before building a large new command so we can align on structure.

---

## Why not just use CodeRabbit / Cursor / etc.?

| | opencode-review | CodeRabbit | Cursor AI |
|---|---|---|---|
| Cost | Free (with free models) | $12–24/mo | $20/mo |
| Private / local | Yes (Ollama) | No | No |
| Open source | Yes | No | No |
| Your project's conventions | Yes (CONTEXT.md) | Limited | Limited |
| Customisable prompts | Fully | Limited | No |
| Works in terminal | Yes | No | No |
| Any AI provider | Yes (75+ via OpenCode) | No | No |

---

## Roadmap

- [ ] `/review-diff` — review only what changed vs main
- [ ] `/review-pr` — output formatted for GitHub PR comments
- [ ] `/changelog` — generate changelog from git history
- [ ] `/init-context` — interactive CONTEXT.md generator
- [ ] GitHub Action for automatic PR review
- [ ] Framework command packs (Django, Rails, Next.js, Laravel)

---

## License

MIT