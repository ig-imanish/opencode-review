# Project context

<!-- 
  This file is read by OpenCode before every AI session.
  Fill it out for your project — the more specific you are,
  the smarter /review, /review-security, and /explain become.
  
  Delete sections that don't apply. Keep entries short and concrete.
-->

## What this project is
<!-- One paragraph. What does it do, who uses it, what stack. -->
<!-- Example: "A SaaS invoicing API built in Go. Exposes REST endpoints consumed by a React frontend. Uses PostgreSQL for storage, Redis for sessions, and Stripe for payments." -->


## Tech stack
- **Language:** 
- **Framework:** 
- **Database:** 
- **Auth:** 
- **Infra:** 

## Architecture
<!-- Brief description of the layers or modules. -->
<!-- Example: "cmd/ → entrypoint, internal/handler → HTTP layer, internal/service → business logic, internal/repo → DB queries" -->


## Coding conventions

### Error handling
<!-- How errors should be wrapped, returned, and logged in this codebase. -->
<!-- Example: "Always wrap with context: fmt.Errorf("doing X: %w", err). Never swallow errors silently." -->


### Naming
<!-- Any naming conventions beyond language defaults. -->
<!-- Example: "DB models are in models/, suffixed with Model (UserModel). API response types are in types/, no suffix." -->


### Patterns to follow
<!-- Project-specific patterns that reviewers should enforce. -->
<!-- Example:
- All DB queries go through the repository layer, never directly in handlers
- All endpoints require auth middleware unless explicitly marked `// public`
- Background jobs must be idempotent
-->


### Patterns to avoid
<!-- Anti-patterns specific to this project. -->
<!-- Example:
- Don't use global state outside of main.go
- Don't call external APIs directly from handlers — use the service layer
- Don't write raw SQL strings — use the query builder in internal/db
-->


## Security rules
<!-- Project-specific security requirements for the reviewer to check. -->
<!-- Example:
- All user-facing IDs must be UUIDs, never sequential integers (IDOR risk)
- File uploads must be validated against the allowlist in internal/upload/validate.go
- Never log request bodies — they may contain PII
-->


## Testing conventions
<!-- What tests exist, where they live, what counts as enough coverage. -->
<!-- Example:
- Unit tests: *_test.go next to the file being tested
- Integration tests: tests/integration/ — require a running DB
- Every handler must have at least one happy-path and one error-path test
-->


## Things that look odd but are intentional
<!-- Patterns that might trigger a false-positive review finding. -->
<!-- Example:
- The double-write to Redis in session.go is intentional — it handles clock skew
- We use panic() in the config loader deliberately — misconfiguration should crash on startup
-->


## What /review should be strict about
<!-- Specific things you want the reviewer to flag every time, even for INFO. -->
<!-- Example:
- Any hardcoded string that looks like a URL or env value
- Any function longer than 60 lines
- Any exported function missing a doc comment
-->


## What /review should ignore
<!-- Things that would otherwise generate noise. -->
<!-- Example:
- The legacy/ directory is not being maintained — skip it
- Ignore line length in generated files (*.pb.go, *_gen.go)
-->
