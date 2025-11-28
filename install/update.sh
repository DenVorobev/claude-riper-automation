#!/bin/bash

# RIPER Automation System - Update Script
# Updates RIPER scripts to the latest version from the repository

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}⬆️  RIPER Automation System - Update${NC}"
echo ""

# Get script directory
script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
project_root="$(dirname "$script_dir")"

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
  echo -e "${RED}❌ Not in a git repository. Cannot update.${NC}"
  exit 1
fi

echo -e "${YELLOW}📦 Checking for updates...${NC}"
echo ""

# Fetch latest from remote
git fetch origin main 2>/dev/null || {
  echo -e "${RED}❌ Failed to fetch from remote.${NC}"
  exit 1
}

# Check if there are new commits
local_rev=$(git rev-parse main)
remote_rev=$(git rev-parse origin/main)

if [ "$local_rev" = "$remote_rev" ]; then
  echo -e "${GREEN}✓ Already up to date!${NC}"
  exit 0
fi

echo -e "${YELLOW}📥 New updates found. Installing...${NC}"
echo ""

# Pull latest
git pull origin main > /dev/null

# Run install script
echo -e "${YELLOW}📋 Running installer...${NC}"
bash "$script_dir/install.sh"

echo ""
echo -e "${GREEN}✅ Update Complete!${NC}"
echo ""
echo "Changes:"
git log --oneline main@{1}..main | head -5
echo ""
