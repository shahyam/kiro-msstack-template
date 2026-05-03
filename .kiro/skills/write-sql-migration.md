# Skill: Write SQL Migration Script

## When to use
When asked to write raw SQL migration scripts, schema changes, or stored procedures for MSSQL.

## Steps

1. Place scripts in `/scripts/migrations/` with naming: `V{number}__{description}.sql`
2. Always wrap in a transaction
3. Check for existence before creating/altering objects
4. Add rollback script as `V{number}__rollback_{description}.sql`

## New Table Template

```sql
BEGIN TRANSACTION;

IF NOT EXISTS (SELECT 1 FROM sys.tables WHERE name = '{TableName}')
BEGIN
    CREATE TABLE [dbo].[{TableName}] (
        [Id]        INT             NOT NULL IDENTITY(1,1),
        [Name]      NVARCHAR(200)   NOT NULL,
        [IsDeleted] BIT             NOT NULL DEFAULT 0,
        [CreatedAt] DATETIME2       NOT NULL DEFAULT GETUTCDATE(),
        [UpdatedAt] DATETIME2       NULL,
        CONSTRAINT [PK_{TableName}] PRIMARY KEY CLUSTERED ([Id] ASC)
    );

    CREATE NONCLUSTERED INDEX [IX_{TableName}_Name]
        ON [dbo].[{TableName}] ([Name] ASC)
        WHERE [IsDeleted] = 0;

    PRINT '{TableName} table created.';
END
ELSE
BEGIN
    PRINT '{TableName} table already exists, skipping.';
END

COMMIT TRANSACTION;
```

## Add Column Template

```sql
BEGIN TRANSACTION;

IF NOT EXISTS (
    SELECT 1 FROM sys.columns
    WHERE object_id = OBJECT_ID(N'[dbo].[{TableName}]')
    AND name = '{ColumnName}'
)
BEGIN
    ALTER TABLE [dbo].[{TableName}]
    ADD [{ColumnName}] NVARCHAR(100) NULL;

    PRINT 'Column {ColumnName} added to {TableName}.';
END

COMMIT TRANSACTION;
```

## Stored Procedure Template

```sql
CREATE OR ALTER PROCEDURE [dbo].[usp_Get_{Entity}ById]
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT
        [Id],
        [Name],
        [CreatedAt]
    FROM [dbo].[{TableName}]
    WHERE [Id] = @Id
      AND [IsDeleted] = 0;
END
```
