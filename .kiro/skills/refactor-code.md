# Skill: Refactor Code

## When to use
When asked to refactor, clean up, or improve existing code without changing its external behavior.

## Steps

1. **Understand the target:** Read the file(s) and their associated tests.
2. **Identify smells:** Look for violations of `#[[file:.kiro/steering/do-not-do.md]]`, `#[[file:.kiro/steering/dotnet-standards.md]]`, or `#[[file:.kiro/steering/react-standards.md]]`.
3. **Propose changes:** List the refactorings you intend to perform (e.g., "Extract Method", "Rename Variable", "Simplify Logic").
4. **Implement incrementally:** Apply changes in small steps.
5. **Verify:** Run existing tests after each step to ensure no regressions.
6. **Report:** Summarize what was improved and why.

## Refactoring Checklist

- [ ] Does the change align better with project standards?
- [ ] Is the code more readable/maintainable?
- [ ] Are all tests still passing?
- [ ] Did I avoid "over-engineering"?
- [ ] Are all naming conventions followed?
