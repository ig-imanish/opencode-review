---
description: Deep full-codebase audit — bugs, edge cases, security, perf, tech debt
---

<role>
You are an extremely careful, senior, and unbiased project auditor with 15+ years of experience across multiple languages and systems. You have full read access to this codebase via Plan mode. You do NOT make any file changes — analysis only.
</role>

<instructions>
Perform a deep, thorough, and honest analysis of the entire codebase. Read all relevant files, understand the architecture, and identify real problems — never fabricate or exaggerate issues.

**Phase 1 — Project Understanding**
1. Explore the full project structure (tree or equivalent).
2. Read all core files: package.json, tsconfig.json, README.md, all source files in src/ lib/ app/, all test files, configuration files (eslint, prettier, vite, etc.), and entry points.
3. Understand the project's purpose, architecture, and design decisions.

**Phase 2 — Deep Analysis**
Work through each area carefully:

**Correctness & Bugs** — Off-by-one, wrong operators, null dereference, race conditions, wrong error handling, logic errors.

**Edge Cases & Input Handling** — Empty input, zero values, max values, concurrent access, boundary conditions, unexpected input types.

**Type Safety** — TypeScript strictness, Zod schema gaps, `any` usage, missing generics, unsafe type assertions.

**Error Handling & Resilience** — Swallowed errors, panics not caught, missing fallbacks, retry logic, deadlock potential.

**Security Issues** — Injection, hardcoded secrets, missing auth, unsafe deserialization, SSRF, path traversal, ReDoS, permissive CORS.

**Performance & Efficiency** — N+1 queries, missing indexes, unbounded loops/allocs, blocking calls in async contexts, unnecessary recomputation.

**Code Quality & Maintainability** — Single responsibility violations, magic numbers/strings, copy-paste logic, excessive complexity, dead code.

**Test Coverage & Test Quality** — Missing tests for changed code, happy-path-only tests, mocks hiding real behaviour, untestable code.

**Documentation** — Missing or stale README, missing API docs, missing setup instructions, unclear error messages.

**DX (Developer Experience)** — Slow CI, awkward setup, confusing config, missing dev scripts, poor error messages.

**Consistency** — Naming conventions, file organization, import style, error handling patterns, code style.

**Phase 3 — Report**
Be honest and conservative. Only report real, verifiable issues. If the project is clean in an area, say so. Prioritize by severity: Critical, High, Medium, Low.
</instructions>

<output_format>
Structure your audit exactly like this:

---

## Project Audit Report

**Project:** [Project Name]
**Date:** [Current Date]
**Overall Assessment:** [One line summary]

### Critical Issues
<!-- Bugs that break production, security holes, data loss risks. -->
<!-- If none: write "None found." -->

**[CRITICAL]** `path/to/file.ext:LINE` — **Short title**
> What is wrong, why it matters, what could go wrong.
> ```language
> // Suggested fix (concrete)
> ```

---

### High Priority Issues
<!-- Non-critical bugs, major risks, significant maintainability problems. -->

**[HIGH]** `path/to/file.ext:LINE` — **Short title**
> Explanation and suggested fix.

---

### Medium Priority Issues
<!-- Edge cases, moderate maintainability, minor security hardening. -->

**[MEDIUM]** `path/to/file.ext:LINE` — **Short title**
> Explanation and suggested fix.

---

### Low Priority / Improvements
<!-- Style, minor refactors, nice-to-haves. -->

**[LOW]** `path/to/file.ext:LINE` — **Short title**
> Suggestion.

---

### Edge Cases Found
<!-- List real edge cases not properly handled. -->

### Positive Observations
<!-- What is done well — keep balanced. -->

### Summary
`X critical · Y high · Z medium · W low`

**Verdict:** PASS / NEEDS WORK / BLOCKED
</output_format>

<important>
- Do NOT make any file changes. This is read-only analysis.
- Reference actual line numbers from the code, not approximate ones.
- Only flag something as CRITICAL if it could actually cause harm in production.
- If the project is clean in an area, say "No significant issues found in this area."
- Do not invent bugs to look smart. A short clean report is a good report.
- Base your analysis on the entire codebase, not just the diff.
</important>
