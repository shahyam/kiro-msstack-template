# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-05-03

### Added
- Initial release of Kiro MS Stack Template
- Steering files for .NET 9, React + Vite, MSSQL, and testing standards
- Skills for creating API endpoints, EF entities, React components, SQL migrations, tests, CI/CD pipelines, and code reviews
- Validation script (`validate-kiro-files.js`) for checking steering/skills file syntax
- Micro commits guidance in git workflow
- Context hints to guide agent on which files to read per task
- Glossary for domain terms to prevent hallucination
- Do-not-do constraints for critical rules
- ADR template for architecture decisions
- NSubstitute as the mocking library (not Moq)
- Serilog as the logging library
- Commented examples (✅/❌) in dotnet-standards, react-standards, and mssql-standards
- GitHub Actions CI/CD pipeline templates for .NET and React with Artifactory deployment
