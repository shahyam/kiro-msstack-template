# Skill: Setup CI/CD Pipeline (GitHub Actions)

## When to use
When asked to create a CI/CD pipeline for a .NET API and/or React Vite app with build,
test, package, and deploy to Artifactory stages.

## Required Inputs (ask the user for these before generating)

| Parameter | Description | Example |
|---|---|---|
| `DOTNET_PROJECT_PATH` | Path to the .csproj or .sln file | `src/Api/MyApp.Api.csproj` |
| `DOTNET_TEST_PATH` | Path to the test project(s) | `tests/Unit` |
| `REACT_APP_PATH` | Path to the React Vite app folder | `src/Web` |
| `ARTIFACTORY_URL` | Base URL of your Artifactory instance | `https://myorg.jfrog.io/artifactory` |
| `ARTIFACTORY_REPO_DOTNET` | Artifactory NuGet/generic repo name | `dotnet-releases` |
| `ARTIFACTORY_REPO_NPM` | Artifactory npm repo name | `npm-releases` |
| `DOTNET_VERSION` | .NET SDK version | `9.0.x` |
| `NODE_VERSION` | Node.js version | `20.x` |
| `APP_NAME` | Application name used for artifact naming | `my-app` |
| `DEPLOY_ENVIRONMENT` | Target environment for deployment | `staging` or `production` |

## Pipeline Stages

1. `build` — restore dependencies, compile
2. `test` — run unit + integration tests, publish results
3. `package` — create deployable artifact (NuGet package / npm tarball / Docker image)
4. `deploy` — push artifact to Artifactory

## Generated Files

- `.github/workflows/dotnet-ci.yml` — .NET build/test/package/deploy pipeline
- `.github/workflows/react-ci.yml` — React build/test/package/deploy pipeline

---

## .NET Pipeline Template

```yaml
# .github/workflows/dotnet-ci.yml
# Parameters to replace before use:
#   {{DOTNET_VERSION}}        - e.g. 9.0.x
#   {{DOTNET_PROJECT_PATH}}   - e.g. src/Api/MyApp.Api.csproj
#   {{DOTNET_TEST_PATH}}      - e.g. tests/Unit
#   {{APP_NAME}}              - e.g. my-app
#   {{ARTIFACTORY_URL}}       - e.g. https://myorg.jfrog.io/artifactory
#   {{ARTIFACTORY_REPO_DOTNET}} - e.g. dotnet-releases
#   {{DEPLOY_ENVIRONMENT}}    - e.g. staging

name: .NET CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  DOTNET_VERSION: '{{DOTNET_VERSION}}'
  PROJECT_PATH: '{{DOTNET_PROJECT_PATH}}'
  TEST_PATH: '{{DOTNET_TEST_PATH}}'
  APP_NAME: '{{APP_NAME}}'
  ARTIFACT_VERSION: ${{ github.run_number }}

jobs:
  # ─────────────────────────────────────────
  # Stage 1: Build
  # ─────────────────────────────────────────
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Restore dependencies
        run: dotnet restore ${{ env.PROJECT_PATH }}

      - name: Build
        run: dotnet build ${{ env.PROJECT_PATH }}
          --configuration Release
          --no-restore
          /WarnAsError  # treat warnings as errors

      - name: Upload build artifact
        uses: actions/upload-artifact@v4
        with:
          name: build-output
          path: '**/bin/Release/**'
          retention-days: 1

  # ─────────────────────────────────────────
  # Stage 2: Test
  # ─────────────────────────────────────────
  test:
    name: Test
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Restore
        run: dotnet restore ${{ env.PROJECT_PATH }}

      - name: Run tests
        run: dotnet test ${{ env.TEST_PATH }}
          --configuration Release
          --no-build
          --logger "trx;LogFileName=test-results.trx"
          --collect:"XPlat Code Coverage"
          -- DataCollectionRunSettings.DataCollectors.DataCollector.Configuration.Format=cobertura

      - name: Publish test results
        uses: dorny/test-reporter@v1
        if: always()  # run even if tests fail
        with:
          name: .NET Test Results
          path: '**/*.trx'
          reporter: dotnet-trx

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: coverage-report
          path: '**/coverage.cobertura.xml'

  # ─────────────────────────────────────────
  # Stage 3: Package
  # ─────────────────────────────────────────
  package:
    name: Package
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop'
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Pack NuGet package
        run: dotnet pack ${{ env.PROJECT_PATH }}
          --configuration Release
          --no-build
          --output ./artifacts
          /p:PackageVersion=1.0.${{ env.ARTIFACT_VERSION }}

      - name: Upload package artifact
        uses: actions/upload-artifact@v4
        with:
          name: nuget-package
          path: ./artifacts/*.nupkg

  # ─────────────────────────────────────────
  # Stage 4: Deploy to Artifactory
  # ─────────────────────────────────────────
  deploy:
    name: Deploy to Artifactory
    runs-on: ubuntu-latest
    needs: package
    environment: '{{DEPLOY_ENVIRONMENT}}'  # requires environment approval in GitHub
    steps:
      - name: Download package
        uses: actions/download-artifact@v4
        with:
          name: nuget-package
          path: ./artifacts

      - name: Setup .NET
        uses: actions/setup-dotnet@v4
        with:
          dotnet-version: ${{ env.DOTNET_VERSION }}

      - name: Add Artifactory NuGet source
        run: dotnet nuget add source '{{ARTIFACTORY_URL}}/api/nuget/{{ARTIFACTORY_REPO_DOTNET}}'
          --name Artifactory
          --username ${{ secrets.ARTIFACTORY_USER }}      # set in GitHub secrets
          --password ${{ secrets.ARTIFACTORY_API_KEY }}   # set in GitHub secrets
          --store-password-in-clear-text  # required for non-Windows runners

      - name: Push to Artifactory
        run: dotnet nuget push ./artifacts/*.nupkg
          --source Artifactory
          --skip-duplicate
```

---

## React Pipeline Template

```yaml
# .github/workflows/react-ci.yml
# Parameters to replace before use:
#   {{NODE_VERSION}}          - e.g. 20.x
#   {{REACT_APP_PATH}}        - e.g. src/Web
#   {{APP_NAME}}              - e.g. my-app
#   {{ARTIFACTORY_URL}}       - e.g. https://myorg.jfrog.io/artifactory
#   {{ARTIFACTORY_REPO_NPM}}  - e.g. npm-releases
#   {{DEPLOY_ENVIRONMENT}}    - e.g. staging

name: React CI/CD

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

env:
  NODE_VERSION: '{{NODE_VERSION}}'
  APP_PATH: '{{REACT_APP_PATH}}'
  APP_NAME: '{{APP_NAME}}'

jobs:
  # ─────────────────────────────────────────
  # Stage 1: Build
  # ─────────────────────────────────────────
  build:
    name: Build
    runs-on: ubuntu-latest
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: ${{ env.APP_PATH }}/package-lock.json

      - name: Install dependencies
        run: npm ci  # ci = clean install, respects package-lock.json exactly
        working-directory: ${{ env.APP_PATH }}

      - name: Build
        run: npm run build
        working-directory: ${{ env.APP_PATH }}
        env:
          VITE_API_BASE_URL: ${{ secrets.VITE_API_BASE_URL }}  # injected at build time

      - name: Upload build artifact
        uses: actions/upload-artifact@v4
        with:
          name: react-dist
          path: ${{ env.APP_PATH }}/dist
          retention-days: 1

  # ─────────────────────────────────────────
  # Stage 2: Test
  # ─────────────────────────────────────────
  test:
    name: Test
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          cache: 'npm'
          cache-dependency-path: ${{ env.APP_PATH }}/package-lock.json

      - name: Install dependencies
        run: npm ci
        working-directory: ${{ env.APP_PATH }}

      - name: Run tests
        run: npm run test -- --run --reporter=verbose --coverage
        # --run = single pass, no watch mode (required for CI)
        working-directory: ${{ env.APP_PATH }}

      - name: Upload coverage
        uses: actions/upload-artifact@v4
        with:
          name: react-coverage
          path: ${{ env.APP_PATH }}/coverage

  # ─────────────────────────────────────────
  # Stage 3: Package
  # ─────────────────────────────────────────
  package:
    name: Package
    runs-on: ubuntu-latest
    needs: test
    if: github.ref == 'refs/heads/main' || github.ref == 'refs/heads/develop'
    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Download dist
        uses: actions/download-artifact@v4
        with:
          name: react-dist
          path: dist

      - name: Create tarball
        run: |
          VERSION="1.0.${{ github.run_number }}"
          # Update version in package.json for the artifact
          npm version $VERSION --no-git-tag-version
          npm pack  # creates {{APP_NAME}}-{version}.tgz
        working-directory: ${{ env.APP_PATH }}

      - name: Upload package
        uses: actions/upload-artifact@v4
        with:
          name: npm-package
          path: ${{ env.APP_PATH }}/*.tgz

  # ─────────────────────────────────────────
  # Stage 4: Deploy to Artifactory
  # ─────────────────────────────────────────
  deploy:
    name: Deploy to Artifactory
    runs-on: ubuntu-latest
    needs: package
    environment: '{{DEPLOY_ENVIRONMENT}}'
    steps:
      - name: Download package
        uses: actions/download-artifact@v4
        with:
          name: npm-package
          path: ./package

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: ${{ env.NODE_VERSION }}
          registry-url: '{{ARTIFACTORY_URL}}/api/npm/{{ARTIFACTORY_REPO_NPM}}/'

      - name: Publish to Artifactory
        run: npm publish ./package/*.tgz --access public
        env:
          NODE_AUTH_TOKEN: ${{ secrets.ARTIFACTORY_API_KEY }}  # set in GitHub secrets
```

---

## GitHub Secrets Required

Set these in your GitHub repository under Settings > Secrets and variables > Actions:

| Secret | Description |
|---|---|
| `ARTIFACTORY_USER` | Artifactory service account username |
| `ARTIFACTORY_API_KEY` | Artifactory API key or identity token |
| `VITE_API_BASE_URL` | Backend API URL injected at React build time |

## Notes

- Both pipelines gate on `needs:` — a failed test blocks packaging and deployment
- `environment:` on the deploy job enables GitHub environment protection rules (manual approval)
- Versioning uses `github.run_number` — replace with a proper semver strategy if needed
- For monorepos, use `paths:` filters on the `on:` trigger to only run the relevant pipeline when files in that app change
