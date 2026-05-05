---
inclusion: fileMatch
fileMatchPattern: "**/*.cs"
---

# .NET C# Coding Standards

## General

- Target .NET 9+ for API, Web, and executable projects
- Target .NET Standard 2.0 for all library/shared projects (Core, Infrastructure, shared utilities) to ensure broad compatibility
- Use `nullable enable` in all projects
- Prefer `record` types for DTOs and value objects
- Use `sealed` on classes not intended for inheritance
- Avoid `static` classes except for extension methods and constants

```csharp
// ✅ Good — record DTO, nullable enabled
#nullable enable
public record CreateOrderRequest(string CustomerName, decimal Total);

// ✅ Good — sealed class, no unintended inheritance
public sealed class OrderValidator { }

// ✅ Good — static only for extensions
public static class StringExtensions
{
    public static bool IsNullOrEmpty(this string? value) => string.IsNullOrEmpty(value);
}

// ❌ Bad — mutable class DTO, not sealed
public class CreateOrderRequest { public string CustomerName { get; set; } }
```

## ASP.NET Core

- Use minimal API or controller-based API consistently per service
- Always use `[ApiController]` attribute on controllers
- Return `IActionResult` or `ActionResult<T>` from controller actions
- Use `ProblemDetails` for error responses (RFC 7807)
- Validate inputs using Data Annotations or FluentValidation
- Use `CancellationToken` in all async controller actions

```csharp
// ✅ Good — ApiController, ActionResult<T>, CancellationToken
[ApiController]
[Route("api/[controller]")]
public class OrdersController : ControllerBase
{
    [HttpGet("{id:int}")]
    public async Task<ActionResult<OrderResponse>> GetById(int id, CancellationToken ct)
    {
        var order = await _service.GetByIdAsync(id, ct);
        return order is null ? NotFound() : Ok(order);
    }

    [HttpPost]
    public async Task<ActionResult<OrderResponse>> Create(
        [FromBody] CreateOrderRequest request, CancellationToken ct)
    {
        var result = await _service.CreateAsync(request, ct);
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }
}

// ❌ Bad — no ApiController, returns object, no CancellationToken
public class OrdersController : ControllerBase
{
    [HttpGet("{id}")]
    public async Task<object> GetById(int id) { ... }
}
```

## Dependency Injection

- Register services in `Program.cs` using extension methods per feature
- Use `IServiceCollection` extension methods to group registrations
- Prefer constructor injection; avoid service locator pattern

```csharp
// ✅ Good — extension method groups registrations cleanly
public static class OrdersServiceExtensions
{
    public static IServiceCollection AddOrdersServices(this IServiceCollection services)
    {
        services.AddScoped<IOrderService, OrderService>();
        services.AddScoped<IOrderRepository, OrderRepository>();
        return services;
    }
}

// Program.cs
builder.Services.AddOrdersServices();

// ❌ Bad — service locator anti-pattern
public class OrderService
{
    private readonly IServiceProvider _provider;
    public OrderService(IServiceProvider provider) { _provider = provider; }

    public void DoWork()
    {
        var repo = _provider.GetService<IOrderRepository>(); // ❌ avoid
    }
}
```

## Entity Framework Core

- Use Code First migrations
- Keep `DbContext` in the Infrastructure layer
- Use `AsNoTracking()` for read-only queries
- Never expose `DbContext` directly to controllers
- Use repository + unit of work pattern

```csharp
// ✅ Good — AsNoTracking for read-only, repository hides DbContext
public class OrderRepository : IOrderRepository
{
    private readonly AppDbContext _context;
    public OrderRepository(AppDbContext context) => _context = context;

    public async Task<List<Order>> GetAllAsync(CancellationToken ct) =>
        await _context.Orders
            .AsNoTracking()          // ✅ read-only — no change tracking overhead
            .Where(o => !o.IsDeleted)
            .ToListAsync(ct);

    public async Task<Order?> GetByIdAsync(int id, CancellationToken ct) =>
        await _context.Orders.FindAsync([id], ct);
}

// ❌ Bad — DbContext injected directly into controller
public class OrdersController : ControllerBase
{
    public OrdersController(AppDbContext db) { } // ❌ never do this
}
```

## Error Handling

- Use global exception middleware or `IExceptionHandler` (.NET 8)
- Log exceptions using `ILogger<T>`
- Never swallow exceptions silently

```csharp
// ✅ Good — global handler, logs and returns ProblemDetails
public class GlobalExceptionHandler : IExceptionHandler
{
    private readonly ILogger<GlobalExceptionHandler> _logger;
    public GlobalExceptionHandler(ILogger<GlobalExceptionHandler> logger) => _logger = logger;

    public async ValueTask<bool> TryHandleAsync(
        HttpContext context, Exception ex, CancellationToken ct)
    {
        _logger.LogError(ex, "Unhandled exception: {Message}", ex.Message);
        context.Response.StatusCode = StatusCodes.Status500InternalServerError;
        await context.Response.WriteAsJsonAsync(new ProblemDetails
        {
            Title = "An unexpected error occurred.",
            Status = 500
        }, ct);
        return true;
    }
}

// ❌ Bad — swallowed exception, no logging
try { await _service.ProcessAsync(); }
catch (Exception) { } // ❌ silent failure
```

## Async

- All I/O methods must be async and return `Task` or `Task<T>`
- Never use `.Result` or `.Wait()` — always `await`
- Use `ConfigureAwait(false)` in library code

```csharp
// ✅ Good
public async Task<Order?> GetOrderAsync(int id, CancellationToken ct)
{
    return await _repository.GetByIdAsync(id, ct).ConfigureAwait(false);
}

// ❌ Bad — blocks thread, risks deadlock
public Order? GetOrder(int id)
{
    return _repository.GetByIdAsync(id, default).Result; // ❌ never
}
```

## Logging

- Use Serilog for all logging — no built-in `Microsoft.Extensions.Logging` providers directly
- Configure Serilog in `Program.cs` using `UseSerilog()`
- Always inject `ILogger<T>` (not Serilog's `ILogger`) to keep code decoupled from the logging library
- Use structured logging with message templates — never string interpolation in log calls
- Minimum required sinks: Console (dev), File (rolling daily), and optionally Seq for local dev
- Log at appropriate levels: Verbose, Debug, Information, Warning, Error, Fatal

```csharp
// Program.cs
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .Enrich.FromLogContext()
    .Enrich.WithMachineName()
    .WriteTo.Console()
    .WriteTo.File("logs/app-.log", rollingInterval: RollingInterval.Day)
    .CreateLogger();

builder.Host.UseSerilog();
```

```json
// appsettings.json — Serilog config
"Serilog": {
  "MinimumLevel": {
    "Default": "Information",
    "Override": {
      "Microsoft": "Warning",
      "System": "Warning"
    }
  }
}
```

- Required NuGet packages: `Serilog.AspNetCore`, `Serilog.Sinks.Console`, `Serilog.Sinks.File`

## Performance

- Use `AsNoTracking()` on EF Core queries that only read data — avoids change tracking overhead
- Implement query result caching for frequently-accessed lookups (e.g., product categories, system settings)
- Use `LIMIT`/`OFFSET` or pagination to avoid loading entire result sets
- Prefer batch operations (`AddRange`, `UpdateRange`) over individual entity saves
- Use prepared statements with EF Core for bulk operations
- Implement request/response compression with gzip middleware
- Use `.Any()` instead of `.Count() > 0` for existence checks
- Apply database indexes to foreign keys and frequently-filtered columns
- Monitor query performance with SQL Server Query Analyzer or Application Insights

```csharp
// ✅ Good — caching lookups, pagination, AsNoTracking
public class OrderService
{
    private static readonly Dictionary<int, Category> CategoryCache = new();

    public async Task<List<Order>> GetOrdersPagedAsync(
        int pageNumber, int pageSize, CancellationToken ct)
    {
        var skip = (pageNumber - 1) * pageSize;
        return await _context.Orders
            .AsNoTracking()
            .Skip(skip)
            .Take(pageSize)
            .ToListAsync(ct);
    }

    public async Task<bool> AnyOrdersAsync(int customerId, CancellationToken ct) =>
        await _context.Orders
            .Any(o => o.CustomerId == customerId, ct); // ✅ efficient existence check
}

// ❌ Bad — no pagination, tracking overhead, inefficient count
public async Task<List<Order>> GetAllOrdersAsync() =>
    await _context.Orders.ToListAsync(); // ❌ loads entire table

public async Task<bool> AnyOrdersAsync(int customerId) =>
    await _context.Orders.Where(o => o.CustomerId == customerId).Count() > 0; // ❌ inefficient
```

## Security

- Create database users with minimal required permissions per application/service
- Enable SQL Server Transparent Data Encryption (TDE) on production databases
- Validate and sanitize all user inputs — use FluentValidation or Data Annotations
- Implement rate limiting on API endpoints to prevent abuse
- Use `[Authorize]` attribute on all endpoints that require authentication
- Implement proper CORS policy — whitelist specific origins, not `AllowAnyOrigin`
- Never log sensitive data (passwords, PII, payment info) — use `[LogMasking]` or custom formatters
- Use HTTPS everywhere — never HTTP in production
- Implement CSRF protection for state-changing operations
- Rotate secrets regularly and store in secure vaults (Azure Key Vault, 1Password, etc.)

```csharp
// ✅ Good — CORS restricted, [Authorize] applied
builder.Services.AddCors(options =>
{
    options.AddPolicy("AllowFrontend", policy =>
    {
        policy.WithOrigins("https://frontend.example.com")
              .AllowAnyMethod()
              .AllowAnyHeader()
              .AllowCredentials();
    });
});

[ApiController]
public class OrdersController : ControllerBase
{
    [HttpPost]
    [Authorize(Roles = "Admin")] // ✅ authorization enforced
    public async Task<ActionResult> CreateAsync([FromBody] CreateOrderRequest req) { ... }
}

// ❌ Bad — CORS AllowAnyOrigin, no rate limiting
options.AddPolicy("AllowAll", p => p.AllowAnyOrigin()); // ❌ security risk
```

## Related Skills

- #[[file:.kiro/skills/create-api-endpoint.md]]
- #[[file:.kiro/skills/create-ef-entity.md]]
- #[[file:.kiro/skills/review-code.md]]
