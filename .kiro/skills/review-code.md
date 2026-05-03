# Skill: Code Review

## When to use
When asked to review code, audit a file, or check a PR/change against project standards.
This skill covers all layers — C#, React/TypeScript, SQL, and tests.

## Steps

1. Identify the file type(s) being reviewed
2. Load the relevant steering rules for that file type (see checklist below)
3. Work through each checklist section that applies
4. Report findings grouped by severity: Critical, Warning, Suggestion
5. For each finding: state the rule violated, show the offending code, show the fix

## Severity Definitions

| Severity | Meaning |
|---|---|
| Critical | Violates `do-not-do.md` — must be fixed before merge |
| Warning | Violates a standard in a steering file — should be fixed |
| Suggestion | Improvement that would align better with conventions — optional |

---

## Review Checklist

### General (all files)

- [ ] No hardcoded secrets, connection strings, or API keys
- [ ] No `// TODO` left as placeholder for unimplemented logic
- [ ] No commented-out dead code left in
- [ ] File is in the correct folder per `project-overview.md`
- [ ] Naming matches glossary terms exactly

---

### C# / .NET (`**/*.cs`)

**Async**
- [ ] All I/O methods are `async` and return `Task` or `Task<T>`
- [ ] No `.Result` or `.Wait()` calls anywhere
- [ ] `CancellationToken` passed through all async call chains

**Architecture**
- [ ] No business logic in controllers — controllers are thin
- [ ] No `DbContext` injected directly into controllers or services
- [ ] Repository pattern used for all data access
- [ ] Services registered via DI extension methods, not `new`

**Types & Nullability**
- [ ] `#nullable enable` present or set at project level
- [ ] No `dynamic` type usage
- [ ] DTOs and value objects use `record` types
- [ ] `var` only used when type is obvious from right-hand side

**Error Handling**
- [ ] No silent `catch {}` or `catch (Exception) {}` without logging
- [ ] Errors return `ProblemDetails` from controllers, not raw strings
- [ ] Global exception handler in place — no per-controller try/catch for unhandled errors

**Logging**
- [ ] `ILogger<T>` used (not Serilog's `ILogger` directly)
- [ ] Structured message templates used — no string interpolation in log calls
- [ ] Appropriate log level used (not everything at `Error`)

```csharp
// ✅ Correct structured logging
_logger.LogInformation("Order {OrderId} created for customer {CustomerId}", order.Id, order.CustomerId);

// ❌ String interpolation in log — loses structured data
_logger.LogInformation($"Order {order.Id} created"); // CRITICAL
```

**EF Core**
- [ ] `AsNoTracking()` used on read-only queries
- [ ] No raw string-concatenated SQL — parameterized or EF only
- [ ] No `SELECT *` in any raw SQL

---

### React / TypeScript (`**/*.tsx`, `**/*.ts`)

**Components**
- [ ] Functional components only — no class components
- [ ] One component per file, filename matches component name (PascalCase)
- [ ] Props interface defined with TypeScript — no implicit `any` props
- [ ] No `any` type — use `unknown` and narrow, or define a proper type

**Hooks & Side Effects**
- [ ] `useEffect` has a dependency array
- [ ] `useEffect` cleans up subscriptions, timers, or fetch controllers in return function
- [ ] Complex logic extracted into custom hooks, not inline in components

**API Calls**
- [ ] No `fetch` or `axios` calls directly inside components — use `/services`
- [ ] Base `apiClient` used for all HTTP calls (not raw `fetch`)
- [ ] Loading, error, and success states all handled explicitly

**Imports & Structure**
- [ ] No imports deeper than 2 levels (`../../..`) — use `@/` alias
- [ ] No sensitive values in `VITE_` env vars

**Styling**
- [ ] No static inline styles — CSS Modules or Tailwind only
- [ ] Dynamic inline styles only for computed values (e.g. widths, colours from data)

```tsx
// ✅ Correct
import { getOrder } from '@/services/orderService'; // alias, not relative hell
const { data, isLoading, error } = useQuery({ queryKey: ['order', id], queryFn: () => getOrder(id) });

// ❌ Direct fetch in component — CRITICAL
useEffect(() => { fetch('/api/orders/' + id).then(...) }, []);
```

---

### SQL (`**/*.sql`)

- [ ] No `SELECT *` — explicit column list only
- [ ] All string columns use `NVARCHAR`, not `VARCHAR`
- [ ] All date columns use `DATETIME2`, not `DATETIME`
- [ ] Tables have `IsDeleted BIT DEFAULT 0` (soft delete)
- [ ] Tables have `CreatedAt DATETIME2 DEFAULT GETUTCDATE()` and `UpdatedAt`
- [ ] All migrations wrapped in `BEGIN TRANSACTION` / `COMMIT TRANSACTION`
- [ ] Existence checks before `CREATE` statements
- [ ] No string-concatenated dynamic SQL (SQL injection risk)
- [ ] Stored procs named `usp_{Action}_{Entity}`

```sql
-- ✅ Correct
SELECT [Id], [Name], [CreatedAt] FROM [dbo].[Orders] WHERE [IsDeleted] = 0;

-- ❌ SELECT * — WARNING
SELECT * FROM Orders;

-- ❌ Dynamic SQL concatenation — CRITICAL
EXEC('SELECT * FROM Orders WHERE Id = ' + @id);
```

---

### Tests (`**/*Tests.cs`, `**/*.test.tsx`, `**/*.test.ts`)

**Backend (xUnit)**
- [ ] `NSubstitute` used for mocking — no `Moq`
- [ ] `FluentAssertions` used for assertions — no raw `Assert.Equal`
- [ ] Test method name follows `MethodName_WhenCondition_ShouldResult` pattern
- [ ] Arrange / Act / Assert sections present with comments
- [ ] No test depends on another test's state or execution order
- [ ] Integration tests use SQLite in-memory — no real MSSQL connection

**Frontend (Vitest)**
- [ ] Tests use React Testing Library — no direct DOM manipulation
- [ ] Tests assert on user-visible behaviour, not internal state
- [ ] API calls mocked via MSW or `vi.mock` — no real HTTP in tests
- [ ] `--run` flag used in CI (not watch mode)

---

## Review Output Format

Structure your review response as:

```
## Code Review: {filename}

### Critical (must fix before merge)
- [RULE] {rule violated from do-not-do.md or steering}
  {offending code snippet}
  Fix: {corrected code snippet}

### Warnings (should fix)
- [RULE] {rule violated}
  {offending code}
  Fix: {corrected code}

### Suggestions (optional improvements)
- {suggestion with reasoning}

### Passed
- {list of checklist items that were verified clean}
```
