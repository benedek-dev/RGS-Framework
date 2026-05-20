# Ruflo Game Studio (RGS) Framework

A unified swarm-based AI game development framework that merges **Ruflo** (multi-agent
orchestration engine) with **Claude-Code-Game-Studios** (49-agent game studio hierarchy
and 73-skill workflow system) into a single operational environment.

---

## What RGS Is

RGS gives you a complete AI-powered game studio that can:

- **Orchestrate multi-agent swarms** across game development domains using Ruflo's hierarchical topology
- **Deploy 44 specialized agents** covering every discipline from creative direction to UE5-specific programming
- **Execute 73 workflow skills** covering the full game dev lifecycle from concept through release
- **Route tasks automatically** — the master orchestrator dispatches work to the right specialist at the right model tier
- **Coordinate in real-time** via SendMessage pipeline between named agents

---

## Architecture Overview

```
RGS/
├── CLAUDE.md                    ← Master config: routing rules, protocols, behavior
├── .claude/
│   ├── agents/                  ← All 54 agent definitions
│   │   ├── rgs-orchestrator.md  ← NEW: Master routing agent (Opus)
│   │   ├── creative-director.md ← CCGS leadership tier
│   │   ├── technical-director.md
│   │   ├── producer.md
│   │   ├── [40 more specialists] ← UE5-focused agent hierarchy
│   │   └── core/                ← Ruflo meta-agents
│   │       ├── planner.md       ← Task decomposition
│   │       ├── coder.md         ← Implementation
│   │       ├── researcher.md    ← Investigation
│   │       ├── reviewer.md      ← Quality review
│   │       └── tester.md        ← Verification
│   ├── skills/                  ← 73 workflow skill scripts (CCGS)
│   │   ├── brainstorm/SKILL.md
│   │   ├── design-system/SKILL.md
│   │   ├── dev-story/SKILL.md
│   │   └── [70 more skills]
│   ├── docs/                    ← Coordination docs, templates, catalog
│   │   ├── agent-roster.md      ← Full agent list with model tiers
│   │   ├── workflow-catalog.yaml← Phase-gated skill catalog
│   │   ├── coordination-rules.md
│   │   └── templates/           ← 25+ game dev document templates
│   ├── hooks/                   ← 12 lifecycle hooks (session, validate, notify)
│   ├── rules/                   ← 11 domain-specific coding rules
│   └── settings.json            ← Model tier routing + swarm config + hook wiring
├── .agents/
│   ├── config.toml              ← Ruflo swarm: hierarchical, raft consensus, SONA
│   └── skills/                  ← 8 Ruflo automation skills
│       ├── swarm-orchestration/ ← Swarm launcher + monitor scripts
│       ├── hive-mind/           ← Queen-led Byzantine consensus
│       ├── hive-mind-advanced/
│       ├── sparc-methodology/   ← SPARC dev loop with scripts
│       ├── memory-management/   ← Backup + consolidation scripts
│       ├── security-audit/      ← CVE scan scripts
│       ├── swarm-advanced/      ← Advanced coordination patterns
│       └── agent-swarm/         ← Swarm primitives
└── docs/
    └── engine-reference/        ← UE5 API reference (add version-pinned docs here)
```

---

## Agent System

### 44 Total Agents (UE5-exclusive)

| Layer | Count | Purpose |
|-------|-------|---------|
| RGS Orchestrator | 1 | Master routing and swarm coordination |
| Ruflo Meta-Agents | 5 | Process coordination (planner/coder/researcher/reviewer/tester) |
| Leadership | 3 | Strategic decisions (creative-director, technical-director, producer) |
| Dept. Leads | 8 | Domain authority (game-designer, lead-programmer, art-director, ...) |
| General Specialists | 22 | Implementation (gameplay-prog, engine-prog, sound-designer, ...) |
| UE5 Engine Specialists | 5 | unreal-specialist + ue-gas, ue-blueprint, ue-replication, ue-umg |

### Model Tier Routing

| Model | Agents | Use Case |
|-------|--------|----------|
| **Opus** | rgs-orchestrator, creative-director, technical-director, producer | Leadership, synthesis, high-stakes |
| **Sonnet** | All 39 department leads + UE5 specialists + meta-agents | Implementation, design, analysis |
| **Haiku** | qa-tester, devops-engineer, accessibility-specialist, community-manager | Status checks, formatting, simple lookups |

---

## Workflow System

73 skills covering 6 development phases:

```
Concept → Systems Design → Technical Setup → Pre-Production → Production → Release
```

### How to Use Skills

Skills are invoked as slash commands in Claude Code:

```bash
/start              # Guided first-session onboarding
/brainstorm         # Ideate game concept with MDA frameworks
/setup-engine       # Configure and pin engine + language
/map-systems        # Decompose concept into game systems
/design-system      # Author a GDD for one system
/create-epics       # Translate GDDs into epics
/dev-story          # Pick and implement a story
/team-combat        # Orchestrate multi-agent combat feature team
/sprint-status      # Quick 30-line progress snapshot
/gate-check         # Validate readiness for next phase
/release-checklist  # Pre-launch validation across all departments
```

---

## Swarm Engine (Ruflo)

### Configuration (`.agents/config.toml`)

```toml
[swarm]
default_topology  = "hierarchical"   # Prevents drift
default_strategy  = "specialized"    # Clear role boundaries
consensus         = "raft"           # Leader-maintained state
anti_drift        = true
max_agents        = 8
```

### Spawn Pattern

All agents must be spawned in **one message** with `run_in_background: true`, then coordinated via `SendMessage`:

```javascript
// Spawn full feature team in ONE message
Task({ name: "designer",  subagent_type: "game-designer",      run_in_background: true,
       prompt: "Design [feature]. SendMessage to 'architect' when done." })
Task({ name: "architect", subagent_type: "lead-programmer",     run_in_background: true,
       prompt: "Wait for design. Architect code. SendMessage to 'coder'." })
Task({ name: "coder",     subagent_type: "gameplay-programmer", run_in_background: true,
       prompt: "Wait for arch. Implement. SendMessage to 'qa'." })
Task({ name: "qa",        subagent_type: "qa-tester",           run_in_background: true,
       prompt: "Wait for code. Write tests. Report." })

// Kick off the pipeline
SendMessage({ to: "designer", message: "[full feature context]" })
```

### Available Topologies

| Topology | Use Case |
|----------|----------|
| `hierarchical` | Default — tight coordination, anti-drift |
| `pipeline` | Sequential A→B→C workflows |
| `fan-out` | Parallel independent research |
| `hive-mind` | Byzantine fault-tolerant consensus (critical decisions) |

---

## Hook System

12 lifecycle hooks in `.claude/hooks/`:

| Hook | Trigger | Purpose |
|------|---------|---------|
| `session-start.sh` | Session begins | Preview active state, context recovery |
| `session-stop.sh` | Session ends | Persist state, metrics export |
| `pre-compact.sh` | Before context compact | Save active state to file |
| `post-compact.sh` | After compact | Reload essential context |
| `log-agent.sh` | Agent spawned | Audit trail |
| `log-agent-stop.sh` | Agent stopped | Completion logging |
| `validate-commit.sh` | Pre-commit | Code quality gate |
| `validate-push.sh` | Pre-push | Test gate |
| `validate-assets.sh` | Asset changes | Naming/format check |
| `validate-skill-change.sh` | Skill file modified | Skill integrity check |
| `notify.sh` | Notable events | Desktop notification |
| `detect-gaps.sh` | Analysis | Story/design gap detection |

---

## Getting Started

### 1. Prerequisites

- Claude Code CLI installed
- Git
- Node.js 20+ (for Ruflo MCP tools, optional)

### 2. First Session

Open this directory in Claude Code and run:

```bash
/start
```

This launches the guided onboarding: engine selection, game concept, team configuration.

### 3. Configure Engine

```bash
/setup-engine
# Select: Godot 4 / Unity / Unreal Engine 5
# RGS automatically activates the matching engine specialist agents
```

### 4. Start Your Game

```bash
/brainstorm            # Develop game concept
/map-systems           # Decompose into systems
/design-system         # Author GDDs
/create-architecture   # Technical architecture
/create-epics          # Break into epics
/sprint-plan           # First sprint
/dev-story             # Start implementing
```

### 5. Multi-Agent Features

Invoke the RGS orchestrator for complex multi-domain work:

```
Use the rgs-orchestrator agent to coordinate my combat system — 
I need design, implementation, and QA all in one pass.
```

---

## Design Principles

1. **Domain separation** — Each agent owns its domain. No agent modifies files outside its domain without explicit delegation.
2. **Vertical delegation** — Tasks flow downward through the hierarchy. Directors delegate to leads, leads to specialists.
3. **Anti-drift** — Hierarchical topology + raft consensus + max 8 agents prevents swarm divergence.
4. **File-backed state** — Conversations are ephemeral. The file is the memory. All decisions written to disk.
5. **Collaborative protocol** — Agents show drafts and ask before writing. No unilateral file changes.
6. **Verification-driven** — Every implementation has a way to prove it works before marking done.

---

## Source Attribution

RGS merges two open-source frameworks:

- **Ruflo** (ruvnet) — Swarm orchestration engine, multi-agent coordination, SPARC methodology
- **Claude-Code-Game-Studios** (Donchitos) — 49-agent game studio hierarchy, 73 workflow skills, game dev templates

Both are merged without modification to source content; only routing, configuration, and orchestration are added by RGS.
