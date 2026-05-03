# Examples: Using Kiro MS Stack Template

This page shows real-world examples of projects using this template to configure their Kiro AI agents.

## Getting Started with Examples

Each example shows:
1. **Project type** — backend-only, fullstack, microservices, etc.
2. **Customizations made** — what .NET/React/SQL choices were modified
3. **Results** — how the template improved agent quality

---

## Example 1: Fullstack Food Delivery Platform

**Project:** `FoodDelivery.API` + `FoodDelivery.Web` (React)

**Stack:**
- Backend: .NET 9, ASP.NET Core, Entity Framework Core
- Frontend: React 18 + Vite + TypeScript
- Database: MSSQL Server
- CI/CD: GitHub Actions → Azure Container Registry

**Customizations Made:**

```markdown
# .kiro/steering/glossary.md
- **Customer** — end user placing food orders
- **Restaurant** — merchant selling food items
- **Order** — collection of items from one restaurant at one point in time
- **Delivery Partner** — 3rd-party driver fulfilling orders
- **Bounded Contexts:**
  - Orders (creating, validating, confirming orders)
  - Delivery (tracking, route optimization, delivery completion)
  - Restaurants (menu management, operating hours, ratings)
  - Payments (payment processing, refunds, settlements)
```

**Results:**
- Agent understood domain terminology and never confused "Customer" with "Delivery Partner"
- Steering rules prevented accidental CORS misconfigurations (critical for multi-service setup)
- Performance standards caught N+1 queries in order listing endpoint
- Security rules reminded team to use parameterized queries for restaurant filters

---

## Example 2: SaaS Analytics Dashboard (Backend-Only)

**Project:** `Analytics.API` (.NET only, React consumed by separate frontend team)

**Stack:**
- Backend: .NET 9, Minimal APIs, EF Core, PostgreSQL
- Architecture: Clean Architecture with CQRS
- Testing: xUnit + NSubstitute
- CI/CD: GitHub Actions → NuGet private feed

**Customizations Made:**

```markdown
# .kiro/steering/do-not-do.md
[Original content, plus:]

- Never use Entity Framework navigation properties in queries — always explicit joins
  (PostgreSQL query planning differs from MSSQL; explicit joins are more predictable)
- Never use stored procedures — all data access via EF Core or raw SQL with explicit migrations
- Never create background jobs in-process — use Hangfire (registered in DI)
```

```markdown
# .kiro/steering/dotnet-standards.md
[Added PostgreSQL-specific section:]

## PostgreSQL-Specific

- Use `NpgsqlConnection` for raw SQL; configure read replicas if needed
- Use `GENERATED ALWAYS AS` for computed columns (not `OutputIdentity`)
- Use `jsonb` columns for semi-structured configuration data
- Use `LISTEN/NOTIFY` sparingly — prefer event tables + polling for reliability
```

**Results:**
- Team avoided inefficient ORM usage specific to Postgres
- Code review checklist validated CQRS patterns correctly
- Security rules caught a missing API key validation that would have leaked customer data

---

## Example 3: Microservices E-Commerce Platform

**Project:** Multiple services (Order, Inventory, Payment, Notification)

**Stack:**
- Backend: .NET 9 + MassTransit messaging
- Frontend: React + React Query
- Database: Per-service MSSQL databases
- CI/CD: GitHub Actions → Docker Hub + Kubernetes

**Customizations Made:**

```markdown
# .kiro/steering/project-overview.md
[Modified for multi-service model:]

## Services

1. **Order.API** — order creation, confirmation, cancellation
   - Models: Order, OrderLine, OrderStatus
   - Published Events: OrderCreated, OrderConfirmed, OrderCancelled

2. **Inventory.API** — stock management, reservations
   - Models: Product, Stock, Reservation
   - Published Events: StockUpdated, ReservationExpired

3. **Payment.API** — payment processing, refunds
   - Models: Payment, PaymentMethod, Transaction
   - Published Events: PaymentProcessed, PaymentFailed

## Communication

- Services communicate via MassTransit (RabbitMQ consumer)
- Async pub/sub via domain events — no synchronous service calls
- Each service has isolated MSSQL database
```

```markdown
# .kiro/steering/do-not-do.md
[Added microservices-specific constraints:]

- Never call another service's API directly — always use events via message bus
- Never share database across services — each service owns its schema
- Never pass internal model DTOs between services — always versioned API contracts
- Never assume instant consistency — design for eventual consistency
```

**Results:**
- Agent correctly suggested async messaging for inter-service communication instead of HTTP calls
- Security guidance prevented services from accessing each other's databases
- Performance rules caught synchronous blocking code that would deadlock message handlers

---

## Example 4: Internal Admin Dashboard (Minimal Backend)

**Project:** React admin UI + lightweight .NET API

**Stack:**
- Backend: .NET 9 Minimal APIs (very thin — mostly CRUD + auth)
- Frontend: React + TypeScript, Tailwind CSS, React Query
- Database: SQLite for simplicity
- Testing: Vitest for React, xUnit for backend

**Customizations Made:**

```markdown
# .kiro/steering/do-not-do.md
[Added admin-specific rules:]

- Never allow unauthenticated access to any admin endpoint
- Never enable CORS beyond internal domain
- Admin endpoints must log all mutations with user who performed action
- Never cache admin data beyond 5 minutes (freshness critical)
```

**Skills Removed:**
- `create-ef-entity.md` — not using complex domain models
- `write-sql-migration.md` — SQLite for local dev only, not production
- `setup-ci-pipeline.md` — artifact too simple, pushed to npm instead

**Results:**
- Accessibility standards caught missing ARIA labels in complex data tables
- Performance rules suggested React.memo for frequently-updated lists
- Security checklist prevented accidentally exposing user email in API response

---

## How to Adapt This Template for Your Project

### Step 1: Copy Template
```bash
cp -r kiro-msstack-template/.kiro your-project/
cp -r kiro-msstack-template/scripts your-project/
```

### Step 2: Run Bootstrap Script
```bash
cd your-project
bash scripts/init-project.sh .
```

The script will:
- Ask for project name and tech choices
- Auto-remove unused skills (Blazor? No React? No SQL migrations?)
- Validate configuration

### Step 3: Customize Glossary
Edit `.kiro/steering/glossary.md` with your domain terms:

```markdown
# Domain Glossary

## Entities

- **Customer** — what does this mean in your domain?
- **Order** — is this different from a request/invoice/ticket?
- **Product** — is this physical or digital or both?

## Bounded Contexts

- **Payments** — responsible for processing, custody of payment info
- **Fulfillment** — responsible for preparing and shipping
- **catalog** — responsible for product information, pricing, availability

## Abbreviations

- **SKU** — Stock Keeping Unit (unique product ID)
- **PO** — Purchase Order
- **RMA** — Return Merchandise Authorization
```

### Step 4: Review & Customize Rules

Check files that apply to **your tech stack**:
- `.kiro/steering/dotnet-standards.md` — if using .NET
- `.kiro/steering/react-standards.md` — if using React
- `.kiro/steering/mssql-standards.md` — if using MSSQL
- Add new sections for technologies you use (PostgreSQL? Blazor? Microservices?)

### Step 5: Remove Unused Skills

If you don't use a technology, delete the corresponding skill:

```bash
# React not needed?
rm .kiro/skills/create-react-component.md

# Raw SQL migrations for Postgres?
rm .kiro/skills/write-sql-migration.md

# Not using CI/CD?
rm .kiro/skills/setup-ci-pipeline.md
```

Update `.kiro/skills/README.md` to remove entries for deleted skills.

### Step 6: Validate & Test

```bash
node scripts/validate-kiro-files.js
```

Then open your project in Kiro and verify:
- "Included Rules" header shows all expected steering files
- Opening a `.cs` file loads `dotnet-standards.md`
- Opening a `.tsx` file loads `react-standards.md`

---

## Common Customizations

### If Using PostgreSQL Instead of MSSQL

Add to `.kiro/steering/mssql-standards.md`:

```markdown
## PostgreSQL-Specific (when using Postgres instead of MSSQL)

- Use `GENERATED ALWAYS AS` or `STORED` for computed columns
- Prefer `jsonb` type for semi-structured data (better than creating many columns)
- Use `LISTEN/NOTIFY` carefully — not reliable for mandatory operations
- Index boolean columns that are frequently filtered (`WHERE is_active = true`)
```

### If Using Azure instead of AWS

Add to `.kiro/steering/do-not-do.md`:

```markdown
## Azure-Specific

- Never use connection strings in code — always use Azure Key Vault
- Never create infrastructure manually — always use Terraform or ARM templates
- Never commit `appsettings.Production.json` — use Key Vault references
```

### If Using Blazor instead of React

Add skill `.kiro/skills/create-blazor-component.md`:

```markdown
# Skill: Create Blazor Component

## When to use
When adding a new Blazor component (page or reusable component).

## Steps

1. Create component file in `/Components/` (PascalCase.razor)
2. Add `@page` directive if routing
3. Inject required services with `@inject`
4. Implement event handlers with `@on*="Handler"`
5. Use `@bind` for two-way binding
```

---

## Questions?

Open an issue with your customization question, or check the [Troubleshooting](README.md#troubleshooting) section.

