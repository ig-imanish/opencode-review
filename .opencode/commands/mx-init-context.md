---
description: Generate CONTEXT.md for this project — run this first before /review
---

<role>
You are a senior engineer onboarding yourself to a new codebase. Your job is to read this project thoroughly and then generate a fully filled-in CONTEXT.md that will make future AI code reviews accurate and useful. You may create and edit files.
</role>

<instructions>
Do this in order. Do not skip steps.

**Step 1 — Read the project**

Explore the codebase to understand it:
- Read package.json / go.mod / pyproject.toml / Cargo.toml / Gemfile (whatever exists) — get the language, runtime, framework, dependencies
- Read the entry point (main.go, src/index.ts, app.py, server.js, etc.)
- Read the folder structure — understand what lives where
- Read 2-3 representative files from each major layer (routes/handlers, services, DB layer, models)
- Read existing tests to understand coverage and patterns
- Read any existing README, .env.example, or docs/

**Step 2 — Detect patterns**

From what you read, determine:
- Error handling style (how are errors thrown/returned/wrapped?)
- Where DB queries happen (repo layer? directly in handlers? ORM?)
- How auth works (middleware? decorators? manual checks?)
- How input is validated (zod? pydantic? manual? none?)
- Naming conventions (file names, function names, DB column names)
- Anything that looks unusual but is probably intentional

**Step 3 — Write CONTEXT.md**

Create or overwrite `CONTEXT.md` in the project root with a fully filled-in version.

**Step 4 — Add CONTEXT.md to .gitignore**

Check if `.gitignore` exists in the project root. If it does, append `CONTEXT.md` to it on its own line if it is not already present. If `.gitignore` does not exist, do nothing — do not create one.

**Step 5 — Tell the user what you found and what to verify**

After writing CONTEXT.md (and updating .gitignore if applicable), print a short summary:

```
CONTEXT.md generated.

Detected:
- Language: [x]
- Framework: [x]  
- [key findings]

Please verify these — I may have missed things:
- [anything you weren't sure about]
- [any sections you left empty and why]

Next steps:
1. Review CONTEXT.md and correct anything wrong
2. Add anything specific to your team's conventions I couldn't detect
3. Run /review to test a code review with this context
```
</instructions>

<important>
- Actually read the files — do not guess or hallucinate the stack.
- Write real, specific content in CONTEXT.md — not placeholders.
- If a section genuinely doesn't apply (e.g. no queue system), omit it entirely rather than writing "none".
- The output CONTEXT.md should be immediately useful — someone reading it should instantly understand how this codebase works.
</important>
