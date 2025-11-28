#!/bin/bash

# RIPER Automation System - Installation Script
# Installs RIPER automation scripts globally for use across all projects

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 RIPER Automation System - Installation${NC}"
echo ""

# Get script directory (where install.sh is)
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(dirname "$script_dir")"

echo -e "${YELLOW}ℹ️  Installation Details:${NC}"
echo "  Project Root: $project_root"
echo "  Install Script: $script_dir/install.sh"
echo ""

# Step 1: Create ~/.claude/bin if not exists
echo -e "${YELLOW}📁 Setting up ~/.claude/bin directory...${NC}"
mkdir -p ~/.claude/bin
chmod 755 ~/.claude/bin
echo -e "${GREEN}✓ Directory created${NC}"
echo ""

# Step 2: Copy automation scripts
echo -e "${YELLOW}📋 Installing automation scripts...${NC}"
scripts=(
  "auto-memory-save"
  "auto-trigger-innovate"
  "auto-review-reminder"
  "parse-riper-plan"
  "sync-riper-to-todos"
  "validate-riper-workflow"
)

for script in "${scripts[@]}"; do
  src="$project_root/bin/$script"
  dst="$HOME/.claude/bin/$script"

  if [ -f "$src" ]; then
    # Backup existing if it exists
    if [ -f "$dst" ]; then
      echo -e "${YELLOW}  Backing up existing: $script${NC}"
      cp "$dst" "$dst.backup"
    fi

    cp "$src" "$dst"
    chmod +x "$dst"
    echo -e "${GREEN}  ✓ Installed: $script${NC}"
  else
    echo -e "${RED}  ✗ Not found: $src${NC}"
  fi
done
echo ""

# Step 3: Copy git hooks (if in a git repo)
echo -e "${YELLOW}🔗 Setting up git hooks...${NC}"
if [ -d "$project_root/.git" ]; then
  hooks_dir="$project_root/.git/hooks"
  mkdir -p "$hooks_dir"

  hook_files=("pre-commit" "post-commit")
  for hook in "${hook_files[@]}"; do
    src="$project_root/hooks/$hook"
    dst="$hooks_dir/$hook"

    if [ -f "$src" ]; then
      # Backup existing if it exists
      if [ -f "$dst" ]; then
        echo -e "${YELLOW}  Backing up existing: $hook${NC}"
        cp "$dst" "$dst.backup"
      fi

      cp "$src" "$dst"
      chmod +x "$dst"
      echo -e "${GREEN}  ✓ Installed: $hook${NC}"
    else
      echo -e "${RED}  ✗ Not found: $src${NC}"
    fi
  done
else
  echo -e "${YELLOW}  ⓘ Not a git repo, skipping git hooks${NC}"
fi
echo ""

# Step 4: Verify installation
echo -e "${YELLOW}🔍 Verifying installation...${NC}"
all_good=true

for script in "${scripts[@]}"; do
  if [ -x "$HOME/.claude/bin/$script" ]; then
    echo -e "${GREEN}  ✓ $script${NC}"
  else
    echo -e "${RED}  ✗ $script (not executable)${NC}"
    all_good=false
  fi
done

if [ "$all_good" = true ]; then
  echo ""
  echo -e "${GREEN}✅ Installation Complete!${NC}"
  echo ""
  echo -e "${BLUE}Next Steps:${NC}"
  echo "  1. Update your .claude/settings.json with hooks (see INSTALLATION.md)"
  echo "  2. Restart Claude Code to load new hooks"
  echo "  3. Try using RIPER workflow: /riper:research"
  echo ""
  echo -e "${YELLOW}Documentation:${NC}"
  echo "  • Installation: $project_root/docs/INSTALLATION.md"
  echo "  • Usage Guide: $project_root/docs/USAGE.md"
  echo "  • Troubleshooting: $project_root/docs/TROUBLESHOOTING.md"
  exit 0
else
  echo ""
  echo -e "${RED}❌ Installation had issues. Check paths above.${NC}"
  exit 1
fi
