# Claude RIPER Automation System

Complete automation system for RIPER workflow (Research → Innovate → Plan → Execute → Review) with intelligent hooks, git validation, and Memory Bank integration.

## 🎯 Purpose

This system automatically enhances your Claude Code development workflow by:
- 🧠 Intelligently detecting task complexity
- 💾 Auto-saving architectural decisions to Memory Bank
- 🔄 Automating workflow phase transitions
- 📝 Syncing plans with task lists
- ✅ Enforcing quality gates through git hooks
- 📊 Logging progress and decisions

## ✨ Features

### 1. Smart RIPER Hints
- **smart-riper-hint**: Analyzes task complexity and suggests when to use RIPER workflow
- Works automatically on SessionStart and UserPromptSubmit

### 2. Auto-save to Memory Bank (#1)
- **auto-memory-save**: Detects architectural decisions and automatically saves them
- Categories: CRITICAL (architecture), HIGH (API/bugs), MEDIUM (features), LOW (ignored)
- Prevents loss of important decisions

### 3. Workflow Automation (#2-4)
- **auto-trigger-innovate**: After RESEARCH completes → suggests/triggers INNOVATE
- **auto-review-reminder**: After EXECUTE completes → suggests/triggers REVIEW
- **sync-riper-to-todos**: Parses RIPER plans and creates TodoLists
  - *Note: Works alongside Task Master MCP (no conflicts)*
  - Automatically triggers when you say "реализуй" or "implement"
  - Displays steps as checklist for quick reference

### 4. Quality Gates (#5)
- **pre-commit hooks**: Validates RIPER workflow compliance before commits
- **post-commit hooks**: Logs decisions and progress to Memory Bank
- Ensures code quality and documentation

## 📦 Installation

### Quick Start

\`\`\`bash
# Clone the repository
git clone https://github.com/DenVorobev/claude-riper-automation.git
cd claude-riper-automation

# Run installation
./install/install.sh

# Verify installation
./install/verify.sh
\`\`\`

### Manual Installation

See [INSTALLATION.md](docs/INSTALLATION.md) for detailed instructions.

## 🚀 Usage

### For New Complex Tasks

\`\`\`
1. User describes complex task
   ↓
2. smart-riper-hint suggests RIPER
   ↓
3. User runs /riper:workflow
   ↓
4. RESEARCH → (auto-trigger) → INNOVATE → PLAN → (auto-todos) → EXECUTE → (auto-reminder) → REVIEW
   ↓
5. Important decisions auto-saved to Memory Bank
   ↓
6. Pre-commit validation ensures quality
   ↓
7. Post-commit logs everything
\`\`\`

## 📁 Directory Structure

\`\`\`
bin/
├── smart-riper-hint          # Task complexity analyzer
├── auto-memory-save          # Auto-save to Memory Bank
├── auto-trigger-innovate     # RESEARCH→INNOVATE trigger
├── auto-review-reminder      # EXECUTE→REVIEW reminder
├── sync-riper-to-todos       # Plan→TodoList synchronizer
├── parse-riper-plan          # Helper: Plan parser
├── validate-riper-workflow   # Helper: Workflow validator
└── setup-hooks.sh            # Setup all hooks

hooks/
├── pre-commit                # Pre-commit validation
├── post-commit               # Post-commit logging
└── prepare-commit-msg        # Commit message templates

config/
├── settings-template.json    # Template for .claude/settings.json
└── hooks-config.json         # Hook configuration

install/
├── install.sh                # Install system
├── uninstall.sh              # Remove system
├── update.sh                 # Update scripts
└── verify.sh                 # Verify installation

docs/
├── README.md                 # This file
├── INSTALLATION.md           # Installation guide
├── USAGE.md                  # Detailed usage
└── TROUBLESHOOTING.md        # Common issues

VERSION                        # Version file
LICENSE                        # MIT License
\`\`\`

## 🔧 Configuration

System automatically configures:
- \`.claude/settings.json\` - Adds hooks for SessionStart, UserPromptSubmit
- \`.git/hooks/\` - Adds pre-commit and post-commit validation
- No manual configuration needed after installation!

## 📖 Documentation

- [Installation Guide](docs/INSTALLATION.md) - Step-by-step setup
- [Usage Guide](docs/USAGE.md) - How to use each feature
- [Troubleshooting](docs/TROUBLESHOOTING.md) - Common issues and solutions

## 🎯 Benefits

✅ **Never lose important decisions** - Auto-saved to Memory Bank
✅ **Smooth workflow transitions** - Automatic reminders and triggers
✅ **Better task tracking** - Plans become actionable todos
✅ **Quality assurance** - Git hooks prevent incomplete work
✅ **Repeatable processes** - RIPER workflow enforced
✅ **Works everywhere** - Same system in all your projects

## 📝 License

MIT License - See [LICENSE](LICENSE) file

---

**Version:** 0.1.0
**Author:** Claude Code + DenVorobev
**Status:** Active Development