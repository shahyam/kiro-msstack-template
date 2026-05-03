# Skill: Generate Architecture Decision Record (ADR)

## When to use
When a significant architectural decision needs to be made (e.g., choosing a library, changing the project structure, adopting a new pattern).

## Steps

1. Identify the problem/decision to be made
2. Use the `#[[file:.kiro/steering/adr-template.md]]` template
3. Create a new markdown file in `/docs/adr/NNNN-short-description.md` (where NNNN is the next sequence number)
4. Fill in the Status (Proposed, Accepted, Superseded)
5. Describe the Context, Decision, and Consequences (positive and negative)
6. Present the ADR to the user for approval before finalizing

## ADR Index
Ensure the new ADR is added to the index in `/docs/adr/README.md` if it exists.
