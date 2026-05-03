# Skill: Setup New Project from Template

## When to use
When copying this template into a new project for the first time.

## Steps

1. **Copy template files to your project:**
   ```bash
   # From the template repo root
   cp -r .kiro your-project/
   cp -r scripts your-project/
   cp .env.example your-project/
   cp appsettings.example.json your-project/
   ```

2. **Update project overview:**
   - Open `.kiro/steering/project-overview.md`
   - Replace the stack description with your actual technology choices
   - Update the folder structure diagram to match your project layout
   - Update key conventions if your team has specific preferences

3. **Populate the glossary:**
   - Open `.kiro/steering/glossary.md`
   - Replace `{Entity}` placeholders with your actual domain entities (e.g., `Order`, `Customer`, `Product`)
   - Add bounded contexts if using Domain-Driven Design
   - Add project-specific abbreviations

4. **Review and customize do-not-do rules:**
   - Open `.kiro/steering/do-not-do.md`
   - Add any project-specific constraints (e.g., "Never use library X", "Never expose endpoint Y")
   - Remove any rules that don't apply to your project

5. **Remove unused skills:**
   - If not using React, delete `.kiro/skills/create-react-component.md`
   - If not using raw SQL migrations, delete `.kiro/skills/write-sql-migration.md`
   - If not using GitHub Actions, delete `.kiro/skills/setup-ci-pipeline.md`
   - Update `.kiro/skills/README.md` to remove deleted entries

6. **Validate the configuration:**
   ```bash
   cd your-project
   node scripts/validate-kiro-files.js
   ```
   Fix any errors reported by the validator.

7. **Set up environment files:**
   ```bash
   # React app
   cp .env.example src/Web/.env.development
   # Edit and fill in actual values

   # .NET API
   cp appsettings.example.json src/Api/appsettings.Development.json
   # Edit and fill in actual connection strings
   ```

8. **Test with Kiro:**
   - Open the project in Kiro
   - Type a message in chat and check the "Included Rules" header
   - Verify that `project-overview.md`, `glossary.md`, `do-not-do.md`, `context-hints.md`, and `git-workflow.md` are listed
   - Open a `.cs` file and verify `dotnet-standards.md` loads
   - Open a `.tsx` file and verify `react-standards.md` loads

9. **Commit the configuration:**
   ```bash
   git add .kiro/ scripts/
   git commit -m "chore: add Kiro agent configuration"
   ```

## Checklist

- [ ] `.kiro/` and `scripts/` copied to project
- [ ] `project-overview.md` updated with actual stack and structure
- [ ] `glossary.md` populated with domain entities and terms
- [ ] `do-not-do.md` reviewed and customized
- [ ] Unused skills deleted
- [ ] Validation script passes (`node scripts/validate-kiro-files.js`)
- [ ] Environment files created from examples
- [ ] Tested in Kiro — steering files load correctly
- [ ] Configuration committed to git

## Next Steps

- Ask Kiro to scaffold your first entity: "Create a new entity called Order with Id, Reference, and Total"
- Ask Kiro to review existing code: "Review this file against project standards"
- Load the ADR template when making architecture decisions: `#adr-template`
