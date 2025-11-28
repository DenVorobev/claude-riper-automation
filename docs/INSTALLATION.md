# Installation Guide

Complete step-by-step guide to install Claude RIPER Automation System.

## Prerequisites

- macOS or Linux (Windows with WSL)
- Git installed and configured
- Claude Code or compatible environment
- Bash shell

## Installation Methods

### Method 1: Automatic Installation (Recommended)

#### Step 1: Clone Repository

```bash
git clone https://github.com/DenVorobev/claude-riper-automation.git
cd claude-riper-automation
```

#### Step 2: Run Install Script

```bash
chmod +x install/install.sh
./install/install.sh
```

#### Step 3: Verify Installation

```bash
./install/verify.sh
```

**Expected Output:**
```
✅ Installation verified successfully!
- Hooks configured in .claude/settings.json
- Scripts copied to ~/.claude/bin/
- Git hooks installed
```

### Method 2: Manual Installation

If automatic installation fails, follow these steps:

#### Step 1: Copy Scripts

```bash
# Create bin directory if needed
mkdir -p ~/.claude/bin

# Copy all scripts
cp bin/* ~/.claude/bin/

# Make executable
chmod +x ~/.claude/bin/*
```

#### Step 2: Configure Hooks

Edit `.claude/settings.json` and add:

```json
{
  "hooks": {
    "SessionStart": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/bin/smart-riper-hint"
          }
        ]
      }
    ],
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/bin/auto-memory-save"
          },
          {
            "type": "command",
            "command": "~/.claude/bin/auto-trigger-innovate"
          },
          {
            "type": "command",
            "command": "~/.claude/bin/auto-review-reminder"
          },
          {
            "type": "command",
            "command": "~/.claude/bin/sync-riper-to-todos"
          }
        ]
      }
    ],
    "PostToolUse": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "~/.claude/bin/validate-riper-workflow"
          }
        ]
      }
    ]
  }
}
```

#### Step 3: Install Git Hooks

```bash
# Copy hooks to current project
cp hooks/pre-commit .git/hooks/
cp hooks/post-commit .git/hooks/
chmod +x .git/hooks/pre-commit .git/hooks/post-commit
```

#### Step 4: Add to Permissions

Edit `.claude/settings.local.json`:

```json
{
  "permissions": {
    "allow": [
      "Bash(~/.claude/bin/*:*)",
      "Bash(git commit:*)",
      "Bash(git add:*)"
    ]
  }
}
```

## Installation Locations

### Scripts Location
- **Mac/Linux:** `~/.claude/bin/`
- **Where:** User's home directory, Claude Code tools folder

### Git Hooks Location
- **Path:** `.git/hooks/` (in each project)
- **Files:** `pre-commit`, `post-commit`

### Configuration Location
- **Path:** `.claude/settings.json` (project root)
- **Hook definitions:** SessionStart, UserPromptSubmit, PostToolUse

## Verification Steps

After installation, verify each component:

### 1. Check Scripts Installed

```bash
ls -la ~/.claude/bin/ | grep -E "auto-|smart-|sync-|validate-|parse-"
```

Expected: All script files should be listed and executable (x permission)

### 2. Check Hooks Configured

```bash
cat .claude/settings.json | grep -A 5 "hooks"
```

Expected: Should show hooks configuration with all commands

### 3. Check Git Hooks

```bash
ls -la .git/hooks/ | grep -E "pre-commit|post-commit"
```

Expected: Should show pre-commit and post-commit as executable files

### 4. Test Smart Hint

Start a new Claude Code session:

```
SessionStart should output:
💡 RIPER ready: Use /riper:workflow for complex tasks...
```

### 5. Test Complexity Detection

Send a message with keywords:

```
You: "Integrate Stripe API"

Expected:
🚀 RIPER Workflow Recommendation
This looks like a complex/architectural task.

Options:
  1. Full workflow (5 phases): /riper:workflow
  2. Start with analysis: /riper:research
  ...
```

## Uninstallation

If you need to remove the system:

```bash
chmod +x install/uninstall.sh
./install/uninstall.sh
```

This will:
- Remove scripts from `~/.claude/bin/`
- Remove git hooks from `.git/hooks/`
- Remove hook configuration from `.claude/settings.json`
- Create backups before removing

## Troubleshooting

### Scripts Not Executing

**Problem:** "command not found: auto-memory-save"

**Solution:**
```bash
# Check path
which auto-memory-save

# If not found, ensure ~/.claude/bin/ is in PATH
echo $PATH | grep -q ~/.claude/bin || echo 'Add to PATH'

# Add to bash profile if needed
echo 'export PATH="$HOME/.claude/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Hooks Not Triggering

**Problem:** Hooks in settings.json but not executing

**Solution:**
1. Check file permissions: `ls -la ~/.claude/bin/`
2. Verify settings.json syntax: `cat .claude/settings.json | jq .`
3. Restart Claude Code application
4. Check for error messages in logs

### Git Hooks Not Running

**Problem:** Pre-commit hook doesn't block commits

**Solution:**
```bash
# Make hooks executable
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/post-commit

# Test hook directly
.git/hooks/pre-commit

# Check if hooks directory exists
ls -la .git/hooks/
```

### Permission Denied

**Problem:** "permission denied: auto-memory-save"

**Solution:**
```bash
# Make all scripts executable
chmod +x ~/.claude/bin/*

# Verify
ls -l ~/.claude/bin/ | grep -v "^-"
```

## Update Installation

To update to latest version:

```bash
cd claude-riper-automation
git pull origin main
./install/update.sh
```

This will:
- Backup current scripts
- Update all files
- Verify new installation
- Show changelog

## Support

If installation fails:

1. Check [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. Verify prerequisites
3. Try manual installation method
4. Check git issues on GitHub

---

**Last Updated:** 2025-01-28
**Version:** 0.1.0
