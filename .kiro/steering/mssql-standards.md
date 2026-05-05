---
inclusion: fileMatch
fileMatchPattern: "**/*.sql"
---

# MSSQL Database Standards

## Naming Conventions

- Tables: PascalCase, plural (e.g., `Orders`, `CustomerAddresses`)
- Columns: PascalCase (e.g., `FirstName`, `CreatedAt`)
- Primary keys: `Id` (int or uniqueidentifier)
- Foreign keys: `{RelatedTable}Id` (e.g., `CustomerId`)
- Indexes: `IX_{Table}_{Column}`
- Stored procs: `usp_{Action}_{Entity}` (e.g., `usp_Get_Orders`)

```sql
-- ✅ Good naming
CREATE TABLE [dbo].[CustomerAddresses] (
    [Id]         INT           NOT NULL IDENTITY(1,1),
    [CustomerId] INT           NOT NULL,   -- FK: CustomerId not Customer_Id
    [Street]     NVARCHAR(200) NOT NULL,
    [CreatedAt]  DATETIME2     NOT NULL DEFAULT GETUTCDATE(),
    CONSTRAINT [PK_CustomerAddresses] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_CustomerAddresses_Customers] FOREIGN KEY ([CustomerId])
        REFERENCES [dbo].[Customers]([Id])
);

CREATE NONCLUSTERED INDEX [IX_CustomerAddresses_CustomerId]
    ON [dbo].[CustomerAddresses] ([CustomerId]);

-- ❌ Bad naming
CREATE TABLE customer_address (   -- wrong: snake_case, singular
    id INT,                        -- wrong: lowercase
    customer_id INT                -- wrong: snake_case FK
);
```

## Schema Design

- Always define a primary key on every table
- Use `NVARCHAR` for string columns (Unicode support)
- Use `DATETIME2` instead of `DATETIME`
- Add `CreatedAt DATETIME2 DEFAULT GETUTCDATE()` and `UpdatedAt` on all tables
- Use soft deletes: `IsDeleted BIT DEFAULT 0` instead of hard deletes
- Avoid nullable columns where possible; use sensible defaults

```sql
-- ✅ Good — standard table template with audit columns and soft delete
CREATE TABLE [dbo].[Orders] (
    [Id]        INT             NOT NULL IDENTITY(1,1),
    [Reference] NVARCHAR(50)    NOT NULL,           -- NVARCHAR not VARCHAR
    [Total]     DECIMAL(18,2)   NOT NULL DEFAULT 0,
    [IsDeleted] BIT             NOT NULL DEFAULT 0, -- soft delete
    [CreatedAt] DATETIME2       NOT NULL DEFAULT GETUTCDATE(), -- DATETIME2 not DATETIME
    [UpdatedAt] DATETIME2       NULL,
    CONSTRAINT [PK_Orders] PRIMARY KEY ([Id])
);

-- ❌ Bad
CREATE TABLE Orders (
    Id INT,                        -- no NOT NULL, no IDENTITY
    CreatedAt DATETIME,            -- DATETIME is deprecated, use DATETIME2
    Name VARCHAR(100)              -- VARCHAR loses Unicode support
);
```

## Query Guidelines

- Avoid `SELECT *` — always specify columns
- Use parameterized queries / EF Core — never string-concatenated SQL
- Add indexes on frequently filtered/joined columns
- Use `NOLOCK` hints only when explicitly acceptable (reporting queries)
- Prefer stored procedures for complex multi-step operations

```sql
-- ✅ Good — explicit columns, parameterized
SELECT [Id], [Reference], [Total], [CreatedAt]
FROM   [dbo].[Orders]
WHERE  [CustomerId] = @CustomerId
  AND  [IsDeleted]  = 0
ORDER BY [CreatedAt] DESC;

-- ❌ Bad — SELECT *, string concatenation (SQL injection risk)
-- EXEC('SELECT * FROM Orders WHERE CustomerId = ' + @id)
```

## Connection Management

- Connection strings in `appsettings.json` (never hardcoded)
- Use environment-specific overrides via `appsettings.{Environment}.json`
- Store secrets in Azure Key Vault or User Secrets (dev only)

```json
// ✅ Good — appsettings.json (no credentials here, use secrets/env override)
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost;Database=MyAppDb;Integrated Security=true;TrustServerCertificate=true;"
  }
}

// ✅ Good — dev secrets (dotnet user-secrets set "ConnectionStrings:DefaultConnection" "...")
// ✅ Good — production via Azure Key Vault or environment variable injection

// ❌ Bad — hardcoded in source code
// var conn = "Server=prod-sql;Database=MyApp;User=sa;Password=P@ssw0rd!";
```

## EF Core Migrations

- One migration per logical change
- Never edit existing migrations — create new ones
- Run `dotnet ef migrations add <Name>` from the Infrastructure project
- Always review generated migration SQL before applying
- Keep seed data in separate migration or `HasData()` calls

```bash
# ✅ Add a new migration (run from solution root)
dotnet ef migrations add AddOrderStatusColumn --project src/Infrastructure --startup-project src/Api

# ✅ Review the SQL before applying
dotnet ef migrations script --project src/Infrastructure --startup-project src/Api

# ✅ Apply migration
dotnet ef database update --project src/Infrastructure --startup-project src/Api

# ❌ Never edit an existing migration file — create a new one instead
```

## Related Skills

- #[[file:.kiro/skills/create-ef-entity.md]]
- #[[file:.kiro/skills/write-sql-migration.md]]
- #[[file:.kiro/skills/review-code.md]]
