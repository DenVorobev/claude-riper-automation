#!/bin/bash

# RIPER Automation System - Verification Script
# Checks installation status and provides diagnostics

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔍 RIPER Automation System - Verification${NC}"
echo ""

# Counter for issues
issues=0

# Check 1: ~/.claude/bin exists and is accessible
echo -e "${YELLOW}1. Checking ~/.claude/bin directory...${NC}"
if [ -d "$HOME/.claude/bin" ]; then
  echo -e "${GREEN}   ✓ Directory exists${NC}"
  if [ -x "$HOME/.claude/bin" ]; then
    echo -e "${GREEN}   ✓ Directory is accessible${NC}"
  else
    echo -e "${RED}   ✗ Directory not accessible (permission issue)${NC}"
    issues=$((issues + 1))
  fi
else
  echo -e "${RED}   ✗ Directory does not exist${NC}"
  issues=$((issues + 1))
fi
echo ""

# Check 2: Scripts are installed and executable
echo -e "${YELLOW}2. Checking installed scripts...${NC}"
scripts=(
  "auto-memory-save"
  "auto-trigger-innovate"
  "auto-review-reminder"
  "parse-riper-plan"
  "sync-riper-to-todos"
  "validate-riper-workflow"
)

installed_count=0
for script in "${scripts[@]}"; do
  script_path="$HOME/.claude/bin/$script"
  if [ -f "$script_path" ]; then
    if [ -x "$script_path" ]; then
      echo -e "${GREEN}   ✓ $script (executable)${NC}"
      installed_count=$((installed_count + 1))
    else
      echo -e "${YELLOW}   ⚠ $script (not executable)${NC}"
      issues=$((issues + 1))
    fi
  else
    echo -e "${RED}   ✗ $script (not found)${NC}"
    issues=$((issues + 1))
  fi
done
echo ""

# Check 3: Git hooks status
echo -e "${YELLOW}3. Checking git hooks...${NC}"
if [ -d ".git/hooks" ]; then
  hooks_found=0
  for hook in pre-commit post-commit; do
    hook_path=".git/hooks/$hook"
    if [ -f "$hook_path" ]; then
      if [ -x "$hook_path" ]; then
        echo -e "${GREEN}   ✓ $hook (installed and executable)${NC}"
        hooks_found=$((hooks_found + 1))
      else
        echo -e "${YELLOW}   ⚠ $hook (not executable)${NC}"
        issues=$((issues + 1))
      fi
    else
      echo -e "${RED}   ✗ $hook (not installed)${NC}"
    fi
  done
else
  echo -e "${YELLOW}   ⓘ Not in a git repository${NC}"
fi
echo ""

# Check 4: Claude Code hooks configuration
echo -e "${YELLOW}4. Checking Claude Code hooks configuration...${NC}"
if [ -f ".claude/settings.json" ]; then
  if grep -q "UserPromptSubmit" .claude/settings.json; then
    echo -e "${GREEN}   ✓ UserPromptSubmit hook configured${NC}"
  else
    echo -e "${YELLOW}   ⚠ UserPromptSubmit hook not found${NC}"
  fi

  if grep -q "PostToolUse" .claude/settings.json; then
    echo -e "${GREEN}   ✓ PostToolUse hook configured${NC}"
  else
    echo -e "${YELLOW}   ⚠ PostToolUse hook not found${NC}"
  fi

  if grep -q "smart-riper-hint" .claude/settings.json; then
    echo -e "${GREEN}   ✓ smart-riper-hint hook configured${NC}"
  else
    echo -e "${RED}   ✗ smart-riper-hint hook not configured${NC}"
    issues=$((issues + 1))
  fi
else
  echo -e "${YELLOW}   ⓘ .claude/settings.json not found${NC}"
fi
echo ""

# Check 5: Memory Bank structure
echo -e "${YELLOW}5. Checking Memory Bank structure...${NC}"
if [ -d ".claude/memory-bank" ]; then
  echo -e "${GREEN}   ✓ Memory Bank exists${NC}"

  branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
  if [ -d ".claude/memory-bank/$branch" ]; then
    echo -e "${GREEN}   ✓ Branch directory exists ($branch)${NC}"
  else
    echo -e "${YELLOW}   ⓘ No branch directory yet (will be created on first use)${NC}"
  fi
else
  echo -e "${YELLOW}   ⓘ Memory Bank not initialized yet${NC}"
fi
echo ""

# Check 6: Test script execution
echo -e "${YELLOW}6. Testing script execution...${NC}"
if [ -x "$HOME/.claude/bin/validate-riper-workflow" ]; then
  if "$HOME/.claude/bin/validate-riper-workflow" > /dev/null 2>&1; then
    echo -e "${GREEN}   ✓ validate-riper-workflow executes successfully${NC}"
  else
    echo -e "${YELLOW}   ⚠ Script executed but returned non-zero${NC}"
  fi
else
  echo -e "${YELLOW}   ⓘ Cannot test - script not executable${NC}"
fi
echo ""

# Summary
echo "==============================================="
if [ $issues -eq 0 ]; then
  echo -e "${GREEN}✅ All checks passed! Installation is complete.${NC}"
  echo ""
  echo "Your RIPER automation system is ready to use!"
  echo ""
  echo "Try it out:"
  echo "  1. Open Claude Code"
  echo "  2. Type: 'Add webhook retry logic'"
  echo "  3. You should see RIPER workflow suggestions"
  exit 0
else
  echo -e "${RED}⚠️  Found $issues issue(s) that need attention.${NC}"
  echo ""
  echo "To fix:"
  echo "  1. Run: ./install/install.sh (to reinstall)"
  echo "  2. Check: docs/TROUBLESHOOTING.md"
  echo "  3. Verify: ~/.claude/bin permissions (should be 755)"
  exit 1
fi
