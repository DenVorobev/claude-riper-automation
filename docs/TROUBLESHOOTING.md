# Troubleshooting Guide

Common issues and solutions for Claude RIPER Automation System.

## Installation Issues

### "command not found: smart-riper-hint"

**Problem:** Script not found when hook tries to run

**Solution:**
```bash
# Verify installation
ls -la ~/.claude/bin/smart-riper-hint

# If not found, re-run install
./install/install.sh

# Or manually copy
cp bin/* ~/.claude/bin/
chmod +x ~/.claude/bin/*
```

### Hooks not executing

**Problem:** Hooks in settings.json but not running

**Causes & Solutions:**

1. **Restart Claude Code**
   ```
   Close and reopen Claude Code
   Settings changes require restart
   ```

2. **Check permissions**
   ```bash
   ls -l ~/.claude/bin/ | head -5
   # All scripts should have 'x' (executable)

   # Fix if needed
   chmod +x ~/.claude/bin/*
   ```

3. **Verify settings.json**
   ```bash
   # Check syntax
   jq . .claude/settings.json | head -20

   # Should not show errors
   ```

4. **Check hook paths**
   ```bash
   # Verify path is absolute
   grep -r "~/.claude/bin" .claude/settings.json

   # Should show full path like:
   # /Users/username/.claude/bin/smart-riper-hint
   ```

### "Permission denied" on hook execution

**Problem:** Hook file exists but can't execute

**Solution:**
```bash
# Make hooks executable
chmod +x ~/.claude/bin/*
chmod +x .git/hooks/pre-commit
chmod +x .git/hooks/post-commit

# Verify
ls -l ~/.claude/bin/smart-riper-hint
# Should show: -rwxr-xr-x
```

## Runtime Issues

### Smart hint not showing up

**Problem:** No RIPER suggestion when describing task

**Cause:** Keywords not matching

**Solution:**
```bash
# Keywords should include (case-insensitive):
- CRITICAL: "webhook", "retry", "database", "architecture"
- MEDIUM: "feature", "refactor", "function"

# Use these keywords in description:
Good: "Add webhook retry logic for payments"
Bad: "Update code"
```

### Auto-save not working

**Problem:** Decisions not saved to Memory Bank

**Possible Causes:**

1. **Memory Bank not initialized**
   ```bash
   # Check memory bank exists
   ls -la .claude/memory-bank/

   # If missing, create it
   mkdir -p .claude/memory-bank/main/sessions
   ```

2. **No CRITICAL/HIGH keywords detected**
   ```bash
   # Use proper keywords
   Good: "Integrate Stripe API"
   Bad: "Add payment"
   ```

3. **Hook not triggering**
   - Check that PostToolUse hook is configured
   - Script must run after Write/Edit operations

**Verification:**
```bash
# Check hook is set up
grep -A 3 "PostToolUse" .claude/settings.json

# Should include auto-memory-save hook
```

### Git hooks blocking commits unexpectedly

**Problem:** Pre-commit hook rejects commit with error

**Common Reasons:**

1. **No RIPER plan found**
   ```
   Error: Missing RIPER plan

   Solution: Run /riper:plan before /riper:execute
   ```

2. **REVIEW phase not completed**
   ```
   Error: No review file found

   Solution: Run /riper:review after /riper:execute
   ```

3. **Tests failing**
   ```
   Error: Tests not passing

   Solution: npm test  (fix failures)
   ```

4. **Type errors**
   ```
   Error: TypeScript errors found

   Solution: tsc --noEmit  (fix errors)
   ```

**Bypass (use carefully):**
```bash
# Only if you know it's safe
git commit --no-verify -m "message"
```

### TodoList not syncing with plan

**Problem:** /riper:execute doesn't create todo list

**Causes:**

1. **Plan not in expected location**
   ```bash
   # Check plan exists
   ls -la .claude/memory-bank/[branch]/plans/

   # Plan should be: [branch]-[date]-[name].md
   ```

2. **Plan missing "## Implementation Steps"**
   ```bash
   # Check plan format
   grep "Implementation Steps" .claude/memory-bank/main/plans/*.md

   # If not found, plan format is wrong
   ```

3. **Script can't read plan**
   ```bash
   # Verify parse-riper-plan script
   ls -la ~/.claude/bin/parse-riper-plan

   # Test it
   ~/.claude/bin/parse-riper-plan path/to/plan.md
   ```

## Performance Issues

### Hooks running slowly

**Problem:** Commits take too long

**Solutions:**

1. **Optimize test suite**
   ```bash
   # Only run relevant tests
   npm test -- --testPathPattern=webhook
   ```

2. **Skip type checking (temporarily)**
   ```bash
   # Remove from pre-commit if too slow
   # Just keep essential checks
   ```

3. **Profile the hook**
   ```bash
   # Add timing to hook
   time .git/hooks/pre-commit
   ```

### Memory Bank getting too large

**Problem:** Memory Bank directory too big

**Solution:**
```bash
# Clean old entries
# Keep only last 6 months of sessions
find .claude/memory-bank/*/sessions -mtime +180 -delete

# Compress old plans
gzip .claude/memory-bank/*/plans/*.md
```

## Debug Mode

### Enable verbose logging

**Add to hook for debugging:**

```bash
# In .git/hooks/pre-commit, add:
set -x  # Enable debug output

# This will show every command executing
```

### Check hook execution step-by-step

```bash
# Run hook directly (not through git)
bash -x .git/hooks/pre-commit

# -x flag shows each command before executing
```

### Verify each script individually

```bash
# Test each script
~/.claude/bin/smart-riper-hint "test message"
~/.claude/bin/auto-memory-save "architectural decision"
~/.claude/bin/auto-trigger-innovate
~/.claude/bin/auto-review-reminder
~/.claude/bin/sync-riper-to-todos
```

## Common Workflows to Fix Issues

### "Hooks are not running"

```bash
# 1. Verify installation
./install/verify.sh

# 2. Check permissions
chmod +x ~/.claude/bin/*

# 3. Restart Claude Code
# (close and reopen app)

# 4. Test with simple message
# (describe a task, see if hint shows)
```

### "Git hooks are blocking everything"

```bash
# 1. Check what's failing
.git/hooks/pre-commit 2>&1 | head -20

# 2. Fix the issue (e.g., run tests)
npm test

# 3. Try commit again
git commit -m "message"

# 4. If still blocked, check logs
# and run validation manually
```

### "Nothing is being saved to Memory Bank"

```bash
# 1. Verify Memory Bank structure
ls -la .claude/memory-bank/

# 2. Check hook configuration
grep -A 5 "auto-memory-save" .claude/settings.json

# 3. Test script directly
echo "We use PostgreSQL" | ~/.claude/bin/auto-memory-save

# 4. Check output in Memory Bank
ls -la .claude/memory-bank/main/sessions/
```

## Reset/Reinstall

### Clean uninstall and reinstall

```bash
# 1. Uninstall
./install/uninstall.sh

# 2. Clean directories
rm -rf ~/.claude/bin/smart-riper*
rm -rf ~/.claude/bin/auto-*
rm -rf ~/.claude/bin/sync-*
rm -rf .git/hooks/pre-commit
rm -rf .git/hooks/post-commit

# 3. Reinstall
./install/install.sh

# 4. Verify
./install/verify.sh
```

### Restore from backup

If uninstall created backups:

```bash
# Find backups
ls -la ~/.claude/bin/*.backup

# Restore
cp ~/.claude/bin/*.backup ~/.claude/bin/
chmod +x ~/.claude/bin/*

# Check settings backup
cat .claude/settings.json.backup
```

## Getting Help

### Information to include when asking for help

1. **Error message** - Exact error text
2. **System info** - `uname -a`
3. **Installation method** - Automatic or manual
4. **Relevant files**:
   - `.claude/settings.json`
   - `.git/hooks/pre-commit` (if hook issue)
   - `.claude/memory-bank/` structure

### Check logs

```bash
# Claude Code logs (if available)
tail -f ~/.claude/logs/*

# Git hook output
git commit -v  # Verbose output

# Script output
bash -x ~/.claude/bin/smart-riper-hint "test"
```

---

**Still stuck?** Open an issue on GitHub with details above.
