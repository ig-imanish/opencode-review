# Project context

## What this project is

A meta-project: a set of OpenCode custom commands (`/review`, `/review-security`, `/explain`, `/init-context`, `/update-context`) plus a `CONTEXT.md` template. When dropped into any target project, it turns OpenCode into a code review tool. The project itself has no runtime — it's a configuration/asset package.

## Tech stack

- **Language:** Bash (install.sh) + Markdown (commands/docs)
- **Framework:** OpenCode custom commands (no framework)
- **Dependencies:** @opencode-ai/plugin (for running as an OpenCode plugin)
- **Config:** JSON (config.json)

## Project structure

```
.opencode/
  commands/          → slash commands (review.md, review-security.md, explain.md, init-context.md, update-context.md)
  config.json        → OpenCode model config (defaults to openrouter/google/gemini-flash-1.5)
  .gitignore         → ignores node_modules/
  package.json       → declares @opencode-ai/plugin dependency

CONTEXT.md           → template for users to fill in (describes their target project)

install.sh           → one-liner installer (global or per-project)

docs/
  CUSTOMISING.md     → how to add framework-specific rules to review.md
  EXAMPLES.md        → example review outputs
  FREE_MODELS.md     → guide to free model options
  MULTI_PROJECT.md   → workflow for using commands across many projects
```

## Architecture

This is not an application — it's a command package. The architecture is the command pipeline:

```
User runs /review
        ↓
OpenCode loads context (git diff + open files + LSP + CONTEXT.md)
        ↓
review.md prompt fires (read-only, Plan mode)
        ↓
Model produces structured review output
```

No runtime. No DB. No auth. The "code" is the markdown prompts themselves.

## Coding conventions

### File naming
- Command files: kebab-case, .md extension (review.md, review-security.md)
- Config: config.json (lowercase, not camelCase)
- Docs: Title Case (CUSTOMISING.md, EXAMPLES.md)

### Shell scripts
- bash with `set -e`
- Color codes via ANSI escape variables
- Commands installed globally → `~/.config/opencode/commands/` or per-project → `.opencode/commands/`

### Markdown prompts
- XML-style sections: `<role>`, `<instructions>`, `<output_format>`, `<review_checklist>`, `<important>`
- Frontmatter: `description` field required
- Severity levels: CRITICAL → WARN → INFO (review.md), CRITICAL → HIGH → MEDIUM (review-security.md)

### No runtime code
- There is no application code in this project
- No tests (no test framework)
- No build step
- No bundling

## What /review should always flag

This project is reviewed for its **prompt quality and correctness**, not runtime behavior:

- Broken markdown syntax in command files
- Inconsistent severity levels or output format
- Missing or wrong file references in docs
- install.sh curl URLs pointing to wrong branch/paths
- Commands that contradict each other

## What /review should ignore

- `opencode-review/` subdirectory (git worktree, not part of this project)
- `node_modules/` (auto-generated)
- `.git/` (obvious)
- The CONTEXT.md template (it's a template for users, not code)

## Security rules for this project

- install.sh uses `curl | bash` — this is intentional for the installer pattern, but the raw URL must be trusted (ig-imanish/opencode-review)
- Commands have no file write access — they're read-only analysis
- No secrets stored anywhere

## Known tricky parts

- The `init-context.md` command is itself the onboarding tool — running it generates CONTEXT.md. This creates a self-referential setup.
- The `opencode-review/` subdirectory at the repo root is a git worktree artifact from how the project is developed — ignore it.
- CONTEXT.md is a template (comments in it) that users fill in — do not review it as if it's real documentation.

## Active tech debt / refactors in progress

- Roadmap items from README: `/review-diff`, `/review-pr`, `/changelog`, GitHub Action, framework command packs
- No active migrations — this project is stable
- The .opencode/package.json and node_modules exist only to support running as an OpenCode plugin — the actual deliverable is the commands directory and install.sh