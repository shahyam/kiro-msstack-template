---
inclusion: always
---

# Git Workflow

## Branch Naming

- Features: `feature/{ticket-id}-short-description`
- Bug fixes: `fix/{ticket-id}-short-description`
- Hotfixes: `hotfix/{ticket-id}-short-description`
- Releases: `release/{version}`

## Micro Commits

- Commit one logical change at a time — not a whole feature in one commit
- Each commit should pass tests and leave the codebase in a working state
- Prefer many small commits over one large "WIP" commit
- Good micro commit examples:
  - `feat(orders): add Order entity and EF configuration`
  - `feat(orders): add IOrderRepository interface`
  - `feat(orders): implement OrderRepository`
  - `feat(orders): add OrderService with GetById`
  - `feat(orders): add OrdersController GET endpoint`
- Never bundle unrelated changes in one commit (e.g. a bug fix + a new feature)
- Never commit commented-out code, debug logging, or temporary test values

## Commit Messages

Follow Conventional Commits format:
```
<type>(<scope>): <short summary>

Types: feat, fix, docs, style, refactor, test, chore
Examples:
  feat(orders): add order cancellation endpoint
  fix(auth): resolve token expiry refresh issue
  chore(db): add migration for customer table
```

## Pull Requests

- PRs must target `develop` (not `main` directly)
- Require at least 1 reviewer approval
- All CI checks must pass before merge
- Squash merge preferred to keep history clean
- Link PR to ticket/issue

## Protected Branches

- `main` — production, no direct pushes
- `develop` — integration branch, PRs only
