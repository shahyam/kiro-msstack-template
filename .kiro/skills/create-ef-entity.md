# Skill: Create EF Core Entity & Migration

## When to use
When asked to add a new database table, entity model, or EF Core migration.

## Steps

1. Create entity class in `/src/Core/Entities/`
2. Add `DbSet<T>` to `AppDbContext` in `/src/Infrastructure/`
3. Configure entity using Fluent API in `OnModelCreating` or a separate `IEntityTypeConfiguration<T>`
4. Add repository interface in `/src/Core/Interfaces/`
5. Implement repository in `/src/Infrastructure/Repositories/`
6. Run migration: `dotnet ef migrations add Add{Entity} --project src/Infrastructure --startup-project src/Api`
7. Apply migration: `dotnet ef database update --project src/Infrastructure --startup-project src/Api`

## Entity Template

```csharp
// Entity
public class {Entity}
{
    public int Id { get; set; }
    public required string Name { get; set; }
    public bool IsDeleted { get; set; } = false;
    public DateTime CreatedAt { get; set; } = DateTime.UtcNow;
    public DateTime? UpdatedAt { get; set; }
}

// EF Configuration
public class {Entity}Configuration : IEntityTypeConfiguration<{Entity}>
{
    public void Configure(EntityTypeBuilder<{Entity}> builder)
    {
        builder.HasKey(e => e.Id);
        builder.Property(e => e.Name).IsRequired().HasMaxLength(200);
        builder.HasQueryFilter(e => !e.IsDeleted); // global soft-delete filter
    }
}

// Repository Interface
public interface I{Entity}Repository
{
    Task<{Entity}?> GetByIdAsync(int id, CancellationToken ct);
    Task<List<{Entity}>> GetAllAsync(CancellationToken ct);
    Task AddAsync({Entity} entity, CancellationToken ct);
    Task SaveChangesAsync(CancellationToken ct);
}
```

## Related Steering

- #[[file:.kiro/steering/dotnet-standards.md]]
- #[[file:.kiro/steering/mssql-standards.md]]
- #[[file:.kiro/steering/project-overview.md]]
