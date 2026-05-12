# opencode-review

AI-powered code review, security audit, and codebase explainer — built inside [OpenCode](https://opencode.ai). Drop into any project.

---

## Commands

| Command | What it does |
|---|---|
| `/mx-init-context` | Generate CONTEXT.md from your codebase |
| `/mx-review` | Full review: bugs, security, perf, style, tests |
| `/mx-review-security` | Focused security audit: injection, auth, secrets, data exposure |
| `/mx-explain` | Deep codebase explanation: architecture, data flow, patterns |
| `/mx-fix` | Auto-fix issues found by `/mx-review` |
| `/mx-update-context` | Refresh CONTEXT.md after major changes |

---

## Installation

**Global (recommended):**
```bash
curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/refs/heads/main/install.sh | bash
```

**Per project:**
```bash
curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/refs/heads/main/install.sh| bash -s -- --project
```

**Manual:**
```bash
git clone https://github.com/ig-imanish/opencode-review.git
cp -r opencode-review/.opencode YOUR_PROJECT/.opencode
```

---

## Setup

1. **Install OpenCode** — [opencode.ai](https://opencode.ai)
2. **Configure a model** — [How to link any model](https://docs.opencode.ai/providers)
3. **Run** — `opencode`, then type `/mx-init-context` or any command above

---

## Manual CONTEXT.md editing

Open `CONTEXT.md` in your project root and fill in your project conventions:

```markdown
## What this project is
A SaaS billing API in Go. REST endpoints, PostgreSQL, Stripe.

## Coding conventions
- Errors wrapped with fmt.Errorf("doing X: %w", err)
- All DB queries go through internal/repo, never directly in handlers
- Every endpoint requires auth middleware unless marked `// public`
```

---

## How it works

```
You type /mx-review
        ↓
OpenCode loads context (git diff + files + LSP + CONTEXT.md)
        ↓
Structured review prompt fires (read-only)
        ↓
Findings sorted by severity with concrete fix suggestions
```

---

## Customising

Commands are plain markdown files in `.opencode/commands/`. Edit them to match your team's conventions. See `docs/CUSTOMISING.md` for details.

---

## Sponsor

- [Buy Me a Coffee](https://buymeacoffee.com/Manixh02)
- [GitHub Sponsors](https://github.com/sponsors/ig-imanish)

---

## License

MIT
