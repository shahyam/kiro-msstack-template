# Skills Files

Skills files are step-by-step task guides the AI agent follows when scaffolding new code.
They are NOT loaded automatically — the agent uses them when you ask it to create something new.

## How Skills Work

When you ask Kiro to "create a new API endpoint" or "add a new entity", it:
1. Reads the relevant skill file for the task
2. Reads one existing file of the same type in your project (for pattern matching)
3. Follows the skill template, adapting it to your project's conventions

## Files in This Folder

| File | When Used |
|---|---|
| `create-api-endpoint.md` | Adding a new REST controller + service + DTOs |
| `create-ef-entity.md` | Adding a new EF Core entity + repository + migration |
| `create-react-component.md` | Adding a new React component, page, or data-fetching component |
| `write-sql-migration.md` | Writing raw SQL migration scripts or stored procedures |
| `write-tests.md` | Writing xUnit unit/integration tests or Vitest frontend tests |
| `setup-ci-pipeline.md` | GitHub Actions CI/CD pipeline for .NET + React with Artifactory deploy |
| `setup-new-project.md` | Complete setup checklist for using this template in a new project |
| `review-code.md` | Review code against all steering standards — outputs Critical / Warning / Suggestion |

## Versioning

Kiro skills are versioned to track the evolution of operational capabilities. Significant updates to existing skills or the addition of core skills should be recorded.

Current Version: **1.0.0**

## Changelog

- **2026-05-05 (1.0.0):** Initial set of development, process, and utility skills established.

## Tips

- Skills files use `{Entity}`, `{ComponentName}` etc. as placeholders — the agent replaces these with real names
- If the generated code doesn't match your project's style, update the template in the skill file
- Add new skill files as your team identifies repeated scaffolding patterns
- Keep skill files short — they are guides, not full implementations

## Adding a New Skill

Create a new `.md` file in this folder with:
1. A `# Skill: {Name}` heading
2. A `## When to use` section
3. A `## Steps` section (numbered)
4. A `## Template` section with minimal code examples
5. A `## Related Steering` section linking to relevant files in `.kiro/steering/`
