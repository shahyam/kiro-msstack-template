# Skill: Create ASP.NET Core API Endpoint

## When to use
When asked to add a new API endpoint, REST resource, or controller action.

## Steps

1. Create or update the controller in `/src/Api/Controllers/`
2. Add the corresponding service interface in `/src/Core/Interfaces/`
3. Implement the service in `/src/Core/Services/`
4. Add repository method in `/src/Infrastructure/Repositories/` if DB access needed
5. Create request/response DTOs as `record` types in `/src/Core/DTOs/`
6. Register new services in DI if not already registered
7. Add FluentValidation validator for request DTO if input is complex

## Template

```csharp
// Controller
[ApiController]
[Route("api/[controller]")]
public class {Entity}Controller : ControllerBase
{
    private readonly I{Entity}Service _service;
    private readonly ILogger<{Entity}Controller> _logger;

    public {Entity}Controller(I{Entity}Service service, ILogger<{Entity}Controller> logger)
    {
        _service = service;
        _logger = logger;
    }

    [HttpGet("{id:int}")]
    public async Task<ActionResult<{Entity}Response>> GetById(int id, CancellationToken ct)
    {
        var result = await _service.GetByIdAsync(id, ct);
        return result is null ? NotFound() : Ok(result);
    }

    [HttpPost]
    public async Task<ActionResult<{Entity}Response>> Create(
        [FromBody] Create{Entity}Request request, CancellationToken ct)
    {
        var result = await _service.CreateAsync(request, ct);
        return CreatedAtAction(nameof(GetById), new { id = result.Id }, result);
    }
}

// DTOs
public record Create{Entity}Request(string Name /* add fields */);
public record {Entity}Response(int Id, string Name /* add fields */);

// Service Interface
public interface I{Entity}Service
{
    Task<{Entity}Response?> GetByIdAsync(int id, CancellationToken ct);
    Task<{Entity}Response> CreateAsync(Create{Entity}Request request, CancellationToken ct);
}
```
