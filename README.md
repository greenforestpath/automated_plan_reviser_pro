# Automated Plan Reviser Pro (apr)

<div align="center">
  <img src="apr_illustration.webp" alt="Automated Plan Reviser Pro - Iterative specification refinement with AI">
</div>

<div align="center">

[![Version](https://img.shields.io/badge/version-1.1.0-blue?style=for-the-badge)](https://github.com/Dicklesworthstone/automated_plan_reviser_pro/releases)
[![Platform](https://img.shields.io/badge/platform-macOS%20%7C%20Linux-blueviolet?style=for-the-badge)](https://github.com/Dicklesworthstone/automated_plan_reviser_pro)
[![Runtime](https://img.shields.io/badge/runtime-Bash%204+-purple?style=for-the-badge)](https://github.com/Dicklesworthstone/automated_plan_reviser_pro)
[![License: MIT](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](https://opensource.org/licenses/MIT)

</div>

Iterative specification refinement with GPT Pro Extended Reasoning via Oracle. The missing link between your specification documents and production-ready designs.

<div align="center">
<h3>Quick Install</h3>

```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/automated_plan_reviser_pro/main/install.sh?$(date +%s)" | bash
```

<p><em>Works on Linux and macOS. Auto-installs to ~/.local/bin with PATH detection.</em></p>
</div>

---

## TL;DR

**The Problem**: Complex specifications—especially security-sensitive protocols—need multiple rounds of review. A single pass by even the best AI misses architectural issues, edge cases, and subtle flaws. Manually running 15-20 review cycles is tedious and error-prone.

**The Solution**: apr automates iterative specification refinement using GPT Pro 5.2 Extended Reasoning via [Oracle](https://github.com/steipete/oracle). Each round builds on the last, converging toward optimal architecture like a numerical optimizer.

### Why Use apr?

| Feature | What It Does |
|---------|--------------|
| **One-Command Iterations** | `apr run 5` kicks off round 5—no manual copy-paste |
| **Document Bundling** | Automatically combines README, spec, and implementation docs |
| **Background Processing** | 10-60 minute reviews run in background with notifications |
| **Session Management** | Attach/detach from running sessions, check status anytime |
| **Round History** | All outputs saved to `.apr/rounds/` with git integration |
| **Beautiful TUI** | Gum-powered interface with graceful ANSI fallback |
| **Robot Mode** | JSON API for coding agents (`apr robot run 5`) |

### Quick Example

```bash
# Set up your workflow once
$ apr setup
# → Interactive wizard: select README, spec, and implementation files

# Run iterative reviews
$ apr run 1 --login --wait    # First time: manual ChatGPT login
$ apr run 2                    # Background execution
$ apr run 3 --include-impl     # Include implementation every few rounds

# Monitor progress
$ apr status                   # Check all sessions
$ apr attach apr-default-round-3   # Attach to specific session
```

### The Convergence Pattern

```
Round 1-3:   Major architectural fixes, security gaps identified
Round 4-7:   Architecture refinements, interface improvements
Round 8-12:  Nuanced optimizations, edge case handling
Round 13+:   Polishing abstractions, converging on steady state
```

Each round, GPT Pro focuses on finer details because major issues were already addressed—like gradient descent settling into a minimum.

---

## The Core Insight: Iterative Convergence

When you're designing a complex protocol specification, especially when security is involved, just one iteration of review by GPT Pro 5.2 with Extended Reasoning doesn't cut it.

**APR automates the multi-round revision workflow:**

```
┌─────────────────┐     ┌─────────────────┐     ┌─────────────────┐
│   Round 1       │────▶│   Round 2       │────▶│   Round 3       │────▶ ...
│   Major fixes   │     │  Architecture   │     │  Refinements    │
│   Security gaps │     │  improvements   │     │  Optimizations  │
└─────────────────┘     └─────────────────┘     └─────────────────┘
        │                       │                       │
        ▼                       ▼                       ▼
   Wild swings            Dampening              Converging
   in design              oscillations           on optimal
```

**It very much reminds me of a numerical optimizer gradually converging on a steady state after wild swings in the initial iterations.**

With each round, the specification becomes "less wrong." Not only is this a good thing because the protocol improves, but it also means that in the next round of review, GPT Pro can focus its considerable intellectual energies on the nuanced particulars and in finding just the right abstractions and interfaces because it doesn't need to put out fires in terms of outright mistakes or security problems that preoccupy it in earlier rounds.

---

## Table of Contents

- [The Core Insight](#the-core-insight-iterative-convergence)
- [Why APR Exists](#-why-apr-exists)
- [Highlights](#-highlights)
- [Quickstart](#-quickstart)
- [Usage](#-usage)
  - [Commands](#commands)
  - [Options](#options)
- [The Workflow](#-the-workflow)
- [Interactive Setup](#-interactive-setup)
- [Session Monitoring](#-session-monitoring)
- [The Inspiration](#-the-inspiration-flywheel-connector-protocol)
- [Design Principles](#-design-principles)
- [Architecture](#-architecture)
- [Terminal Styling](#-terminal-styling)
- [Dependencies](#-dependencies)
- [Environment Variables](#-environment-variables)
- [Troubleshooting](#-troubleshooting)
- [Contributing](#-contributing)
- [License](#-license)

---

## 💡 Why APR Exists

Specification review is an iterative process, not a single pass:

| Problem | Why It's Hard | How APR Solves It |
|---------|---------------|-------------------|
| **Context loss** | Each new GPT session starts fresh | Structured prompts carry full context |
| **Manual bundling** | Copying README + spec + impl is tedious | Automatic document bundling |
| **No tracking** | Easy to lose track of which round you're on | Round history with git integration |
| **Slow feedback loop** | Extended reasoning takes 10-60 minutes | Background execution with monitoring |
| **Authentication friction** | ChatGPT login expires, cookies fail | Manual login mode with persistent profile |
| **Integration gaps** | GPT output sits in a chat window | Saved to files for Claude Code integration |

APR lets you set up a workflow once, then iterate with a single command per round.

---

## ✨ Highlights

<table>
<tr>
<td width="50%">

### Beautiful Terminal UI
Powered by [gum](https://github.com/charmbracelet/gum):
- Styled banners and headers
- Interactive file picker
- Confirmation dialogs
- Graceful ANSI fallback

</td>
<td width="50%">

### Interactive Setup Wizard
Configure your workflow once:
- Select README, spec, implementation files
- Choose GPT model and reasoning level
- Automatic round output management
- Multiple workflow support

</td>
</tr>
<tr>
<td width="50%">

### Session Management
Never lose a review:
- Background execution with PID tracking
- Session status checking
- Reattachment to running sessions
- Desktop notifications on completion

</td>
<td width="50%">

### Round Tracking
Full revision history:
- Numbered round outputs
- Git-integrated workflow
- History command for review
- Multiple workflow support

</td>
</tr>
</table>

---

## ⚡ Quickstart

### Installation

**One-liner (recommended):**
```bash
curl -fsSL "https://raw.githubusercontent.com/Dicklesworthstone/automated_plan_reviser_pro/main/install.sh" | bash
```

<details>
<summary><strong>Manual installation</strong></summary>

```bash
# Download script
curl -fsSL https://raw.githubusercontent.com/Dicklesworthstone/automated_plan_reviser_pro/main/apr -o ~/.local/bin/apr
chmod +x ~/.local/bin/apr

# Ensure ~/.local/bin is in PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc  # or ~/.bashrc
source ~/.zshrc

# Install Oracle (required)
npm install -g @steipete/oracle
```

</details>

### First Run

```bash
# 1. Run the setup wizard
apr setup

# 2. First round with manual login (required first time)
apr run 1 --login --wait

# 3. Subsequent rounds
apr run 2
apr run 3 --include-impl  # Include implementation doc every few rounds
```

---

## 🚀 Usage

```
apr [command] [options]
```

### Commands

| Command | Description |
|---------|-------------|
| `run <round>` | Run a revision round (default if number given) |
| `setup` | Interactive workflow setup wizard |
| `status` | Check Oracle session status |
| `attach <session>` | Attach to a running/completed session |
| `list` | List all configured workflows |
| `history` | Show revision history for current workflow |
| `update` | Check for and install updates |
| `robot <cmd>` | Machine-friendly JSON interface for coding agents |
| `help` | Show help message |

### Options

| Flag | Description |
|------|-------------|
| `-w, --workflow NAME` | Workflow to use (default: from config) |
| `-i, --include-impl` | Include implementation document |
| `-d, --dry-run` | Preview without sending to GPT Pro |
| `-r, --render` | Render bundle for manual paste |
| `-c, --copy` | Copy rendered bundle to clipboard |
| `--wait` | Wait for completion (blocking) |
| `--login` | Manual login mode (first-time setup) |
| `--keep-browser` | Keep browser open after completion |
| `-q, --quiet` | Minimal output (errors only) |
| `--version` | Show version |

### Examples

```bash
# First-time setup
apr setup

# Run revision round 1 (first time requires --login)
apr run 1 --login --wait

# Run round 2 in background
apr run 2

# Run round 3 with implementation doc
apr run 3 --include-impl

# Check session status
apr status

# Attach to a running session
apr attach apr-default-round-3

# Preview what will be sent
apr run 4 --dry-run

# Render for manual paste into ChatGPT
apr run 4 --render --copy

# Use a different workflow
apr run 1 -w my-other-project
```

---

## 🔄 The Workflow

APR automates this workflow:

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                        APR REVISION WORKFLOW                                  │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                              │
│  ┌─────────────┐     ┌──────────────────────────────────────────────────┐   │
│  │   START     │────▶│  1. BUNDLE: Collect docs for GPT Pro review      │   │
│  │  Round N    │     │     - README (project overview)                  │   │
│  └─────────────┘     │     - Specification (the design)                 │   │
│                      │     - Implementation (optional, every 3-4 rounds)│   │
│                      └──────────────────────────────────────────────────┘   │
│                                          │                                   │
│                                          ▼                                   │
│                      ┌──────────────────────────────────────────────────┐   │
│                      │  2. ORACLE: Send to GPT Pro 5.2 Extended         │   │
│                      │     - Browser automation mode                    │   │
│                      │     - 10-60 minute processing time               │   │
│                      │     - Desktop notification on completion         │   │
│                      └──────────────────────────────────────────────────┘   │
│                                          │                                   │
│                                          ▼                                   │
│                      ┌──────────────────────────────────────────────────┐   │
│                      │  3. CAPTURE: Save GPT Pro output                 │   │
│                      │     → .apr/rounds/<workflow>/round_N.md          │   │
│                      └──────────────────────────────────────────────────┘   │
│                                          │                                   │
│                                          ▼                                   │
│                      ┌──────────────────────────────────────────────────┐   │
│                      │  4. INTEGRATE: (Manual) Paste into Claude Code   │   │
│                      │     - Prime CC with AGENTS.md, README, spec      │   │
│                      │     - Apply revisions to specification           │   │
│                      │     - Update README to match                     │   │
│                      │     - Harmonize implementation doc               │   │
│                      └──────────────────────────────────────────────────┘   │
│                                          │                                   │
│                                          ▼                                   │
│                      ┌──────────────────────────────────────────────────┐   │
│                      │  5. COMMIT: Push to git                          │   │
│                      │     - Logical commit groupings                   │   │
│                      │     - Detailed commit messages                   │   │
│                      │     - Audit trail in git history                 │   │
│                      └──────────────────────────────────────────────────┘   │
│                                          │                                   │
│                                          ▼                                   │
│                      ┌─────────────┐                                        │
│                      │    READY    │  → Start Round N+1                     │
│                      │  for next   │                                        │
│                      └─────────────┘                                        │
│                                                                              │
└─────────────────────────────────────────────────────────────────────────────┘
```

### Why Include Implementation Every Few Rounds?

You might object that it's pointless to update the README and implementation document if we know already that we are going to make many more revisions to the specification document. But when you start thinking of each round of iteration as a sort of perturbation in an optimization process, you want these changes mirrored in the implementation as you go.

**This reduces the shock of trying to apply N revisions all at once and helps to surface problems better.** After all, when you start turning ideas into code, the faulty assumptions get surfaced earlier and can feed back into your specification revisions.

---

## 🧙 Interactive Setup

Run `apr setup` to launch the interactive wizard:

```
╔════════════════════════════════════════════════════════════╗
║    Automated Plan Reviser Pro v1.1.0                       ║
║    Iterative AI-Powered Spec Refinement                    ║
╚════════════════════════════════════════════════════════════╝

╭────────────────────────────────────────────────────────────╮
│  Welcome to the APR Setup Wizard!                          │
│                                                            │
│  This will help you configure a new revision workflow.     │
│  You'll specify your documents and review preferences.     │
╰────────────────────────────────────────────────────────────╯

[1/6] Workflow name
Workflow name: fcp-spec

[2/6] Project description
Brief description: Flywheel Connector Protocol specification

[3/6] README/Overview document
Select README file: README.md
✓ README: README.md

[4/6] Specification document
Select specification file: FCP_Specification_V2.md
✓ Specification: FCP_Specification_V2.md

[5/6] Implementation document (optional)
Do you have an implementation/reference document? [y/N] y
Select implementation file: docs/fcp_model_connectors_rust.md
✓ Implementation: docs/fcp_model_connectors_rust.md

[6/6] Review preferences
Select GPT model for reviews:
  > 5.2 Thinking (Extended Reasoning)
    gpt-5.2-pro
    gpt-5.2

╭────────────────────────────────────────────────────────────╮
│  ✓ Workflow 'fcp-spec' created successfully!               │
│                                                            │
│  To run your first revision round:                         │
│    apr run 1                                               │
│                                                            │
│  To run with implementation doc:                           │
│    apr run 1 --include-impl                                │
╰────────────────────────────────────────────────────────────╯
```

---

## 📡 Session Monitoring

APR provides multiple ways to monitor long-running reviews:

### Check All Sessions
```bash
apr status
```

### Attach to a Specific Session
```bash
apr attach apr-fcp-spec-round-5
```

### Oracle Direct Commands
```bash
# Check status
npx -y @steipete/oracle status --hours 24

# Attach with rendered output
npx -y @steipete/oracle session apr-fcp-spec-round-5 --render
```

### Desktop Notifications
APR automatically enables desktop notifications (via Oracle's `--notify` flag) so you'll be alerted when a review completes.

---

## 📖 The Inspiration: Flywheel Connector Protocol

APR was built to automate the workflow used to develop the [Flywheel Connector Protocol](https://github.com/Dicklesworthstone/flywheel_connectors):

> The goal is to have security and isolation built in at the protocol level, and also extreme performance and reliability, with everything done in Rust in a uniform manner that conforms to the protocol specification.

### The Original Manual Workflow

This is the process APR automates:

#### Step 1: Send to GPT Pro 5.2 Extended Reasoning

```markdown
First, read this README:

\`\`\`
<paste contents of readme file>
\`\`\`

---

NOW: Carefully review this entire plan for me and come up with your best
revisions in terms of better architecture, new features, changed features,
etc. to make it better, more robust/reliable, more performant, more
compelling/useful, etc.

For each proposed change, give me your detailed analysis and
rationale/justification for why it would make the project better along
with the git-diff style change versus the original plan shown below:

\`\`\`
<paste contents of spec document>
\`\`\`
```

#### Step 2: Prime Claude Code

```
First read ALL of the AGENTS.md file and README.md file super carefully
and understand ALL of both! Then use your code investigation agent mode
to fully understand the code, and technical architecture and purpose of
the project. Read ALL of the V2 spec doc and the connector doc.
```

#### Step 3: Integrate Feedback

```
Now integrate all of this feedback (and let me know what you think of it,
whether you agree with each thing and how much) from gpt 5.2:
\`\`\`[Pasted GPT output]\`\`\`
Be meticulous and use ultrathink.
```

#### Step 4: Update README

```
We need to revise the README too for these changes (don't write about
these as "changes" however, make it read like it was always like that,
we don't have any users yet!) Use ultrathink.
```

#### Step 5: Harmonize Implementation

```
Now review docs/fcp_model_connectors_rust.md ultra carefully and ensure
it is 100% harmonized with the V2 spec and as optimized as possible
subject to those constraints.
```

#### Step 6: Commit and Push

```
Now, based on your knowledge of the project, commit all changed files
now in a series of logically connected groupings with super detailed
commit messages for each and then push. Take your time to do it right.
```

### Extended Template (Every 3-4 Rounds)

Once every few review sessions, include the implementation document:

```markdown
First, read this README:
\`\`\`<readme>\`\`\`

---

And here is a document detailing Rust implementations for the canonical
connector types that follow the specification document given below; you
should also keep the implementation in mind as you think about the
specification, since ultimately the specification needs to be translated
into the Rust code eventually!

\`\`\`<implementation>\`\`\`

---

NOW: Carefully review this entire plan...
\`\`\`<spec>\`\`\`
```

---

## 🧭 Design Principles

### 1. Iterative Convergence

Like numerical optimization, specification design converges over multiple iterations:
- Early rounds fix major issues (security gaps, architectural flaws)
- Middle rounds refine architecture
- Later rounds polish abstractions and interfaces

### 2. Grounded Abstraction

Every few rounds, including the implementation document keeps abstract specifications grounded in concrete reality. Faulty assumptions surface earlier when ideas meet code.

### 3. Audit Trail

Every round creates artifacts:
- GPT Pro output saved to `.apr/rounds/`
- Git commits capture evolution
- Both abstract "specification space" and concrete "implementation space" are tracked

### 4. Graceful Degradation

Everything has fallbacks:
- gum → ANSI colors
- Oracle global → npx
- Interactive → CLI flags

---

## 🏗️ Architecture

### Component Overview

```
apr (bash script, ~1700 LOC)
├── Gum integration (beautiful TUI)
├── Oracle detection (global or npx)
├── Interactive setup wizard
├── Round execution
├── Session monitoring
└── History tracking

.apr/ (per-project configuration)
├── config.yaml           # Global settings
├── workflows/            # Workflow definitions
│   └── <name>.yaml
└── rounds/               # Round outputs
    └── <workflow>/
        └── round_N.md
```

### File Locations

| Path | Purpose |
|------|---------|
| `~/.local/bin/apr` | Main script (default install) |
| `.apr/` | Per-project configuration directory |
| `.apr/config.yaml` | Global APR config for this project |
| `.apr/workflows/*.yaml` | Workflow definitions |
| `.apr/rounds/<workflow>/` | GPT Pro outputs per round |

---

## 🎨 Terminal Styling

APR uses [gum](https://github.com/charmbracelet/gum) for beautiful terminal output:

```
╔════════════════════════════════════════════════════════════╗
║    Automated Plan Reviser Pro v1.1.0                       ║
║    Iterative AI-Powered Spec Refinement                    ║
╚════════════════════════════════════════════════════════════╝

╭────────────────────────────────────────────────────────────╮
│  REVISION ROUND 5                                          │
│                                                            │
│  Workflow:     fcp-spec                                    │
│  Model:        5.2 Thinking                                │
│  Include impl: true                                        │
│  Output:       .apr/rounds/fcp-spec/round_5.md             │
╰────────────────────────────────────────────────────────────╯

✓ Oracle running in background (PID: 12345)

╭────────────────────────────────────────────────────────────╮
│  MONITORING COMMANDS                                       │
├────────────────────────────────────────────────────────────┤
│  Check status:      apr status                             │
│  Attach to session: apr attach apr-fcp-spec-round-5        │
╰────────────────────────────────────────────────────────────╯
```

### Styling Behavior

| Environment | Output Style |
|-------------|--------------|
| TTY with gum installed | Full gum styling |
| TTY without gum | ANSI color codes |
| Non-TTY (piped) | Plain text |
| CI environment (`$CI` set) | Plain text |
| `APR_NO_GUM=1` | Force ANSI fallback |

---

## 📦 Dependencies

### Required

| Package | Purpose |
|---------|---------|
| Bash 4+ | Script runtime |
| Oracle | GPT Pro browser automation |
| Node.js 18+ | Oracle runtime |
| curl or wget | Installation |

### Optional

| Package | Purpose |
|---------|---------|
| gum | Beautiful terminal UI |

### Install Dependencies

```bash
# Node.js (if not installed)
# macOS
brew install node

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs

# Oracle
npm install -g @steipete/oracle

# gum (optional, for beautiful UI)
# macOS
brew install gum

# Linux
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
sudo apt update && sudo apt install gum
```

---

## 🌐 Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `APR_HOME` | Data directory | `~/.local/share/apr` |
| `APR_CACHE` | Cache directory | `~/.cache/apr` |
| `APR_CHECK_UPDATES` | Enable daily update checking | unset (set to `1` to enable) |
| `APR_NO_GUM` | Disable gum even if available | unset |
| `NO_COLOR` | Disable colored output (accessibility) | unset |
| `CI` | Detected CI environment (disables gum) | unset |

---

## 🧭 Troubleshooting

### Common Issues

<details>
<summary><strong>Oracle not found</strong></summary>

**Cause:** Node.js or Oracle not installed.

**Fix:**
```bash
# Install Node.js first, then:
npm install -g @steipete/oracle

# Or use npx (works without global install)
npx -y @steipete/oracle --version
```

</details>

<details>
<summary><strong>Browser doesn't open / cookies expired</strong></summary>

**Cause:** First run requires manual login, or session expired.

**Fix:**
```bash
apr run 1 --login --wait
# Browser opens - log into ChatGPT
# Session saved for future runs
```

</details>

<details>
<summary><strong>Session timeout</strong></summary>

**Cause:** Extended reasoning took longer than expected.

**Fix:**
```bash
# Don't re-run! Reattach to the session
apr attach apr-default-round-5

# Or use Oracle directly
npx -y @steipete/oracle session apr-default-round-5 --render
```

</details>

<details>
<summary><strong>Workflow not found</strong></summary>

**Cause:** No `.apr/` directory or workflow not set up.

**Fix:**
```bash
apr setup  # Run the setup wizard
```

</details>

---

## 🤝 Contributing

> *About Contributions:* I do not accept outside contributions for any of my projects. I simply don't have the mental bandwidth to review anything. Feel free to submit issues, and even PRs if you want to illustrate a proposed fix, but know I won't merge them directly. Bug reports in particular are welcome.

---

## 📄 License

MIT License. See [LICENSE](LICENSE) for details.

---

<div align="center">

**[Report Bug](https://github.com/Dicklesworthstone/automated_plan_reviser_pro/issues) · [Request Feature](https://github.com/Dicklesworthstone/automated_plan_reviser_pro/issues)**

---

<sub>Built with Oracle, gum, and a healthy appreciation for iterative refinement.</sub>

</div>
