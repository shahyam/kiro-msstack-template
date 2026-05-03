---
inclusion: manual
---

# Steering Files

Steering files inject rules and context into every Kiro agent interaction (or selectively, based on configuration). They are the primary mechanism for keeping the agent grounded, consistent, and cost-efficient.

## How Inclusion Works

| Mode | When it loads | Use for |
|---|---|---|
| `inclusion: always` | Every message | Core rules every task needs: project overview, glossary, do-not-do |
| `inclusion: fileMatch` | Only when a matching file is open in the editor | Language/layer-specific rules (e.g. C# rules only when a .cs file is open) |
| `inclusion: manual` | Only when you type `#filename` in chat | Large reference docs, ADRs, full specs — load on demand |

## Files in This Folder

| File | Inclusion | Purpose |
|---|---|---|
| `project-overview.md` | always | Stack, folder structure, key conventions |
| `glossary.md` | always | Domain terms, entity names, abbreviations — prevents hallucination |
| `do-not-do.md` | always | Hard constraints — anti-patterns the agent must never use |
| `dotnet-standards.md` | fileMatch `**/*.cs` | C# / ASP.NET Core / EF Core rules |
| `react-standards.md` | fileMatch `**/*.tsx,**/*.ts` | React, Vite, TypeScript rules |
| `mssql-standards.md` | fileMatch `**/*.sql` | MSSQL schema, query, migration rules |
| `testing-standards.md` | fileMatch `**/*.test.*,**/*Tests.cs` | xUnit + NSubstitute + FluentAssertions + SQLite in-memory rules |
| `git-workflow.md` | always | Branch naming, commit format, PR rules |
| `context-hints.md` | always | Tells the agent which files to read first for common tasks |
| `adr-template.md` | manual | Architecture Decision Record template — load when making arch decisions |

## Tips

- Keep each file focused on one concern — shorter files = fewer tokens = lower cost
- If a rule only applies to one layer, use `fileMatch` not `always`
- Review `do-not-do.md` and `glossary.md` first when onboarding to a new project
- Add new steering files as the project evolves — don't try to capture everything upfront
- All standards files include commented ✅ / ❌ examples — these are the source of truth for the agent
- `context-hints.md` is the key file for reducing credit usage — it tells the agent exactly what to read per task
