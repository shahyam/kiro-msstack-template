# Contributing to kiro-msstack-template

Thank you for considering contributing to this Kiro AI agent configuration template!

## How to Contribute

### Proposing New Steering Rules

1. Identify which layer the rule applies to: .NET, React, SQL, Testing, or General
2. Open an issue describing:
   - The rule you want to add
   - Why it prevents hallucination or improves agent output
   - Whether it should be `always`, `fileMatch`, or `manual` inclusion
3. If approved, submit a PR with:
   - The rule added to the appropriate steering file
   - Commented examples showing ✅ correct and ❌ incorrect usage
   - Update to the relevant README if needed

### Adding New Skills

1. Open an issue describing:
   - What the skill scaffolds (e.g., "Create Blazor component")
   - What inputs it requires from the user
   - Why it's a common enough task to warrant a skill
2. If approved, submit a PR with:
   - The skill file in `.kiro/skills/`
   - Entry added to `.kiro/skills/README.md`
   - Entry added to the main `README.md` skills table

### Testing Changes

Before submitting a PR:

1. **Validate syntax:**
   ```bash
   node scripts/validate-kiro-files.js
   ```

2. **Test with Kiro:**
   - Copy your changes into a test project
   - Open in Kiro and verify the steering file loads (check the "Included Rules" header in chat)
   - Ask Kiro to perform a task that uses your new rule/skill
   - Verify the output matches your expectations

3. **Check examples:**
   - All code examples must be syntactically valid
   - All `#[[file:...]]` references must point to files that exist in a typical project

## Style Guide

### Steering Files

- One concern per file — don't mix unrelated rules
- Use `fileMatch` if the rule only applies when specific files are open
- Use `manual` for large reference docs (ADRs, full specs)
- Always include commented examples with ✅ and ❌ markers
- Keep language direct and imperative ("Use X", not "You should consider using X")

### Skills Files

- Start with `# Skill: {Name}`
- Include a `## When to use` section
- Include a `## Steps` section (numbered list)
- Include a `## Template` section with placeholder syntax (`{Entity}`, `{ComponentName}`)
- Keep templates minimal — show structure, not full implementations

## Code of Conduct

- Be respectful and constructive in issues and PRs
- Focus on improving agent output quality, not personal preferences
- Provide reasoning for proposed changes — "because I prefer it" is not sufficient

## Questions?

Open an issue with the `question` label.
