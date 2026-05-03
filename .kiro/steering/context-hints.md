---
inclusion: always
---

# Context Hints

This file tells the agent which files to read first before starting common tasks.
Following this order prevents hallucination and reduces wasted context from reading irrelevant files.

## Before Any Task

1. Check `glossary.md` for domain terms involved in the task
2. Check `do-not-do.md` to confirm the approach doesn't violate any hard constraint
3. Check `project-overview.md` for the correct folder to place new files

## Task: Add a New API Endpoint

Read in this order:
1. The existing controller in `/src/Api/Controllers/` most similar to the new one
2. The corresponding service interface in `/src/Core/Interfaces/`
3. The existing repository in `/src/Infrastructure/Repositories/`
4. `Program.cs` to understand DI registration pattern
5. Then follow the `create-api-endpoint` skill

## Task: Add a New Database Table / Entity

Read in this order:
1. One existing entity in `/src/Core/Entities/` for naming/structure reference
2. `AppDbContext.cs` in `/src/Infrastructure/` to see existing `DbSet` registrations
3. One existing `IEntityTypeConfiguration` for Fluent API pattern reference
4. Then follow the `create-ef-entity` skill

## Task: Add a New React Component or Page

Read in this order:
1. One existing component in `/src/components/` for structure reference
2. `/src/services/apiClient.ts` for the base HTTP client pattern
3. One existing service in `/src/services/` for API call pattern
4. Then follow the `create-react-component` skill

## Task: Write or Fix a Test

Read in this order:
1. The source file being tested
2. One existing test file in the same test project for pattern reference
3. `TestDbContextFactory.cs` if the test needs database access
4. Then follow `testing-standards.md`

## Task: Write a SQL Migration

Read in this order:
1. The most recent migration file in `/scripts/migrations/` for naming convention
2. The related EF entity if one exists
3. Then follow the `write-sql-migration` skill

## Task: Review Code

1. Identify the file type(s) — `.cs`, `.tsx`/`.ts`, `.sql`, or test files
2. Load the relevant steering file for that type if not already in context
3. Follow the `review-code` skill — work through each checklist section
4. Do NOT read the entire repo — only read the file(s) being reviewed plus one reference file of the same type for pattern comparison

## Task: Architecture or Design Decision

1. Load `adr-template.md` manually via `#adr-template` in chat
2. Check existing ADRs in `/docs/adr/` for prior decisions that may be relevant
3. Check `do-not-do.md` for constraints that affect the decision
4. Follow the `generate-adr` skill

## Task: Refactor Code

1. Load `dotnet-standards.md` or `react-standards.md` depending on the file type
2. Read the file(s) to be refactored and their associated tests
3. Follow the `refactor-code` skill

## General Rules for the Agent

- Read the minimum number of files needed — do not scan the whole repo
- Read one representative existing file before creating a new one of the same type
- If unsure which file to read, ask the user rather than guessing
- Never read `.env` files or files likely to contain secrets
