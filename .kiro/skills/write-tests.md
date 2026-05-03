# Skill: Write Tests

## When to use
When asked to write unit tests, integration tests, or frontend component/hook tests.

## Steps — Backend Unit Test (xUnit)

1. Create test file in `/tests/Unit/` mirroring the source path
2. Name the class `{ClassName}Tests`
3. Mock all dependencies with `Moq`
4. Use `FluentAssertions` for assertions
5. Follow Arrange / Act / Assert with comments
6. One `[Fact]` per behaviour, not per method

```csharp
public class {ClassName}Tests
{
    private readonly I{Dependency} _{dep} = Substitute.For<I{Dependency}>();
    private readonly {ClassName} _sut;

    public {ClassName}Tests()
    {
        _sut = new {ClassName}(_{dep});
    }

    [Fact]
    public async Task {MethodName}_When{Condition}_Should{ExpectedResult}()
    {
        // Arrange
        _{dep}.{Method}(Arg.Any<int>(), default).Returns({returnValue});

        // Act
        var result = await _sut.{MethodName}({args}, default);

        // Assert
        result.Should().NotBeNull();
        result.{Property}.Should().Be({expected});
    }

    [Fact]
    public async Task {MethodName}_When{NegativeCondition}_Should{ThrowOrReturnNull}()
    {
        // Arrange
        _{dep}.{Method}(Arg.Any<int>(), default).Returns(({Type}?)null);

        // Act
        var result = await _sut.{MethodName}({args}, default);

        // Assert
        result.Should().BeNull();
    }
}
```

## Steps — Backend Integration Test (xUnit + SQLite)

1. Create test file in `/tests/Integration/`
2. Use `TestDbContextFactory.Create()` for DB setup
3. Implement `IDisposable` and call `TestDbContextFactory.Destroy()` in `Dispose()`
4. Test the real repository against the in-memory SQLite DB

```csharp
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
    public async Task AddAsync_When{Condition}_Persists{Entity}()
    {
        // Arrange
        var entity = new {Entity} { Name = "Test" };

        // Act
        await _sut.AddAsync(entity, default);
        await _sut.SaveChangesAsync(default);

        // Assert
        var saved = await _context.Set<{Entity}>().FindAsync(entity.Id);
        saved.Should().NotBeNull();
        saved!.Name.Should().Be("Test");
    }

    public void Dispose() => TestDbContextFactory.Destroy(_context);
}
```

## Steps — Frontend Unit Test (Vitest)

1. Create `{Component}.test.tsx` or `{hook}.test.ts` alongside the source file
2. Use React Testing Library for components, `renderHook` for hooks
3. Mock API calls with MSW or `vi.mock`
4. Test behaviour visible to the user, not internal implementation

```tsx
// Component test
import { render, screen, fireEvent } from '@testing-library/react';
import { describe, it, expect, vi } from 'vitest';
import {ComponentName} from './{ComponentName}';

describe('{ComponentName}', () => {
  it('renders {expected element} when {condition}', () => {
    // Arrange
    render(<{ComponentName} {props} />);

    // Assert
    expect(screen.getByRole('{role}', { name: '{name}' })).toBeInTheDocument();
  });

  it('calls {handler} when {action}', async () => {
    // Arrange
    const onAction = vi.fn();
    render(<{ComponentName} onAction={onAction} />);

    // Act
    fireEvent.click(screen.getByRole('button', { name: '{label}' }));

    // Assert
    expect(onAction).toHaveBeenCalledOnce();
  });
});
```

```ts
// Hook test
import { renderHook, waitFor } from '@testing-library/react';
import { describe, it, expect } from 'vitest';
import { use{Hook} } from './use{Hook}';

describe('use{Hook}', () => {
  it('returns {expected} when {condition}', async () => {
    const { result } = renderHook(() => use{Hook}({args}));

    await waitFor(() => expect(result.current.isLoading).toBe(false));

    expect(result.current.data).toBeDefined();
  });
});
```
