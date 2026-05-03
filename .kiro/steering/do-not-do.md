---
inclusion: always
---

# Do Not Do

Hard constraints for the AI agent. These are non-negotiable and override any other instruction.

## C# / .NET

- Never use `.Result` or `.Wait()` on async methods — always `await`
- Never expose `DbContext` directly in controllers or services — use repositories
- Never hardcode connection strings, API keys, or secrets anywhere in code
- Never use `dynamic` type in C#
- Never use `Thread.Sleep` — use `Task.Delay` instead
- Never catch and swallow exceptions silently (`catch {}` or `catch (Exception) {}` with no logging)
- Never use `SELECT *` in raw SQL queries
- Never write string-concatenated SQL — always parameterized queries or EF Core
- Never put business logic in controllers — controllers are thin, logic goes in services
- Never create a migration by editing an existing migration file
- Never target .NET Standard for executable projects (API, Web) — only for library projects
- Never use `var` when the type is not obvious from the right-hand side

## React / Frontend

- Never use class components — functional components with hooks only
- Never use `any` type in TypeScript — use `unknown` and narrow, or define a proper type
- Never make API calls directly inside components — use service functions in `/services`
- Never store sensitive data (tokens, keys) in `localStorage` — use `httpOnly` cookies or memory
- Never use inline styles for static values — use CSS Modules or Tailwind classes
- Never use `useEffect` without a dependency array unless you explicitly need it to run every render
- Never import from `../../../` more than 2 levels deep — use the `@/` path alias
- Never prefix `VITE_` env vars with secrets that should stay server-side

## Database / MSSQL

- Never drop a column or table without a rollback script
- Never run migrations against production without reviewing the generated SQL first
- Never use `NOLOCK` on write-heavy or transactional tables
- Never store passwords or PII in plain text
- Never use `DATETIME` — always `DATETIME2`

## Testing

- Never write tests that depend on execution order
- Never use the real MSSQL database in automated tests — use SQLite in-memory
- Never use `Moq` — use `NSubstitute` for all mocking
- Never skip writing tests for business logic, even under time pressure

## General Agent Behaviour

- Never invent library names, NuGet packages, or npm packages — only use what is listed in the project standards or already in the project's dependency files
- Never rename existing files, classes, or methods without being explicitly asked
- Never delete files without being explicitly asked
- Never assume a domain term — check the glossary first, ask if not found
- Never generate placeholder `// TODO` code and present it as complete — either implement it or say it is not implemented
