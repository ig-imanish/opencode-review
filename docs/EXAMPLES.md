# Example outputs

Real examples of what each command produces. These are representative of what you get with a good `CONTEXT.md` and a capable model.

---

## /review example

**Scenario:** A Go HTTP handler for updating a user's email was changed.

```
## Code review

### Critical issues

**[CRITICAL]** `internal/handler/user.go:47` — **Missing ownership check before update**
> The handler fetches `userID` from the request body instead of from the authenticated session.
> An attacker can update any user's email by sending `{"user_id": "victim-uuid", "email": "attacker@evil.com"}`.
> ```go
> // Before (vulnerable)
> userID := req.Body.UserID
>
> // After — always get the user ID from the verified session
> userID := middleware.GetUserID(r.Context())
> ```

---

### Warnings

**[WARN]** `internal/handler/user.go:52` — **No validation on email format**
> The new email is written to DB without format validation. Could allow malformed emails
> that break downstream systems (email sending, login).
> ```go
> if !isValidEmail(req.Body.Email) {
>     http.Error(w, "invalid email format", http.StatusBadRequest)
>     return
> }
> ```

**[WARN]** `internal/handler/user.go:61` — **Email change not verified**
> Email is updated immediately with no verification step. Best practice is to send
> a confirmation link to the new email before committing the change.
> This is a product decision but worth flagging.

---

### Info

**[INFO]** `internal/handler/user.go:44` — **Function exceeds 60-line convention**
> Per CONTEXT.md this project keeps handlers under 60 lines. This function is 74 lines.
> Consider extracting the validation logic into `validateUpdateEmailRequest()`.

---

### Summary
`1 critical · 2 warnings · 1 info`

**Verdict:** BLOCKED
The IDOR vulnerability on line 47 must be fixed before this can merge.
```

---

## /review-security example

**Scenario:** A new file upload endpoint was added.

```
## Security audit

### Critical vulnerabilities

**[CRITICAL]** `internal/handler/upload.go:23` — **Path traversal via filename**
> **Attack scenario:** Attacker sends a multipart upload with filename `../../etc/passwd`
> or `../config/database.yml`. The handler joins this directly with the upload directory:
> `filepath.Join(uploadDir, header.Filename)`. This resolves outside the intended directory.
> **Impact:** Attacker can overwrite arbitrary files the server process has write access to,
> potentially including config files, SSH keys, or server executables.
> **Fix:**
> ```go
> // Sanitise filename — use only the base, never a path
> safeName := filepath.Base(header.Filename)
> // Also reject names with dots at the start (hidden files)
> if strings.HasPrefix(safeName, ".") {
>     return errors.New("invalid filename")
> }
> dest := filepath.Join(uploadDir, safeName)
> // Double-check the resolved path is still inside uploadDir
> if !strings.HasPrefix(dest, filepath.Clean(uploadDir)+string(os.PathSeparator)) {
>     return errors.New("invalid upload path")
> }
> ```

---

### High severity

**[HIGH]** `internal/handler/upload.go:31` — **No file type validation**
> Only `Content-Type` header is checked, which is attacker-controlled.
> Attacker can upload a PHP/Python/shell script with `Content-Type: image/jpeg`.
> If the upload directory is web-accessible, this enables RCE.
> **Fix:** Validate file magic bytes (first N bytes of content), not just the header.
> Use `http.DetectContentType()` on the file bytes, or a library like `h2non/filetype`.

**[HIGH]** `internal/handler/upload.go:19` — **No file size limit**
> No `MaxBytesReader` or size check. Attacker can upload a multi-GB file to exhaust disk.
> ```go
> r.Body = http.MaxBytesReader(w, r.Body, 10<<20) // 10MB limit
> ```

---

### Medium severity

**[MEDIUM]** `internal/handler/upload.go:45` — **Uploaded files served with MIME sniffing enabled**
> `X-Content-Type-Options: nosniff` header is not set on the file serving route.
> Browsers may execute content as a different type than intended.

---

### Notes
Auth middleware is correctly applied — the upload endpoint requires a valid session.
The upload directory is outside the webroot, which is good.

---

### Security verdict
`1 critical · 2 high · 1 medium`

**Status:** DO NOT MERGE
Path traversal and missing type validation must be fixed. These are exploitable in production.
```

---

## /explain example

**Scenario:** A medium-sized Go REST API with PostgreSQL.

```
## Codebase explanation

### What this project does
A multi-tenant invoicing API that lets businesses create invoices, send them to customers,
and collect payments via Stripe. Businesses log in via OAuth; customers pay via a
public link (no account required).

---

### Architecture overview

```
HTTP Request
    ↓
cmd/server/main.go          (entrypoint, wires deps)
    ↓
internal/middleware/        (auth, logging, rate limit)
    ↓
internal/handler/           (HTTP layer — thin, delegates to service)
    ↓
internal/service/           (business logic, orchestration)
    ↓
internal/repo/              (DB queries — all SQL lives here)
    ↓
PostgreSQL
    
Stripe webhooks → internal/webhook/stripe.go → service layer (same path)
```

---

### Key modules

**`internal/handler/`** — HTTP handlers. Each file maps to one resource (invoice.go,
customer.go, payment.go). Handlers are intentionally thin — they parse the request,
call one service method, and write the response. No business logic here.

**`internal/service/`** — All business rules live here. InvoiceService owns the lifecycle
of an invoice (draft → sent → paid → void). It coordinates between repo calls and
external services (Stripe, email). This is where the interesting code is.

**`internal/repo/`** — All SQL. Uses sqlc-generated code — don't write raw queries,
add them to `sql/queries/` and run `make gen`. Every method takes a context and returns
typed structs, never maps.

**`internal/middleware/`** — Auth middleware extracts the tenant and user from the JWT and
puts them in context. Every handler downstream can call `middleware.GetTenant(ctx)`.

**`internal/webhook/`** — Stripe webhook handler. The main concern here is idempotency —
Stripe can deliver a webhook multiple times. Every handler checks if the event has
already been processed (via the `processed_events` table) before doing anything.

---

### How to trace a feature: "customer pays an invoice"

1. Customer opens the payment link → `GET /pay/:invoice_token` → `handler/payment.go:ShowPaymentPage`
2. Handler calls `service.InvoiceService.GetByToken()` — validates token, returns invoice
3. Customer submits card → `POST /pay/:invoice_token` → `handler/payment.go:ProcessPayment`
4. Handler calls `service.PaymentService.CreatePaymentIntent()` → calls Stripe API
5. Stripe processes, sends webhook to `POST /webhooks/stripe`
6. `webhook/stripe.go` receives `payment_intent.succeeded` event
7. Calls `service.InvoiceService.MarkPaid()` → updates invoice status, sends receipt email

---

### Where the tricky parts are

**Idempotency in webhooks** (`internal/webhook/stripe.go`): Stripe retries webhooks on
failure. The `processed_events` check-and-insert is done inside a transaction to prevent
double-processing. Don't touch this without understanding the pattern.

**Multi-tenancy** (`internal/repo/`): Every query includes a `tenant_id` filter.
This is enforced at the repo layer, not the handler layer. Adding a new query without
the tenant filter is a data isolation bug — the review command checks for this.

**Token generation** (`internal/service/invoice.go:GenerateToken`): Uses crypto/rand,
not math/rand. This is intentional and must stay that way.

---

### Where to find things
- Add a new API endpoint: `internal/handler/`, register in `cmd/server/routes.go`
- Add a new DB query: `sql/queries/`, run `make gen`
- Add a new background job: `internal/jobs/`, register in `cmd/worker/main.go`
- Config: `internal/config/config.go` — loaded from env vars
- Tests: `*_test.go` next to each file, integration tests in `tests/`
```

---

These examples show what a well-configured setup produces. Quality improves significantly when `CONTEXT.md` is filled in with project-specific conventions.
