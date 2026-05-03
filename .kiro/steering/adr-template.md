---
inclusion: manual
---

# Architecture Decision Record (ADR) Template

Load this file manually via `#adr-template` in chat when making architecture decisions.
Save completed ADRs to `/docs/adr/ADR-{number}-{short-title}.md`.

---

## ADR-{number}: {Short Title}

- Date: {YYYY-MM-DD}
- Status: Proposed | Accepted | Deprecated | Superseded by ADR-{number}
- Deciders: {names or roles}

## Context

What is the problem or situation that requires a decision?
What constraints exist (technical, business, time)?

## Decision Drivers

- {driver 1 — e.g. must work with existing MSSQL schema}
- {driver 2 — e.g. team is familiar with EF Core}
- {driver 3}

## Options Considered

### Option 1: {Name}
- Description: ...
- Pros: ...
- Cons: ...

### Option 2: {Name}
- Description: ...
- Pros: ...
- Cons: ...

## Decision

We chose **Option {N}** because {reason}.

## Consequences

- Positive: {what becomes easier or better}
- Negative: {what becomes harder or is a trade-off}
- Risks: {what could go wrong}

## Compliance

- Does this conflict with `do-not-do.md`? {Yes/No — explain if yes}
- Does this require updating `glossary.md`? {Yes/No}
- Does this require updating `project-overview.md`? {Yes/No}
