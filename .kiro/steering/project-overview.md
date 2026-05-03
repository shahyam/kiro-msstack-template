---
inclusion: always
---

# Project Overview

This project uses a Microsoft-centric stack:

- Backend: .NET C# (ASP.NET Core Web API / MVC)
- Frontend: React JS
- Database: Microsoft SQL Server (MSSQL)
- ORM: Entity Framework Core
- Auth: ASP.NET Identity / Azure AD
- Hosting: IIS / Azure App Service

## Project Structure

```
/src
  /Api          - ASP.NET Core Web API
  /Web          - ASP.NET MVC or React frontend
  /Core         - Domain models, interfaces, business logic
  /Infrastructure - EF Core, repositories, external services
/tests
  /Unit
  /Integration
/scripts        - DB migration scripts, deployment scripts
```

## Key Conventions

- Follow Microsoft coding conventions for C#
- Use PascalCase for classes, methods, properties
- Use camelCase for local variables and parameters
- Async/await for all I/O operations
- Repository pattern for data access
- Dependency injection via built-in .NET DI container
