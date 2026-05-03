# Roadmap

This document outlines the planned improvements and features for the Kiro MS Stack Template.

## Vision

Enable any .NET/React/MSSQL team to adopt this template and get high-quality, grounded AI agent assistance from day one — reducing hallucination, token costs, and onboarding friction.

---

## Current Status: MVP (v1.0) ✅

**Released: May 2026**

### Included
- ✅ Steering files for .NET 9, React + Vite, MSSQL, Testing
- ✅ Skills for API endpoints, EF entities, React components, SQL migrations, tests, CI/CD, code review
- ✅ Validation script (syntax, front-matter, references)
- ✅ Contributing guidelines and ADR template
- ✅ Bootstrap script for quick setup
- ✅ GitHub Actions validation workflow
- ✅ Security, performance, accessibility guidelines
- ✅ Real-world usage examples and customization guide

---

## Phase 2: Broader Platform Support (Q3 2026)

Expand template to serve more .NET ecosystem projects.

### Planned

- **Blazor variant** (Blazor for rendering instead of React)
  - Add `.kiro/skills/create-blazor-component.md`
  - Add `.kiro/steering/blazor-standards.md`  
  - Update bootstrap script to support Blazor template selection
  - Estimated: 2-3 weeks

- **PostgreSQL support** (standardize Postgres-specific patterns)
  - Add `.kiro/steering/postgresql-standards.md`
  - Update MSSQL standards with "database-agnostic" core rules
  - Add Postgres configuration examples to appsettings.example.json
  - Estimated: 1 week

- **Microservices template** (guidance for service boundaries, messaging, eventual consistency)
  - Add `.kiro/steering/microservices-architecture.md`
  - Add new skill: `setup-microservice.md` for creating new services
  - Add messaging bus guidelines (MassTransit, NServiceBus)
  - Estimated: 2 weeks

### Not Planned for Phase 2
- Blazor Server (complication: server-side state management is different)
- Azure Cosmos DB (too specialized; PostgreSQL first)
- gRPC guidance (complex cross-platform issues; REST APIs are more universal)

---

## Phase 3: Azure & Cloud (Q4 2026)

Deploy to Azure cloud native patterns and infrastructure-as-code.

### Planned

- **Azure steering rules** (Azure App Service, Azure SQL, Key Vault, App Insights)
  - Add `.kiro/steering/azure-standards.md`
  - Security guidance for MSI (Managed Service Identity) vs connection strings
  - Update CI/CD skill for Azure Container Registry + App Service deploys
  - Estimated: 2 weeks

- **Infrastructure-as-Code** (Terraform, Bicep, ARM templates)
  - Add skill: `setup-iac.md` for scaffolding Terraform modules
  - Document typical Azure resources per application type
  - Estimated: 2 weeks

- **Azure DevOps support** (GitHub Actions alternative)
  - Add `.github/workflows/` variants for Azure DevOps pipelines
  - Estimated: 1 week

### Not Planned for Phase 3
- AWS CloudFormation (first focus: Azure)
- Kubernetes/Helm (after cloud infrastructure settled)
- Docker Compose for local dev (later phase)

---

## Phase 4: Testing & Quality (Q1 2027)

Deepen testing guidance and integration tests for template validation.

### Planned

- **Integration test harness**
  - Automated tests that copy template, customize it, validate end-to-end
  - Ensures template doesn't break with .NET / Node.js version updates
  - Estimated: 2 weeks

- **Expanded test skills**
  - `.kiro/skills/write-integration-tests.md` (for multi-layer integration tests)
  - `.kiro/skills/write-e2e-tests.md` (Playwright/Cypress)
  - Update existing `write-tests.md` with advanced patterns
  - Estimated: 2 weeks

- **Test coverage recommendations**
  - Guidance on coverage targets (unit vs integration vs E2E)
  - Golden rule: "Critical business logic = high coverage; UI chrome = lower coverage"
  - Estimated: 1 week

---

## Phase 5: Advanced Patterns (Q2 2027)

Deep-dive patterns for complex scenarios.

### Planned

- **Domain-Driven Design (DDD)** support
  - Add `.kiro/steering/ddd-standards.md`
  - Guidance on bounded contexts, aggregates, value objects, repositories
  - Estimated: 2 weeks

- **Event-driven architecture** (beyond microservices)
  - Guidelines for CQRS pattern (Command Query Responsibility Segregation)
  - Event sourcing patterns and tradeoffs
  - Estimated: 2 weeks

- **Search infrastructure** (Elasticsearch, Meilisearch)
  - Steering rules for full-text search integration
  - Skill for setting up search index migrations
  - Estimated: 1-2 weeks

- **Caching strategies** (Redis, distributed caching)
  - Cache coherency patterns
  - Cache invalidation strategies
  - Estimated: 1 week

---

## Phase 6: AI Agent Performance (Q3 2027)

Optimize template for AI agent efficiency and effectiveness.

### Planned

- **Token optimization**
  - Analyze which steering rules are actually used vs just weight context
  - Experiment with removing rarely-used rules
  - Consolidate overlapping rules
  - Estimated: 2 weeks

- **Few-shot examples**
  - Add real code snippets from exemplary projects
  - Agent learns patterns from actual code, not just rules
  - Estimated: 2 weeks

- **Feedback loop integration**
  - Tool that captures agent mistakes and suggests steering rule improvements
  - Community can propose new rules based on observed hallucinations
  - Estimated: 3 weeks

---

## Potential Future Phases (Speculative)

**Phase 7: Other Frameworks** (Vue, Svelte, Next.js variants)
- Per-framework templates instead of monolithic "React" rules
- Estimated: 1 month per framework

**Phase 8: Other Languages** (Go, Python, Java, TypeScript-only)
- Separate template repositories per tech stack
- Shared validation tooling

**Phase 9: VS Code Extension** (Deep IDE Integration)
- Validation status gutter icons
- Quick-fix commands for common violations
- Auto-linting steering rules into project

**Phase 10: Community Package Registry**
- Publish community-contributed steering packs
- E.g., "Event Sourcing Pack", "gRPC Pack", "DDD Pack"
- Estimated: Post-revenue model

---

## Community Contribution Areas

We welcome contributions in any phase. High-impact areas:

1. **Real-world examples** — your project uses this template! Submit a PR to add to `EXAMPLES.md`
2. **Translation** — translate steering files to other languages (e.g., Spanish, Japanese)
3. **Variant templates** — custommicroservices? Specialized domain? Submit as a PR with new steering files
4. **Testing** — help write integration tests for the template
5. **Documentation** — improve clarity, add edge cases, add troubleshooting sections

See [CONTRIBUTING.md](CONTRIBUTING.md) for details.

---

## Success Metrics

We measure success by:

1. **Adoption** — number of projects using template (stars, forks on GitHub)
2. **Agent quality** — qualitative feedback: does Kiro make fewer mistakes?
3. **Token savings** — does scoped steering actually reduce API costs? (5-10% savings target)
4. **Time to value** — can new teams be productive with Kiro in < 1 hour? (Currently ~5 min with bootstrap)
5. **Community health** — contributions, issues resolved, community discussion quality

---

## Staying Updated

- **Watch releases** on GitHub — we tag major features
- **Subscribe to discussions** — ask questions, propose ideas
- **Contribute** — see CONTRIBUTING.md

## Questions?

Open a GitHub issue with the `roadmap` label, or start a discussion.

