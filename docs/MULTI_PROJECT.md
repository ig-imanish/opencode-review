# Using opencode-review across multiple projects

## How it works

The commands (`/review`, `/review-security`, `/explain`, `/init-context`) live **globally** — installed once, available everywhere.

The `CONTEXT.md` lives **per project** — each project has its own, describing its own stack and conventions.

```
~/.config/opencode/commands/     ← commands (installed once globally)
  review.md
  review-security.md
  explain.md
  init-context.md
  update-context.md

~/projects/
  my-go-api/
    CONTEXT.md                   ← describes this Go project specifically
    .opencode/config.json        ← optional: use a different model for this project

  my-nextjs-app/
    CONTEXT.md                   ← describes this Next.js project specifically

  my-django-api/
    CONTEXT.md                   ← describes this Django project specifically
```

---

## Setup (one time)

Install commands globally so every project gets them:

```bash
curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash
```

That's it. Now every project on your machine has access to all commands.

---

## Adding a new project (30 seconds)

```bash
cd ~/projects/my-new-project
opencode
```

Then inside OpenCode:
```
/init-context
```

That's it. OpenCode reads your project, generates a filled `CONTEXT.md` specific to your stack, and tells you what to verify.

---

## Per-project model config (optional)

If you want different models for different projects — a fast free model for small projects, a stronger model for security-sensitive ones:

```bash
# In your project root
mkdir -p .opencode
nano .opencode/config.json
```

```json
{
  "model": "ollama/qwen2.5-coder:7b"
}
```

For a security-sensitive project:
```json
{
  "model": "openrouter/google/gemini-flash-1.5"
}
```

OpenCode reads the nearest `config.json` first, so per-project config overrides global config.

---

## Workflow for each project

**First time in a project:**
```bash
cd ~/projects/my-project
opencode
> /init-context        # generates CONTEXT.md automatically
```
Review the generated `CONTEXT.md`, correct anything wrong, commit it:
```bash
git add CONTEXT.md
git commit -m "chore: add opencode-review context"
```

**Daily use:**
```bash
# make your code changes, then:
opencode
> /review              # before committing
> /review-security     # before merging to main
```

**After a big refactor or adding new tech:**
```bash
opencode
> /update-context      # refreshes CONTEXT.md to match what changed
```

---

## Committing CONTEXT.md

Commit `CONTEXT.md` to your repo. This way:
- The whole team gets smart reviews, not just you
- The AI learns your team's conventions, not just yours
- New team members can run `/explain` and get full codebase understanding instantly

```bash
# Add to your repo
git add CONTEXT.md
git commit -m "chore: add opencode-review context"
git push
```

The commands themselves don't need to be committed — each dev installs globally once.

---

## Team setup

Share this with your team. Each person runs the global install once:

```bash
curl -fsSL https://raw.githubusercontent.com/ig-imanish/opencode-review/main/install.sh | bash
```

Then `CONTEXT.md` in the repo is shared — everyone benefits from the same project context.

---

## Quick reference

| Situation | Command |
|---|---|
| First time in a project | `/init-context` |
| Before committing code | `/review` |
| Before merging to main | `/review-security` |
| New team member onboarding | `/explain` |
| After a big refactor | `/update-context` |
| Understanding one specific flow | `/explain how does [feature] work` |
| Reviewing one file | `/review focus only on path/to/file` |
