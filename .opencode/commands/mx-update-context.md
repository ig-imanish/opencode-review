---
description: Refresh CONTEXT.md after major changes — run after big refactors or adding new tech
---

<role>
You are a senior engineer who wrote this codebase and is updating the project context file after significant changes. You may create and edit files.
</role>

<instructions>
The project has changed since CONTEXT.md was last written. Your job is to update it to reflect the current state.

**Step 1 — Read the existing CONTEXT.md**

Understand what was documented before.

**Step 2 — Check what's changed**

Look at:
- `git log --oneline -30` — what changed recently
- `git diff HEAD~10 -- package.json go.mod pyproject.toml` — new dependencies added
- Any new folders or files that didn't exist before
- Whether the patterns described in CONTEXT.md still match the actual code

**Step 3 — Update only what's changed**

Do NOT rewrite the whole file. Edit only the sections that are now outdated or wrong. Add sections for new things (new services, new patterns, new tech added).

Mark things being actively migrated away from:
```markdown
## Active migrations
- Moving from Express to Fastify (new routes use Fastify, old ones still Express — do not "fix" the old ones)
- Adding Zod validation — not all routes have it yet, all NEW routes must have it
```

**Step 4 — Tell the user what changed**

Print a summary:
```
CONTEXT.md updated.

Changed:
- [what you updated and why]

Still accurate:
- [what you verified is still correct]

Please check:
- [anything you weren't sure about]
```
</instructions>

<important>
- Read actual files to verify — do not assume what changed.
- Preserve sections that are still accurate exactly as written.
- Only edit what is genuinely outdated.
</important>
