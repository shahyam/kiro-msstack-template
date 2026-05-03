# Kiro AI Agent Configuration — Microsoft Stack Template

This repository is a **reusable Kiro AI agent configuration template** for projects built on the Microsoft stack (.NET 9, React + Vite, MSSQL). It is not application code — it is the **foundation you copy into a new project** to give your AI agent accurate, grounded, project-specific knowledge from day one.

## Purpose

AI agents like Kiro suffer from several well-known problems:

| Problem | How this project addresses it |
|---|---|
| Hallucination | Explicit standards files tell the agent exactly what libraries, patterns, and conventions to use |
| Context rot | `fileMatch` steering loads only relevant rules when relevant files are open |
| Runaway credit usage | Manual-inclusion files and scoped steering reduce tokens sent per request |
| Inconsistent output | Skills files provide exact templates the agent must follow |
| Anti-pattern drift | `do-not-do.md` explicitly lists what the agent must never do |
| Domain confusion | `glossary.md` defines project-specific terms so the agent never guesses |

## How to Use This Template

### Quick Start (5 minutes)

1. **Copy the template:**
   ```bash
   git clone https://github.com/shahyam/kiro-msstack-template.git
   cp -r kiro-msstack-template/.kiro your-project/
   cp -r kiro-msstack-template/scripts your-project/
   cp kiro-msstack-template/.env.example your-project/
   cp kiro-msstack-template/appsettings.example.json your-project/
   ```

2. **Customize for your project:**
   - Edit `.kiro/steering/glossary.md` — add your domain entities
   - Edit `.kiro/steering/project-overview.md` — update stack/structure

3. **Validate:**
   ```bash
   cd your-project
   node scripts/validate-kiro-files.js
   ```

4. **Open in Kiro** — steering rules load automatically

### Detailed Setup

1. Copy the `.kiro/` folder and `scripts/` folder into the root of your new project
2. Edit `.kiro/steering/project-overview.md` — update the project name, structure, and tech choices
3. Edit `.kiro/steering/glossary.md` — add your domain terms (entities, bounded contexts, abbreviations)
4. Delete any steering or skills files that don't apply to your project
5. Open the project in Kiro — steering files marked `inclusion: always` load automatically
6. Use `#` in Kiro chat to manually load steering files marked `inclusion: manual` when needed

For a complete setup checklist, ask Kiro to follow the `setup-new-project` skill.

## Folder Structure

```
.kiro/
  steering/         Rules and standards always or conditionally sent to the agent
    README.md           How steering works, inclusion modes, full file index
    project-overview.md Stack, folder structure, key conventions (always)
    glossary.md         Domain terms — prevents hallucination (always)
    do-not-do.md        Hard constraints the agent must never violate (always)
    context-hints.md    Tells agent what to read first per task (always)
    git-workflow.md     Branch naming, commit format, PR rules (always)
    dotnet-standards.md C# / ASP.NET Core / EF Core rules (fileMatch *.cs)
    react-standards.md  React, Vite, TypeScript rules (fileMatch *.tsx,*.ts)
    mssql-standards.md  MSSQL schema, query, migration rules (fileMatch *.sql)
    testing-standards.md xUnit, NSubstitute, Vitest, SQLite in-memory (fileMatch test files)
    adr-template.md     Architecture Decision Record template (manual)
  skills/           Step-by-step scaffolding templates the agent follows
    README.md               How skills work, full file index
    create-api-endpoint.md  REST controller + service + DTOs
    create-ef-entity.md     EF Core entity + repository + migration
    create-react-component.md React component, page, or data-fetching component
    write-sql-migration.md  Raw SQL migration scripts + stored procedures
    write-tests.md          xUnit unit/integration tests + Vitest frontend tests
    setup-ci-pipeline.md    GitHub Actions CI/CD for .NET + React → Artifactory
  hooks/
    validate-kiro-on-save.kiro.hook   Manual trigger to validate steering/skills files
scripts/
  validate-kiro-files.js    Validates front-matter, inclusion values, file references
README.md                   This file
```

## Reading Order

If you are setting up a new project, read in this order:

1. `.kiro/steering/project-overview.md` — understand the stack and structure
2. `.kiro/steering/glossary.md` — understand domain terms
3. `.kiro/steering/do-not-do.md` — understand hard constraints
4. `.kiro/steering/dotnet-standards.md` — backend rules (with commented examples)
5. `.kiro/steering/react-standards.md` — frontend rules (with commented examples)
6. `.kiro/steering/mssql-standards.md` — database rules (with commented examples)
7. `.kiro/steering/testing-standards.md` — xUnit + NSubstitute + Vitest rules
8. `.kiro/steering/git-workflow.md` — branching and commit conventions
9. `.kiro/skills/` — scaffolding templates for common tasks

## Skills Available

| Skill | What it generates |
|---|---|
| `create-api-endpoint` | ASP.NET Core controller + service interface + DTOs |
| `create-ef-entity` | EF Core entity + Fluent config + repository + migration commands |
| `create-react-component` | React component or page + service function + React Query hook |
| `write-sql-migration` | Raw SQL migration script or stored procedure |
| `write-tests` | xUnit unit/integration tests (NSubstitute + SQLite) or Vitest component/hook tests |
| `setup-ci-pipeline` | GitHub Actions pipelines for .NET + React with build, test, package, deploy to Artifactory |
| `setup-new-project` | Complete checklist for setting up this template in a new project for the first time |

## Design Philosophy

This template is built on three principles:

1. **Grounding over flexibility** — explicit rules prevent hallucination, even if they feel restrictive
2. **Credit efficiency** — `fileMatch` and `manual` inclusion keep context small and focused
3. **Evolvability** — steering files are easy to edit as your project's conventions evolve

## Troubleshooting

**Steering file not loading?**
- Check front-matter syntax with `node scripts/validate-kiro-files.js`
- Verify `fileMatchPattern` glob matches your file extensions

**Agent ignoring a rule?**
- Check if the file is `inclusion: manual` — load it with `#filename` in chat
- Verify the rule isn't contradicted by another steering file

**Validation script failing?**
- Ensure Node.js is installed
- Check file paths in `#[[file:...]]` references exist

**Agent reading too many files?**
- Check `context-hints.md` — it tells the agent what to read per task
- Use more specific task descriptions to narrow scope

## Credit Optimisation Strategy

- `inclusion: always` — only for files every interaction needs: project overview, glossary, do-not-do, context-hints, git-workflow
- `inclusion: fileMatch` — loads only when a matching file is open: dotnet/react/sql/test rules stay out of context until relevant
- `inclusion: manual` — large reference files (ADRs, API specs) loaded on demand via `#filename` in chat
- One concern per steering file — short focused files cost fewer tokens than one large file
- Skills are never auto-loaded — only used when the agent is actively scaffolding
- `context-hints.md` tells the agent to read the minimum files needed per task, preventing full repo scans
