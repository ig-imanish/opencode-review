# Customising commands

## Command file structure

Every command is a markdown file in `.opencode/commands/`. The filename becomes the slash command — `review.md` → `/review`.

The frontmatter `description` field is shown in the OpenCode command picker.

```markdown
---
description: What this command does (shown in /help)
---

Your prompt here.
```

## Anatomy of a good review prompt

The existing commands use XML-style sections. This is intentional — language models parse structured prompts more reliably than plain prose.

```markdown
---
description: Short description for the command picker
---

<role>
Who the model is playing. Be specific — "senior engineer" is vague,
"principal backend engineer reviewing a Go service that processes payments" is useful.
Include: read-only (Plan mode), no file changes.
</role>

<instructions>
What to do at a high level. What context to use. What to focus on.
</instructions>

<output_format>
Exactly how to format the output. Include headers, severity labels,
code block syntax. The more specific, the more consistent the output.
</output_format>

<checklist>
Itemised list of things to check. This is where you add your
project-specific or framework-specific rules.
</checklist>

<important>
Hard constraints. "Do NOT make file changes" must always be here.
</important>
```

## Adding framework-specific rules

Edit the `<review_checklist>` section in `review.md` and add a block:

```markdown
**Django-specific**
- QuerySet evaluated in a loop without select_related/prefetch_related
- Raw SQL via .raw() or cursor.execute() without parameterisation  
- Missing @login_required or permission_classes on views
- Serializer with no field allowlist (all fields exposed by default)
- Migration missing on model field change
```

```markdown
**Next.js-specific**
- Server component fetching data that changes per-request without cache: 'no-store'
- Client component importing a server-only module
- API route missing input validation with zod or equivalent
- getServerSideProps when getStaticProps would work (unnecessary SSR)
```

## Creating new commands

### `/review-diff` — only review what changed vs main

```markdown
---
description: Review only the diff against main branch
---

<role>
You are a senior code reviewer. Read-only — no file changes.
</role>

<instructions>
Review ONLY the lines added or changed in the current git diff vs main.
Do not comment on surrounding unchanged code unless it directly affects
the correctness of the changed lines.

Focus: what did this PR change, and does it look correct and safe?
</instructions>

[... output_format same as review.md ...]
```

### `/changelog` — generate changelog from git history

```markdown
---
description: Generate a changelog from recent git commits
---

<role>
You are a technical writer generating a changelog.
</role>

<instructions>
Read the git log for the last 20 commits. Group changes into:
- Features (new user-facing capability)
- Fixes (bug fixes)
- Breaking changes (API changes, config changes, removed features)
- Internal (refactoring, deps, CI — end users don't care)

Write in the style of the existing CHANGELOG.md if one exists.
Use plain English, not commit message jargon.
</instructions>

<output_format>
## [Unreleased]

### Features
- ...

### Fixes
- ...

### Breaking changes
- ...
</output_format>
```

### `/review-pr` — formatted for GitHub PR comments

```markdown
---
description: Review formatted for pasting into a GitHub PR
---

Same as /review but output format uses GitHub markdown:
- No headers (GitHub collapses them weirdly in PR comments)  
- Use > blockquotes for code suggestions
- Use task list checkboxes: - [ ] for required fixes, - [x] for done
</output_format>
```

## Global vs per-project commands

**Per-project** (`.opencode/commands/` in your repo):
- Commands specific to this codebase
- Checked into git so the whole team gets them

**Global** (`~/.config/opencode/commands/`):
- Commands you want in every project
- Not checked into any repo
- Good for generic `/explain`, `/review`, `/review-security`
