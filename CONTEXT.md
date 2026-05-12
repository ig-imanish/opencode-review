# Project context for opencode-review
# 
# This file is read automatically before every /review, /review-security, and /explain session.
# The more you fill in, the smarter and more accurate the reviews become.
#
# Run /init-context inside OpenCode to auto-generate this from your project.
# Run /update-context to refresh it after major changes.

## What this project is
<!-- Auto-detected or fill in: what does it do, who uses it, what's the scale -->


## Tech stack
<!-- Fill what applies, delete the rest -->
- **Language:**          # e.g. TypeScript, Go, Python, Rust, Java
- **Runtime/Version:**   # e.g. Node 20, Go 1.22, Python 3.12
- **Framework:**         # e.g. Express, FastAPI, Gin, Rails, Django, Next.js
- **Database:**          # e.g. PostgreSQL 15, MongoDB, SQLite, Redis
- **ORM/Query builder:** # e.g. Prisma, SQLAlchemy, GORM, ActiveRecord
- **Auth:**              # e.g. JWT, OAuth2, session cookies, Clerk, Auth0
- **Queue/Jobs:**        # e.g. BullMQ, Celery, Sidekiq, none
- **Infra/Deploy:**      # e.g. Docker + Railway, Vercel, AWS Lambda, bare VPS
- **Testing:**           # e.g. Jest, Vitest, pytest, Go test, RSpec

## Project structure
<!-- Describe the main folders and what lives where -->
<!-- Example:
src/
  routes/     → HTTP handlers (thin, no business logic)
  services/   → business logic
  db/         → all database queries
  middleware/ → auth, logging, validation
  types/      → shared TypeScript types
tests/        → integration tests (need running DB)
-->


## Architecture style
<!-- Delete what doesn't apply -->
- [ ] Monolith
- [ ] Monorepo (list packages: )
- [ ] Microservices (list services: )
- [ ] Serverless / edge functions
- [ ] MVC
- [ ] Layered (handler → service → repo)
- [ ] Domain-driven

## Coding conventions

### Error handling
<!-- How errors should be handled in this codebase -->
<!-- Examples:
  Node:   throw new AppError('message', 400) — never throw plain Error
  Go:     return fmt.Errorf("context: %w", err) — always wrap
  Python: raise ValueError("message") — log at the boundary, not inside
-->


### Validation
<!-- Where and how input is validated -->
<!-- Examples:
  We use zod on every route handler before touching the DB
  We use pydantic models for all request bodies
  express-validator middleware on all POST/PUT routes
-->


### Auth pattern
<!-- How auth works in this codebase -->
<!-- Examples:
  JWT in Authorization header — middleware extracts user and adds to req.user
  Session cookie — requireAuth() middleware applied to all routes except /public/*
  All endpoints need auth unless explicitly decorated with @public
-->


### Database access pattern
<!-- Rules about how DB is accessed -->
<!-- Examples:
  All queries go through src/db/ — never query directly in routes or services
  Use Prisma — no raw SQL unless in src/db/raw/
  Repository pattern — one file per model in internal/repo/
-->


### Naming conventions
<!-- Examples:
  Files: kebab-case (user-service.ts)
  Functions: camelCase
  DB tables: snake_case, plural (user_sessions)
  Env vars: SCREAMING_SNAKE_CASE, all in .env.example
-->


## What /review should always flag
<!-- Things you want caught every single time, no exceptions -->
<!-- Examples:
  Any hardcoded URL, token, or password
  Any console.log left in production code paths
  Any TODO older than the current sprint
  Direct DB access outside the db/ layer
  Missing input validation on any new endpoint
-->


## What /review should ignore
<!-- Reduce noise — things that look wrong but are fine -->
<!-- Examples:
  legacy/ directory — not being maintained
  *.generated.ts files — auto-generated, don't review
  migrations/ — reviewed separately
  vendor/ or node_modules/ — obviously
-->


## Security rules specific to this project
<!-- Project-specific security requirements -->
<!-- Examples:
  All user-facing IDs must be UUIDs — never expose sequential integers (IDOR risk)
  File uploads must go through src/upload/validate.ts before saving
  Never log req.body — may contain passwords or PII
  All admin routes must check req.user.role === 'admin' not just req.user
-->


## Known tricky parts
<!-- Things that look wrong but are intentional — prevents false positives -->
<!-- Examples:
  The double-write in session.ts is intentional — handles clock skew
  We use any in src/legacy/ deliberately — being cleaned up in Q3
  The recursive call in parser.ts has a depth limit — not infinite recursion
-->


## Things we're actively improving
<!-- Context for the reviewer — known tech debt, ongoing refactors -->
<!-- Examples:
  Moving from callbacks to async/await — new code should use async/await
  Migrating from REST to tRPC — new endpoints should use tRPC
  Adding zod validation — not all routes have it yet, new ones must
-->
