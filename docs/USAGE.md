# Usage Guide

Detailed guide on how to use Claude RIPER Automation System.

## Quick Start

After installation, the system works automatically:

### 1. Session Start
When you start Claude Code, you see:
```
💡 RIPER ready: Use /riper:workflow for complex tasks or /riper:research to start analyzing
```

### 2. Task Description
Describe your task:
```
You: "Integrate Stripe API with webhook retry logic"
```

### 3. Smart Analysis
System automatically suggests RIPER:
```
🚀 RIPER Workflow Recommendation
This looks like a complex/architectural task.

Options:
  1. Full workflow (5 phases):
     /riper:workflow

  2. Start with analysis:
     /riper:research → analyze current state
     /riper:innovate → explore solutions

  3. Jump to planning:
     /riper:plan → detailed specification

💾 Tip: Important decisions will be auto-saved to Memory Bank
```

## Feature-by-Feature Guide

### Feature #1: Smart RIPER Hint (smart-riper-hint)

**What it does:** Analyzes message complexity and suggests RIPER when needed

**Triggers:** SessionStart, UserPromptSubmit

**Keywords Detected:**

| Level | Keywords |
|-------|----------|
| CRITICAL | архитектур, дизайн, webhook, retry, безопасн, auth, security, payment, stripe, postgresql, database |
| MEDIUM | feature, фича, команда, function, модуль, refactor, error handling, тест |
| LOW | поменяй, текст, кнопка, цвет, стиль (no suggestion) |

**Example:**
```
Input: "Поменяй цвет кнопки"
Output: (silence - not complex enough)

Input: "Добавь aутентификацию через OAuth"
Output: 🚀 RIPER Workflow Recommendation...
```

### Feature #2: Auto-save to Memory Bank (auto-memory-save)

**What it does:** Automatically saves important architectural decisions

**Triggers:** PostToolUse (after Write/Edit operations)

**How it works:**

1. Analyzes your message for decision keywords
2. Determines importance level
3. Auto-calls `/memory:save` with structure data
4. Creates entry in `.claude/memory-bank/`

**Example:**

```
You write in message: "We'll use PostgreSQL with PgBouncer for connection pooling"

System detects: CRITICAL (database architecture + performance)
Auto-saves to Memory Bank:
  - importance: critical
  - decision: PostgreSQL + PgBouncer
  - date: 2025-01-28
  - related_files: [connections.ts, config.js]

Message to you: "💾 Saved: PostgreSQL + PgBouncer for connection pooling"
```

**Importance Levels:**

- **CRITICAL:** Architecture, security, payments, frameworks
- **HIGH:** API integrations, business logic, serious bugs
- **MEDIUM:** Features (if >1 hour work), refactoring
- **LOW:** Text changes, styling, typos (auto-ignored)

### Feature #3: Auto-trigger INNOVATE (auto-trigger-innovate)

**What it does:** Automatically suggests INNOVATE phase after RESEARCH completes

**Triggers:** UserPromptSubmit (when RESEARCH just finished)

**Workflow:**

```
1. You: /riper:research
   (analyzing current webhook implementation)

2. RESEARCH phase completes

3. System shows:
   📝 Research complete! Current findings:
   - Webhook timeout after 30s
   - No retry logic
   - Lost events on server failure

   Ready to explore solutions?
   /riper:innovate

4. You: (agree or continue research)

5. If agreed → auto-executes /riper:innovate
```

### Feature #4: TodoList Integration (sync-riper-to-todos)

**What it does:** Converts RIPER plan steps into actionable TodoList

**Triggers:** UserPromptSubmit (when user says "реализуй" or "implement")

**How it works:**

1. Reads latest RIPER plan from Memory Bank
2. Parses "## Implementation Steps" section
3. Creates TodoList via TodoWrite
4. Tracks progress during EXECUTE

**Example:**

**RIPER Plan contains:**
```
## Implementation Steps
1. Create DLQ queue in webhook-queue.ts
2. Add exponential backoff logic
3. Implement error logging to Sentry
4. Write integration tests
5. Deploy to production
```

**Generated TodoList:**
```
- [ ] Create DLQ queue in webhook-queue.ts
- [ ] Add exponential backoff logic
- [ ] Implement error logging to Sentry
- [ ] Write integration tests
- [ ] Deploy to production
```

**Progress Tracking:**
```
You complete step 1 (Write webhook-queue.ts)
→ System detects: [x] marked as done
→ Shows: "✅ 1/5 steps complete"
→ Suggests: "Continue with step 2..."
```

### Feature #5: Auto-review Reminder (auto-review-reminder)

**What it does:** Reminds you to run REVIEW after EXECUTE completes

**Triggers:** UserPromptSubmit (when EXECUTE just finished)

**Workflow:**

```
1. You: /riper:execute
   (implementing webhook retry system)

2. EXECUTE phase completes
   - All code written
   - Tests passing
   - Commit ready

3. System shows:
   ⚠️ EXECUTE complete!

   Important: Review before commit ensures:
   - Code matches plan
   - Tests passing
   - No extra changes
   - Quality standards met

   Ready for /riper:review?

4. You: /riper:review

5. REVIEW validates:
   - All steps implemented
   - Tests passing
   - No deviations
   - Quality OK
```

### Feature #5B: Git Hooks (pre-commit, post-commit)

**Pre-commit Validation:**

Before allowing commit, checks:

```
✅ Is there a RIPER plan?
   (in .claude/memory-bank/[branch]/plans/)

✅ Was REVIEW phase completed?
   (in .claude/memory-bank/[branch]/reviews/)

✅ Do all tests pass?
   (npm test)

✅ No type errors?
   (tsc --noEmit)

✅ Code quality OK?
   (eslint, prettier)
```

If ANY check fails:
```
❌ COMMIT BLOCKED

Reason: No RIPER plan found
Solution: Run /riper:plan before /riper:execute
          Then try: git commit again
```

**Post-commit Logging:**

After successful commit:
```
✅ Commit successful: abc123def

Logged to Memory Bank:
  - Plan: main-2025-webhook-retry.md
  - EXECUTE: 5 files modified
  - REVIEW: APPROVED
  - Tests: 45 passed
  - Commit hash: recorded
```

## Complete Example Workflow

### Task: Add Payment Processing

```
═══════════════════════════════════════════════════════════════════════════

STEP 1: DESCRIBE TASK
You: "Add Stripe payment integration with webhook handling"

↓ smart-riper-hint detects CRITICAL complexity
Output:
  🚀 RIPER Workflow Recommendation
  Use /riper:workflow for this complex task!
  💾 Tip: Important decisions will be auto-saved

═══════════════════════════════════════════════════════════════════════════

STEP 2: START RIPER WORKFLOW
You: /riper:workflow

↓ RESEARCH PHASE
[Analyzing current payment setup, Stripe requirements, webhook needs]

↓ auto-trigger-innovate detects RESEARCH completion
Output:
  📝 Research complete! Found:
  - Current system has no payments
  - Stripe offers 3 webhook patterns
  - Need retry logic for reliability

  Ready to explore solutions? /riper:innovate

You: /riper:innovate

↓ INNOVATE PHASE
[Exploring 3 payment approaches, analyzing trade-offs]
[Recommendation: Stripe with webhook retries via Dead Letter Queue]

You: "Let's use approach #1: Stripe DLQ"

↓ auto-memory-save detects architectural decision
Output:
  💾 Saved: Stripe with DLQ pattern
  importance: critical
  reasoning: Payment processing requires reliability

You: /riper:plan

↓ PLAN PHASE
[Creating detailed implementation plan]
[Plan saved: main-2025-stripe-integration.md]

Plan includes:
## Implementation Steps
1. Create Stripe account integration
2. Setup webhook receiver in Express
3. Implement DLQ for failed payments
4. Add retry logic with exponential backoff
5. Write integration tests
6. Deploy to staging

═══════════════════════════════════════════════════════════════════════════

STEP 3: IMPLEMENTATION
You: /riper:execute

↓ System reads plan
↓ sync-riper-to-todos creates TodoList
Output:
  📝 Plan loaded! Steps to implement:
  - [ ] Create Stripe account integration
  - [ ] Setup webhook receiver
  - [ ] Implement DLQ
  - [ ] Add retry logic
  - [ ] Write tests
  - [ ] Deploy

[You implement each step...]

After Step 1:
Output:
  ✅ 1/6 steps complete!
  Continue with: Setup webhook receiver

[You implement remaining steps...]

All steps complete:
Output:
  ⚠️ EXECUTE complete!

  All steps implemented. Ready for review?
  /riper:review

You: /riper:review

↓ REVIEW PHASE
[Validating all steps completed correctly]
[Tests passing: 50/50]
[Type checking: OK]
[Code quality: OK]

Output:
  ✅ REVIEW APPROVED

  All steps implemented correctly
  Tests passing
  No deviations from plan
  Ready to commit!

═══════════════════════════════════════════════════════════════════════════

STEP 4: COMMIT
You: git commit -m "feat: Add Stripe payment with DLQ retry logic"

↓ pre-commit hooks validate
  ✅ Plan exists
  ✅ Review completed
  ✅ Tests passing
  ✅ Type checking OK

↓ Commit allowed!

↓ post-commit logging
  ✅ Commit: abc1234567

  Logged to Memory Bank:
  - Plan: main-2025-stripe-integration.md [COMPLETE]
  - EXECUTE: 7 files modified
  - REVIEW: APPROVED
  - Tests: 50 passed, 0 failed
  - Commit: abc1234567

Output:
  💾 Logged to Memory Bank
  Payment integration complete and documented!

═══════════════════════════════════════════════════════════════════════════
```

## Best Practices

### ✅ DO:

- Use `/riper:workflow` for complex tasks
- Let system auto-save decisions
- Follow TodoList during execution
- Run REVIEW before commit
- Keep plans in Memory Bank

### ❌ DON'T:

- Skip REVIEW phase
- Commit without plan
- Ignore system warnings
- Use `git commit --no-verify` (bypasses checks)
- Modify plans mid-execution

## Tips & Tricks

### Tip 1: Reuse Decisions
```
Next time with payments:
"Remember we use Stripe with DLQ?"

System:
✅ Found in Memory Bank: Stripe + DLQ pattern
Applying same approach...
```

### Tip 2: Track Progress
```
During EXECUTE phase:
System shows: ✅ 3/5 steps complete
Remaining: 2 steps (estimated 30 min)
```

### Tip 3: Quick Fixes
```
For simple tasks:
Don't use /riper:workflow

Just: Edit code
System: Auto-validates, tests pass
Done!
```

---

**For troubleshooting:** See [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
