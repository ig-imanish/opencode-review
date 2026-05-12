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

### 1. Install OpenCode

```bash
curl -fsSL https://opencode.ai/install | bash
# or
npm i -g opencode-ai@latest
```

### 2. Add the commands to your project

```bash
# Clone this repo
git clone https://github.com/YOUR_USERNAME/opencode-review.git

# Copy the commands into your project
cp -r opencode-review/.opencode YOUR_PROJECT/.opencode

# Copy the CONTEXT.md template
cp opencode-review/CONTEXT.md YOUR_PROJECT/CONTEXT.md
```

Or install globally so every project gets the commands:

```bash
# On macOS/Linux
mkdir -p ~/.config/opencode/commands
cp opencode-review/.opencode/commands/* ~/.config/opencode/commands/
```

### 3. Configure a free model

**Option A — Ollama (completely free, local, private)**

```bash
# Install Ollama
curl -fsSL https://ollama.ai/install.sh | bash

# Pull a coding model
ollama pull qwen2.5-coder:7b

# Update .opencode/config.json
# Set "model": "ollama/qwen2.5-coder:7b"
```

**Option B — OpenRouter free tier**

```bash
# Get a free API key at openrouter.ai
export OPENROUTER_API_KEY=sk-or-...

# Update .opencode/config.json
# Set "model": "openrouter/google/gemini-flash-1.5"
```

**Option C — OpenCode Go ($5 first month)**

```bash
# Subscribe at opencode.ai/go, get your key
# Run /connect inside OpenCode TUI and select OpenCode Go
# Set "model": "opencode-go/deepseek-v4-flash"
```

### 4. Fill in CONTEXT.md

Open `CONTEXT.md` in your project and fill in your project's conventions, patterns, and rules. This is what makes the review understand *your* codebase instead of giving generic advice.

```markdown
## What this project is
A SaaS billing API in Go. REST endpoints, PostgreSQL, Stripe.

## Coding conventions
- Errors wrapped with fmt.Errorf("doing X: %w", err)
- All DB queries go through internal/repo, never directly in handlers
- Every endpoint requires auth middleware unless marked `// public`
```

### 5. Run it

```bash
cd your-project
opencode
```

Then type `/review`, `/review-security`, or `/explain` in the TUI.

---

## How it works

OpenCode already collects full project context before any session:
- Git diff of staged/changed files
- Open file contents
- LSP diagnostics (type errors, lint warnings)
- File tree and import graph
- Your `CONTEXT.md` project conventions

The commands add structured prompting on top of that context — telling the model exactly what to look for, how to format findings, and what severity means. No external API calls. No code leaves your machine (with Ollama). No separate process to run.

```
You type /review
       ↓
OpenCode loads context (diff + files + LSP + CONTEXT.md)
       ↓
Structured review prompt fires in Plan mode (read-only)
       ↓
Model returns findings sorted by severity with concrete fixes
```

---

## Usage examples

### Review before a PR

```bash
# Stage your changes
git add .

# Open OpenCode and review
opencode
> /review
```

### Security check on auth changes

```bash
opencode
> /review-security
```

### Onboard to a new codebase

```bash
cd some-project-you-just-cloned
opencode
> /explain
```

### Review a specific file

```bash
opencode
> /review — focus only on src/auth/middleware.go
```

You can append natural language instructions to any command.

---

## Customising the commands

The commands are just markdown files. Edit them for your team's needs.

**Add your own checklist items to `/review`:**

```markdown
<!-- Add to the review_checklist section -->
**Project-specific**
- All new endpoints must be registered in the OpenAPI spec
- Background jobs must call job.Heartbeat() every 30 seconds
```

**Create a command for your stack:**

```bash
# .opencode/commands/review-django.md
---
description: Django-specific review — ORM, views, serializers, migrations
---
[prompt focused on Django patterns]
```

**Create a pre-commit hook:**

```bash
# .git/hooks/pre-push
#!/bin/bash
echo "Running security review..."
opencode -p "$(cat .opencode/commands/review-security.md)" --format json
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
├── README.md                    # This file
└── docs/
    ├── CUSTOMISING.md           # How to write your own commands
    ├── FREE_MODELS.md           # Guide to free model options
    └── EXAMPLES.md              # Example review outputs
```

---

## Contributing

This is designed to be a community-maintained prompt library. Contributions welcome:

- Better prompts for specific languages or frameworks (Go, Django, Rails, Next.js...)
- Additional command ideas (`/review-perf`, `/review-accessibility`, `/changelog`...)
- Example outputs showing real reviews
- Translations of CONTEXT.md template

Open an issue to discuss before building a large new command.

### How to contribute a command

1. Fork this repo
2. Create `.opencode/commands/YOUR-COMMAND.md`
3. Follow the structure of the existing commands (role, instructions, output_format, important)
4. Add an example output to `docs/EXAMPLES.md`
5. Open a PR with a description of what it reviews and why

---

## Roadmap

- [ ] Language-specific review commands (Go, Python, TypeScript, Rust...)
- [ ] Framework-specific commands (Next.js, Django, Rails, Laravel...)
- [ ] `review-diff` — review only what changed vs main branch
- [ ] `review-pr` — formatted for copy-pasting into GitHub PR comments
- [ ] `changelog` — generate changelog from git history
- [ ] GitHub Action that runs `/review-security` on every PR
- [ ] Interactive CONTEXT.md generator (`/init-context` command)

---

## Why not just use CodeRabbit / Cursor / etc.?

| | opencode-review | CodeRabbit | Cursor AI |
|---|---|---|---|
| Cost | Free (with free models) | $12-24/mo | $20/mo |
| Private / local | Yes (Ollama) | No | No |
| Open source | Yes | No | No |
| Customisable prompts | Fully | Limited | No |
| Works in terminal | Yes | No | No |
| Your project's conventions | Yes (CONTEXT.md) | Limited | Limited |
| Any AI provider | Yes (75+ via OpenCode) | No | No |

---

## License

MIT — do whatever you want with it.
