---
name: setup-engine
description: "Pin your Unreal Engine 5 version, detect knowledge gaps beyond the LLM's training data, populate UE5 reference docs via WebSearch, and configure naming conventions and specialist routing in technical-preferences.md."
argument-hint: "[ue5-version] | refresh | upgrade [old-version] [new-version] | no args for guided"
user-invocable: true
allowed-tools: Read, Glob, Grep, Write, Edit, WebSearch, WebFetch, AskUserQuestion
model: sonnet
---

RGS is an **Unreal Engine 5 exclusive studio**. This skill pins the UE5 version,
detects API knowledge gaps, and populates reference docs.

---

## 1. Parse Arguments

Four modes:
- **Full spec**: `/setup-engine 5.4` — version provided directly
- **No args**: `/setup-engine` — guided: find latest stable via WebSearch, confirm with user
- **Refresh**: `/setup-engine refresh` — update reference docs to latest web content
- **Upgrade**: `/setup-engine upgrade [old] [new]` — migrate pinned version (see Section 6)

---

## 2. Determine UE5 Version

If no version provided, use WebSearch:
- Query: `"Unreal Engine 5 latest stable release 2025"`
- Confirm with user: "The latest stable UE5 is [version]. Pin this version?"

If version is provided, verify it exists via WebSearch.

---

## 3. Detect Knowledge Gap

**LLM knowledge cutoff: May 2025**

UE5 approximate training coverage:
- 5.0 – 5.3: well covered
- 5.4: partial (released early 2024 — partially covered)
- 5.5+: HIGH RISK — beyond training data

| Version | Risk | Action |
|---------|------|--------|
| 5.0–5.3 | LOW | Reference docs optional |
| 5.4 | MEDIUM | Reference docs recommended |
| 5.5+ | HIGH | Reference docs required |

Inform the user which category applies and why.

---

## 4. Update CLAUDE.md Technology Stack

Read `CLAUDE.md` and confirm the Technology Stack section is correct for UE5:

```markdown
- **Engine**: Unreal Engine 5 [version]
- **Languages**: C++ (primary), Blueprint (gameplay prototyping)
- **Build System**: UnrealBuildTool (UBT)
- **Asset Pipeline**: UE5 Content Browser + Derived Data Cache
```

Ask: "May I update the Technology Stack in `CLAUDE.md`?" — wait for confirmation.

Also update the Engine Version Reference import:
```markdown
@docs/engine-reference/ue5/VERSION.md
```

---

## 5. Populate Technical Preferences

Read `.claude/docs/technical-preferences.md`, then fill in all `[TO BE CONFIGURED]` placeholders.

### Engine & Language
```markdown
- **Engine**: Unreal Engine 5 [version]
- **Language**: C++ (primary), Blueprint (gameplay prototyping)
- **Rendering**: Lumen (global illumination), Nanite (virtualized geometry)
- **Physics**: Chaos Physics
```

### Naming Conventions (UE5 C++ standard)
```markdown
- **Classes**: Prefixed PascalCase — `A` Actor, `U` UObject, `F` struct, `E` enum, `I` interface
- **Variables**: PascalCase (e.g., `MoveSpeed`, `JumpVelocity`)
- **Booleans**: `b` prefix (e.g., `bIsAlive`, `bCanJump`)
- **Functions**: PascalCase (e.g., `TakeDamage()`, `OnHealthChanged()`)
- **Files**: Match class without prefix (e.g., `PlayerController.h/.cpp`)
- **Blueprints**: PascalCase with `BP_` prefix (e.g., `BP_PlayerCharacter`)
- **Materials**: `M_` prefix (e.g., `M_Rock_01`); instances `MI_`
- **Constants**: `k` prefix or UPPER_SNAKE_CASE
```

### Engine Specialists Routing
```markdown
## Engine Specialists
- **Primary**: unreal-specialist
- **Language/Code Specialist**: ue-blueprint-specialist (Blueprint graphs) / unreal-specialist (C++)
- **Shader Specialist**: unreal-specialist (Materials, HLSL, custom shaders)
- **UI Specialist**: ue-umg-specialist (UMG widgets, CommonUI, input routing)
- **Additional Specialists**:
    - ue-gas-specialist (Gameplay Ability System, attributes, gameplay effects)
    - ue-replication-specialist (property replication, RPCs, netcode, prediction)
- **Routing Notes**: Invoke primary for C++ architecture and broad engine decisions. Blueprint specialist for BP graph architecture and BP/C++ boundary design. GAS specialist for all ability and attribute code. Replication specialist for any multiplayer systems. UMG specialist for all UI.

### File Extension Routing
| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| C++ source (.cpp, .h) | unreal-specialist |
| Shader / material (.usf, .ush, Material assets) | unreal-specialist |
| UI / widgets (.umg, UMG Widget Blueprints) | ue-umg-specialist |
| Level / map files (.umap, .uasset levels) | unreal-specialist |
| Plugin files (.uplugin, plugin modules) | unreal-specialist |
| Blueprint graphs (.uasset BP classes) | ue-blueprint-specialist |
| General architecture review | unreal-specialist |
```

Ask the user for input on platforms, performance budgets, and testing framework.
Present defaults and ask: "May I write these preferences to `technical-preferences.md`?"
Wait for confirmation before writing.

---

## 6. Populate Engine Reference Docs

### LOW RISK (5.0–5.3): Minimal VERSION.md only

```markdown
# Unreal Engine 5 — Version Reference
| Field | Value |
|-------|-------|
| **Engine Version** | [version] |
| **Project Pinned** | [date] |
| **LLM Knowledge Cutoff** | May 2025 |
| **Risk Level** | LOW — within LLM training data |
```

### MEDIUM / HIGH RISK (5.4+): Full reference set via WebSearch

Search for:
1. `"Unreal Engine [version] migration guide changelog"`
2. `"Unreal Engine [version] deprecated API"`
3. `"Unreal Engine [version] breaking changes"`

Ask: "May I create reference docs under `docs/engine-reference/ue5/`?"
Wait for confirmation, then create:
```
docs/engine-reference/ue5/
├── VERSION.md              # Version pin + knowledge gap analysis
├── breaking-changes.md     # Breaking API changes by version
├── deprecated-apis.md      # "Don't use X → Use Y" tables
└── current-best-practices.md  # New practices since training cutoff
```

Each file must include: `Last verified: [date]`

---

## 7. Refresh Subcommand (`/setup-engine refresh`)

1. Read `docs/engine-reference/ue5/VERSION.md` for current pinned version
2. WebSearch for new releases or updated migration guides since last verification
3. Update all reference docs and `Last verified` dates
4. Report what changed

---

## 8. Upgrade Subcommand (`/setup-engine upgrade [old] [new]`)

1. Read current `VERSION.md` to confirm pinned version
2. WebSearch migration guide: `"Unreal Engine [old] to [new] migration"`
3. Grep `src/` for deprecated API names from the migration guide
4. Present audit table: files affected, deprecated API, estimated effort
5. Ask: "Proceed with updating VERSION.md to [new]?" — wait for confirmation
6. Update VERSION.md: version, pin date, risk level, migration notes section
7. Output next steps: source migration, `/architecture-review`, ADR review

---

## 9. Output Summary

```
UE5 Setup Complete
==================
Engine:          Unreal Engine 5 [version]
Languages:       C++ (primary), Blueprint
Knowledge Risk:  [LOW/MEDIUM/HIGH]
Reference Docs:  [created/skipped]
CLAUDE.md:       updated
Tech Prefs:      updated

Next Steps:
1. Review docs/engine-reference/ue5/VERSION.md
2. Run /brainstorm to develop your game concept
3. Run /map-systems to decompose concept into systems
4. Run /design-system to author per-system GDDs
```

Verdict: **COMPLETE** — UE5 pinned and reference docs populated.

## Guardrails

- NEVER suggest Unity, Godot, or any engine other than UE5 — this is an exclusive UE5 studio
- NEVER guess a version — verify via WebSearch or user confirmation
- NEVER overwrite existing reference docs without asking
- Always show proposed changes before editing CLAUDE.md or technical-preferences.md
