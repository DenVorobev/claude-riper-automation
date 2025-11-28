#!/bin/bash

# RIPER Automation System - Uninstall Script
# Removes RIPER automation scripts and restores backups if available

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🗑️  RIPER Automation System - Uninstall${NC}"
echo ""
echo -e "${YELLOW}⚠️  This will remove RIPER automation scripts from ~/.claude/bin/${NC}"
echo -e "${YELLOW}Backups will be preserved if they exist.${NC}"
echo ""

# Confirm uninstall
read -p "Are you sure you want to uninstall? (y/N) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Uninstall cancelled."
  exit 0
fi

echo ""
echo -e "${YELLOW}📋 Uninstalling scripts...${NC}"

scripts=(
  "auto-memory-save"
  "auto-trigger-innovate"
  "auto-review-reminder"
  "parse-riper-plan"
  "sync-riper-to-todos"
  "validate-riper-workflow"
)

for script in "${scripts[@]}"; do
  script_path="$HOME/.claude/bin/$script"

  if [ -f "$script_path" ]; then
    rm "$script_path"
    echo -e "${GREEN}  ✓ Removed: $script${NC}"
  else
    echo -e "${YELLOW}  ⓘ Not found: $script${NC}"
  fi
done

echo ""
echo -e "${YELLOW}🔗 Removing git hooks...${NC}"

# Try to remove git hooks from current repo
if [ -d ".git/hooks" ]; then
  for hook in pre-commit post-commit; do
    hook_path=".git/hooks/$hook"
    if [ -f "$hook_path" ]; then
      rm "$hook_path"
      echo -e "${GREEN}  ✓ Removed: $hook${NC}"
    fi
  done
fi

echo ""
echo -e "${YELLOW}💾 Checking for backups...${NC}"

backup_found=false
for script in "${scripts[@]}"; do
  backup_path="$HOME/.claude/bin/${script}.backup"
  if [ -f "$backup_path" ]; then
    echo -e "${YELLOW}  Found backup: $script.backup${NC}"
    backup_found=true
  fi
done

if [ "$backup_found" = true ]; then
  echo ""
  read -p "Restore backups? (y/N) " -n 1 -r
  echo
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    for script in "${scripts[@]}"; do
      backup_path="$HOME/.claude/bin/${script}.backup"
      if [ -f "$backup_path" ]; then
        mv "$backup_path" "$HOME/.claude/bin/$script"
        chmod +x "$HOME/.claude/bin/$script"
        echo -e "${GREEN}  ✓ Restored: $script${NC}"
      fi
    done
  fi
fi

echo ""
echo -e "${GREEN}✅ Uninstall Complete!${NC}"
echo ""
echo "Removed:"
echo "  - Scripts from ~/.claude/bin/"
echo "  - Git hooks from .git/hooks/"
echo ""
echo "Note: .claude/memory-bank/ was NOT removed (contains your data)"
echo ""
