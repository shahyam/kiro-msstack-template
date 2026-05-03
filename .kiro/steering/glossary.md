---
inclusion: always
---

# Glossary

This file defines domain terms, entity names, and abbreviations used in this project.
The AI agent must use these exact names — never invent synonyms or alternative spellings.

## Instructions for the Agent

- Use the exact class/table/variable names listed here
- If a term is not in this glossary, ask the user before assuming
- Never abbreviate entity names unless the abbreviation is listed here

## Core Entities

> Replace these placeholders with your actual domain entities before using this template.

| Term | Type | Description |
|---|---|---|
| `User` | Entity | System user with login credentials |
| `Role` | Entity | Permission group assigned to users |
| `AuditLog` | Entity | Record of significant system changes |
| `{Entity}` | Domain Entity | Replace with your actual entity name |
| `{AggregateRoot}` | Aggregate Root | Replace with your aggregate root name |

## Abbreviations

| Abbreviation | Full Form |
|---|---|
| DTO | Data Transfer Object |
| EF | Entity Framework |
| DI | Dependency Injection |
| API | Application Programming Interface |
| MVC | Model-View-Controller |
| SPA | Single Page Application |
| MSSQL | Microsoft SQL Server |
| ADR | Architecture Decision Record |
| PII | Personally Identifiable Information |
| JWT | JSON Web Token |

## Bounded Contexts

> Define your bounded contexts here if using DDD.

| Context | Responsibility |
|---|---|
| `Identity` | Authentication, Authorization, User management |
| `Catalog` | Product listing, categories, and search (Example) |
| `{ContextName}` | Replace with actual bounded context |

## Naming Rules

- Database tables: plural PascalCase (`Orders`, `CustomerAddresses`)
- C# classes: singular PascalCase (`Order`, `CustomerAddress`)
- React components: singular PascalCase (`OrderList`, `CustomerForm`)
- API routes: plural kebab-case (`/api/orders`, `/api/customer-addresses`)
- Enums: singular PascalCase (`OrderStatus`, `UserType`)
