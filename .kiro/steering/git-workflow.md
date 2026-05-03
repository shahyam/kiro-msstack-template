---
inclusion: always
---

# Git Workflow

## Branch Naming

- Features: `feature/{ticket-id}-short-description`
- Bug fixes: `fix/{ticket-id}-short-description`
- Hotfixes: `hotfix/{ticket-id}-short-description`
- Releases: `release/{version}`

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
