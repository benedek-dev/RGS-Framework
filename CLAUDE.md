# Ruflo Game Studio (RGS) — Master Configuration

> **RGS v1.0** — A unified swarm-based game development framework merging Ruflo's
> orchestration engine with Claude-Code-Game-Studios' 49-agent hierarchy and 73-skill
> workflow system. Multi-agent, multi-tier, anti-drift by design.

---

## Quick Start

```bash
# First session — onboard and configure your project
/start           # Guided project setup (engine, concept, team)
/setup-engine    # Pin engine version, set naming conventions

# Check current state
/sprint-status   # Quick 30-line progress snapshot
/help            # Full workflow catalog with completion status
```

---

## Architecture

RGS operates as a **three-layer system**:

```
┌─────────────────────────────────────────────────────┐
│  LAYER 1: RGS Meta-Orchestrator                      │
│  rgs-orchestrator (Opus) — routes, coordinates       │
├─────────────────────────────────────────────────────┤
│  LAYER 2: Ruflo Core Agents (process coordination)   │
│  planner · coder · researcher · reviewer · tester    │
├─────────────────────────────────────────────────────┤
│  LAYER 3: CCGS Domain Expert Agents (49 agents)      │
│  Directors → Leads → Specialists → Engine Experts    │
└─────────────────────────────────────────────────────┘
```

---

## Behavioral Rules (Always Enforced)

- Do what has been asked; nothing more, nothing less
- NEVER create files unless absolutely necessary for the goal
- ALWAYS prefer editing an existing file to creating a new one
- NEVER proactively create documentation files (*.md) or README files unless explicitly requested
- ALWAYS read a file before editing it
- NEVER commit secrets, credentials, or .env files
- Agents MUST ask "May I write this to [filepath]?" before using Write/Edit tools
- Agents MUST show drafts before requesting approval
- No commits without explicit user instruction

---

## Technology Stack

- **Engine**: Unreal Engine 5 (exclusive)
- **Languages**: C++ and Blueprint
- **Version Control**: Git with trunk-based development
- **Build System**: UnrealBuildTool (UBT)
- **Asset Pipeline**: UE5 Content Browser + Derived Data Cache

> Run `/setup-engine` to pin your UE5 version and configure naming conventions.

---

## Agent Hierarchy

### Tier 1 — Leadership (Opus)
| Agent | Domain | When to Use |
|-------|--------|-------------|
| `rgs-orchestrator` | Master routing | Multi-domain tasks, session start, unknown routing |
| `creative-director` | Creative vision | Pillar conflicts, tone, major creative decisions |
| `technical-director` | Technical vision | Architecture, tech stack, performance strategy |
| `producer` | Production | Sprint planning, milestones, risk management |

### Tier 2 — Department Leads (Sonnet)
| Agent | Domain |
|-------|--------|
| `game-designer` | Mechanics, systems, economy, balancing |
| `lead-programmer` | Code architecture, API design, code review |
| `art-director` | Visual direction, art bible, asset standards |
| `audio-director` | Music direction, audio implementation strategy |
| `narrative-director` | Story arcs, world-building, dialogue strategy |
| `qa-lead` | Test strategy, bug triage, release readiness |
| `release-manager` | Build management, versioning, deployment |
| `localization-lead` | I18n, translation pipeline, locale testing |

### Tier 0 — Ruflo Meta-Agents (Process, Sonnet)
| Agent | Role |
|-------|------|
| `planner` | YAML task decomposition, dependency mapping |
| `coder` | Implementation (when not routed to specialist) |
| `researcher` | Investigation, codebase analysis |
| `reviewer` | Quality review, security |
| `tester` | Test writing and verification |

### Tier 3 — UE5 Specialists
| Agent | Subsystem | When to Use |
|-------|-----------|-------------|
| `unreal-specialist` | General UE5 | Blueprint vs C++, subsystems, project-wide UE optimization |
| `ue-gas-specialist` | Gameplay Ability System | Abilities, effects, attribute sets, tags, prediction |
| `ue-blueprint-specialist` | Blueprint Architecture | BP/C++ boundary, graph standards, BP optimization |
| `ue-replication-specialist` | Networking/Replication | Property replication, RPCs, prediction, bandwidth |
| `ue-umg-specialist` | UMG/CommonUI | Widget hierarchy, data binding, CommonUI input, UI perf |

See `.claude/docs/agent-roster.md` for the full agent list with model assignments.

---

## Workflow Phases & Skills

RGS implements a 6-phase game development lifecycle with 73 workflow skills:

| Phase | Key Skills |
|-------|-----------|
| **Concept** | `/brainstorm`, `/setup-engine`, `/art-bible`, `/map-systems` |
| **Systems Design** | `/design-system`, `/design-review`, `/review-all-gdds`, `/consistency-check` |
| **Technical Setup** | `/create-architecture`, `/architecture-decision`, `/architecture-review`, `/create-control-manifest` |
| **Pre-Production** | `/asset-spec`, `/ux-design`, `/prototype`, `/create-epics`, `/create-stories`, `/sprint-plan` |
| **Production** | `/dev-story`, `/code-review`, `/story-done`, `/qa-plan`, `/bug-report`, `/retrospective` |
| **Polish/Release** | `/perf-profile`, `/balance-check`, `/team-polish`, `/release-checklist`, `/launch-checklist` |

> Full catalog: `.claude/docs/workflow-catalog.yaml`

---

## Swarm Orchestration (Ruflo Engine)

### Default Swarm Config
```toml
topology   = "hierarchical"   # Prevents drift via central coordination
maxAgents  = 8                # Tight team = less drift
strategy   = "specialized"    # Clear roles, no overlap
consensus  = "raft"           # Leader maintains authoritative state
```

### Agent Routing Codes (Anti-Drift)
| Code | Task Type | Agents Spawned |
|------|-----------|----------------|
| 1 | Bug Fix | planner, researcher, coder, tester |
| 3 | Feature | planner, lead (domain), specialist(s), tester, reviewer |
| 5 | Refactor | planner, lead-programmer, coder, reviewer |
| 7 | Performance | planner, performance-analyst, engine-programmer |
| 9 | Security | planner, security-engineer, reviewer |
| 13 | Design doc | game-designer (domain lead), narrative/systems as needed |

### Spawn Pattern (ALL in ONE message)
```javascript
Task({ prompt: "Design mechanic. SendMessage to 'lead-prog' when done.",
       name: "game-des", subagent_type: "game-designer", run_in_background: true })
Task({ prompt: "Wait for design. Architect code. SendMessage to 'coder'.",
       name: "lead-prog", subagent_type: "lead-programmer", run_in_background: true })
Task({ prompt: "Wait for arch. Implement. SendMessage to 'tester'.",
       name: "coder", subagent_type: "gameplay-programmer", run_in_background: true })
Task({ prompt: "Wait for code. Write tests. Report results.",
       name: "tester", subagent_type: "qa-tester", run_in_background: true })

SendMessage({ to: "game-des", message: "[full task context]" })
```

---

## Coordination Rules

1. **Vertical Delegation**: Leadership → Leads → Specialists. Never skip tiers for complex decisions.
2. **Horizontal Consultation**: Same-tier agents may consult but cannot make binding cross-domain decisions.
3. **Conflict Resolution**: Design conflicts → `creative-director`. Technical conflicts → `technical-director`.
4. **Change Propagation**: Multi-domain changes coordinated by `producer` or `rgs-orchestrator`.
5. **No Unilateral Cross-Domain Changes**: Agents must not modify files outside their designated directories without delegation.
6. **Anti-Drift**: Spawn all agents in one message, use SendMessage for coordination, never poll.

---

## Model Tier Assignment

| Tier | Model | When to Use |
|------|-------|-------------|
| **Haiku** | `claude-haiku-4-5-20251001` | Read-only status, formatting, simple lookups |
| **Sonnet** | `claude-sonnet-4-6` | Implementation, design authoring, analysis — default |
| **Opus** | `claude-opus-4-6` | Multi-document synthesis, high-stakes decisions, orchestration |

---

## Project Structure

@.claude/docs/directory-structure.md

## Technical Preferences

@.claude/docs/technical-preferences.md

## Coding Standards

@.claude/docs/coding-standards.md

## Context Management

@.claude/docs/context-management.md

## Agent Roster (full UE5 agent list)

@.claude/docs/agent-roster.md

---

## Session Recovery

After a crash or `/clear`, recover state:
1. `session-start.sh` auto-previews `production/session-state/active.md`
2. Read the state file for full context
3. Read partially-completed files listed there
4. Continue from the next incomplete section

> **First session?** Run `/start` to begin guided onboarding.
