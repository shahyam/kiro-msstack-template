---
inclusion: fileMatch
fileMatchPattern: "**/*.test.ts,**/*.test.tsx,**/*Tests.cs,**/*Test.cs"
---

# Testing Standards

## Backend — Unit Tests (xUnit)

- Use xUnit for all backend unit and integration tests
- Place unit tests in `/tests/Unit/` mirroring the source structure
- Place integration tests in `/tests/Integration/`
- Use `NSubstitute` for mocking dependencies — no `.Object` needed, clean substitution syntax
- Use `FluentAssertions` for readable assertions
- Every service, repository method, and controller action must have unit tests
- Follow Arrange / Act / Assert pattern with clear comments

```csharp
public class {Entity}ServiceTests
{
    private readonly I{Entity}Repository _repo = Substitute.For<I{Entity}Repository>();
    private readonly {Entity}Service _sut;

    public {Entity}ServiceTests()
    {
        _sut = new {Entity}Service(_repo);
    }

    [Fact]
    public async Task GetByIdAsync_WhenEntityExists_ReturnsDto()
    {
        // Arrange
        var entity = new {Entity} { Id = 1, Name = "Test" };
        _repo.GetByIdAsync(1, default).Returns(entity);

        // Act
        var result = await _sut.GetByIdAsync(1, default);

        // Assert
        result.Should().NotBeNull();
        result!.Id.Should().Be(1);
    }

    [Theory]
    [InlineData("")]
    [InlineData(null)]
    public async Task CreateAsync_WhenNameIsInvalid_ThrowsValidationException(string name)
    {
        // Arrange
        var request = new Create{Entity}Request(name);

        // Act
        var act = () => _sut.CreateAsync(request, default);

        // Assert
        await act.Should().ThrowAsync<ValidationException>();
    }
}
```

## Backend — Integration Tests (xUnit + SQLite In-Memory)

- Use `Microsoft.EntityFrameworkCore.Sqlite` with in-memory mode for DB integration tests
- Never use the real MSSQL database in automated tests
- Create a shared `TestDbContextFactory` to set up and tear down the DB per test
- Use `WebApplicationFactory<Program>` for API-level integration tests

```csharp
// TestDbContextFactory.cs
public static class TestDbContextFactory
{
    public static AppDbContext Create()
    {
        var options = new DbContextOptionsBuilder<AppDbContext>()
            .UseSqlite("DataSource=:memory:")
            .Options;

        var context = new AppDbContext(options);
        context.Database.OpenConnection();
        context.Database.EnsureCreated();
        return context;
    }

    public static void Destroy(AppDbContext context)
    {
        context.Database.EnsureDeleted();
        context.Dispose();
    }
}

// Usage in integration test
public class {Entity}RepositoryTests : IDisposable
{
    private readonly AppDbContext _context;
    private readonly {Entity}Repository _sut;

    public {Entity}RepositoryTests()
    {
        _context = TestDbContextFactory.Create();
        _sut = new {Entity}Repository(_context);
    }

    [Fact]
    public async Task AddAsync_PersistsEntity()
    {
        // Arrange
        var entity = new {Entity} { Name = "Test" };

        // Act
        await _sut.AddAsync(entity, default);
        await _sut.SaveChangesAsync(default);

        // Assert
        var saved = await _context.Set<{Entity}>().FindAsync(entity.Id);
        saved.Should().NotBeNull();
    }

    public void Dispose() => TestDbContextFactory.Destroy(_context);
}
```

## Frontend — Unit Tests (Vitest + React Testing Library)

- Use Vitest for all React/TS unit tests (integrates natively with Vite)
- Use React Testing Library for component tests
- Use MSW (Mock Service Worker) for API mocking
- Place test files alongside source: `{Component}.test.tsx` or `{hook}.test.ts`
- Unit tests required for: all custom hooks, service functions, utility functions, and key components

```tsx
// Example component test
import { render, screen } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import {ComponentName} from './{ComponentName}';

describe('{ComponentName}', () => {
  it('renders correctly', () => {
    render(<{ComponentName} />);
    expect(screen.getByText('...')).toBeInTheDocument();
  });
});
```

```ts
// Example hook test
import { renderHook, waitFor } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { use{Hook} } from './use{Hook}';

describe('use{Hook}', () => {
  it('returns expected value', async () => {
    const { result } = renderHook(() => use{Hook}());
    await waitFor(() => expect(result.current).toBeDefined());
  });
});
```

## General Rules

- Tests must be independent — no shared mutable state between tests
- No test should depend on execution order
- Tests must run in CI without external dependencies (no real DB, no real HTTP)
- Aim for meaningful coverage on business logic, not 100% line coverage for its own sake
