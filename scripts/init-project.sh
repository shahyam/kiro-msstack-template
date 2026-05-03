#!/bin/bash

# Kiro Template Bootstrap Script
# Quickly initialize a new project with Kiro configuration
# Usage: ./scripts/init-project.sh /path/to/new/project

set -e

PROJECT_DIR="${1:-.}"
TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Kiro Template Bootstrap ===${NC}"
echo ""

# Validate project directory
if [ ! -d "$PROJECT_DIR" ]; then
    echo -e "${RED}❌ Error: Directory does not exist: $PROJECT_DIR${NC}"
    exit 1
fi

if [ -d "$PROJECT_DIR/.kiro" ]; then
    echo -e "${RED}❌ Error: .kiro/ already exists in $PROJECT_DIR. Aborting.${NC}"
    exit 1
fi

cd "$PROJECT_DIR"

# Gather project info
echo -e "${BLUE}📋 Project Setup${NC}"
read -p "Project name (e.g., MyAwesomeApp): " PROJECT_NAME
read -p "Project description: " PROJECT_DESCRIPTION

echo ""
echo -e "${BLUE}🛠️  Technology Stack${NC}"
read -p "Using React? (y/n) [y]: " USE_REACT
USE_REACT=${USE_REACT:-y}

read -p "Using MSSQL? (y/n) [y]: " USE_MSSQL
USE_MSSQL=${USE_MSSQL:-y}

read -p "Using GitHub Actions CI/CD? (y/n) [y]: " USE_CICD
USE_CICD=${USE_CICD:-y}

# Copy template files
echo ""
echo -e "${BLUE}📦 Copying template files...${NC}"

cp -r "$TEMPLATE_DIR/.kiro" "$PROJECT_DIR/" || { echo -e "${RED}Failed to copy .kiro/"; exit 1; }
cp -r "$TEMPLATE_DIR/scripts" "$PROJECT_DIR/" || { echo -e "${RED}Failed to copy scripts/"; exit 1; }
cp "$TEMPLATE_DIR/.env.example" "$PROJECT_DIR/" || { echo -e "${RED}Failed to copy .env.example"; exit 1; }
cp "$TEMPLATE_DIR/appsettings.example.json" "$PROJECT_DIR/" || { echo -e "${RED}Failed to copy appsettings.example.json"; exit 1; }

echo -e "${GREEN}✅ Files copied${NC}"

# Update project-overview.md
echo ""
echo -e "${BLUE}🎯 Customizing project-overview.md...${NC}"

PROJECT_OVERVIEW=".kiro/steering/project-overview.md"
sed -i "s/\[Project Name\]/$PROJECT_NAME/g" "$PROJECT_OVERVIEW"
sed -i "s|\[Project Description\]|$PROJECT_DESCRIPTION|g" "$PROJECT_OVERVIEW"

echo -e "${GREEN}✅ Updated project-overview.md${NC}"

# Remove unused skills
echo ""
echo -e "${BLUE}🧹 Removing unused skills...${NC}"

if [ "$USE_REACT" != "y" ]; then
    rm -f ".kiro/skills/create-react-component.md"
    echo "  - Removed React component skill"
fi

if [ "$USE_MSSQL" != "y" ]; then
    rm -f ".kiro/skills/write-sql-migration.md"
    echo "  - Removed SQL migration skill"
fi

if [ "$USE_CICD" != "y" ]; then
    rm -f ".kiro/skills/setup-ci-pipeline.md"
    echo "  - Removed CI/CD skill"
fi

echo -e "${GREEN}✅ Cleaned up unused skills${NC}"

# Validate configuration
echo ""
echo -e "${BLUE}✔️  Validating configuration...${NC}"

if command -v node &> /dev/null; then
    if node scripts/validate-kiro-files.js; then
        echo -e "${GREEN}✅ Validation passed${NC}"
    else
        echo -e "${RED}❌ Validation failed. Please fix errors above.${NC}"
        exit 1
    fi
else
    echo -e "${RED}⚠️  Node.js not found. Skipping validation. Run: node scripts/validate-kiro-files.js${NC}"
fi

# Summary
echo ""
echo -e "${GREEN}=== Setup Complete ===${NC}"
echo ""
echo "📝 Next steps:"
echo "  1. Edit .kiro/steering/glossary.md - add your domain entities and terms"
echo "  2. Edit .kiro/steering/do-not-do.md - add project-specific constraints"
echo "  3. Create environment files from examples:"
echo "     cp .env.example src/Web/.env.development"
echo "     cp appsettings.example.json src/Api/appsettings.Development.json"
echo "  4. Test with Kiro - open project and check 'Included Rules' in chat"
echo "  5. Commit: git add .kiro/ scripts/ && git commit -m 'chore: add Kiro configuration'"
echo ""
echo -e "${BLUE}Documentation: $TEMPLATE_DIR/README.md${NC}"
