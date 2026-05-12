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

Use this exact template — fill in every section with real, specific information from what you read. Do not leave placeholder comments. Do not write "unknown" — if you couldn't determine something, omit that line.

Be specific:
- BAD: "Uses a layered architecture"
- GOOD: "HTTP handlers in src/routes/ → business logic in src/services/ → DB queries in src/db/ — handlers should not query DB directly"

BAD: "Error handling uses standard patterns"
GOOD: "All errors thrown as new AppError(message, statusCode) from src/lib/errors.ts — never throw plain Error — caught by global handler in src/middleware/error.ts"

---

Write CONTEXT.md now with this structure:

```
# Project context

## What this project is
[1-2 sentences: what it does, who uses it, rough scale]

## Tech stack
- Language: [exact language + version if detectable]
- Framework: [exact framework + version]
- Database: [DB name + ORM/query builder if any]
- Auth: [exact auth mechanism]
- Testing: [test framework + what's tested]
- [add any other significant deps]

## Project structure
[folder tree with one-line description of what lives in each]

## Architecture
[describe the layers and how a request flows through them — be specific]

## Coding conventions

### Error handling
[exact pattern used in this codebase with a real example]

### Input validation
[where and how — be specific, mention the library]

### Database access
[where queries live, what's allowed, what's not]

### Auth pattern
[how auth works, what middleware/decorator, where it's applied]

### Naming
[file naming, function naming, DB naming]

## What /review should always flag
[list specific things based on this project's actual patterns]

## What /review should ignore
[generated files, legacy dirs, etc.]

## Security rules for this project
[based on what you saw — data model, auth, endpoints]

## Known tricky parts
[anything that looks odd but is intentional — only if you spotted something]

## Active tech debt / refactors in progress
[only if you saw TODOs, deprecated patterns, migration comments]
```

**Step 4 — Tell the user what you found and what to verify**

After writing CONTEXT.md, print a short summary:

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
