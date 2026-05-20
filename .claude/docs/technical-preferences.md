# Technical Preferences

<!-- Populated by /setup-engine. Updated as the user makes decisions throughout development. -->
<!-- All agents reference this file for project-specific standards and conventions. -->

## Engine & Language

- **Engine**: Unreal Engine 5 (exclusive)
- **Languages**: C++ (primary), Blueprint (gameplay prototyping)
- **Rendering**: Lumen (global illumination), Nanite (virtualized geometry)
- **Physics**: Chaos Physics

## Input & Platform

<!-- Written by /setup-engine. Read by /ux-design, /ux-review, /test-setup, /team-ui, and /dev-story -->

- **Target Platforms**: [TO BE CONFIGURED — e.g., PC, Console]
- **Input Methods**: [TO BE CONFIGURED — e.g., Keyboard/Mouse, Gamepad]
- **Primary Input**: [TO BE CONFIGURED]
- **Gamepad Support**: [TO BE CONFIGURED — Full / Partial / None]
- **Touch Support**: None (UE5 not suited for mobile)
- **Platform Notes**: [TO BE CONFIGURED — e.g., must support d-pad navigation for console]

## Naming Conventions (UE5 C++ Standard)

- **Classes**: Prefixed PascalCase — `A` Actor, `U` UObject, `F` struct, `E` enum, `I` interface
- **Variables**: PascalCase (e.g., `MoveSpeed`, `JumpVelocity`)
- **Booleans**: `b` prefix (e.g., `bIsAlive`, `bCanJump`)
- **Functions**: PascalCase (e.g., `TakeDamage()`, `OnHealthChanged()`)
- **Files**: Match class without prefix (e.g., `PlayerController.h` / `PlayerController.cpp`)
- **Blueprints**: `BP_` prefix (e.g., `BP_PlayerCharacter`, `BP_EnemyBase`)
- **Materials**: `M_` prefix; instances `MI_` (e.g., `M_Rock_01`, `MI_Rock_01`)
- **Textures**: `T_` prefix (e.g., `T_Rock_Albedo_01`)
- **Constants**: PascalCase or UPPER_SNAKE_CASE

## Performance Budgets

- **Target Framerate**: [TO BE CONFIGURED — e.g., 60fps / 30fps console]
- **Frame Budget**: [TO BE CONFIGURED — e.g., 16.6ms at 60fps]
- **Draw Calls**: [TO BE CONFIGURED — UE5 Nanite reduces geometry draw calls significantly]
- **Memory Ceiling**: [TO BE CONFIGURED]

## Testing

- **Framework**: [TO BE CONFIGURED — UE5 Automation System / Gauntlet]
- **Minimum Coverage**: [TO BE CONFIGURED]
- **Required Tests**: Balance formulas, gameplay systems, networking (if applicable)

## Forbidden Patterns

- Do not use Blueprint for performance-critical gameplay logic — use C++
- Do not hardcode gameplay values — use Data Assets or Data Tables
- Do not call `GetWorld()` without null-checking the result
- [Add more as architectural decisions are made]

## Allowed Libraries / Addons

- [None configured yet — add as dependencies are approved]

## Architecture Decisions Log

<!-- Quick reference linking to full ADRs in docs/architecture/ -->
- [No ADRs yet — use /architecture-decision to create one]

## Engine Specialists

<!-- Read by /code-review, /architecture-decision, /architecture-review, and team skills -->

- **Primary**: `unreal-specialist`
- **Language/Code Specialist**: `ue-blueprint-specialist` (Blueprint graphs) / `unreal-specialist` (C++)
- **Shader Specialist**: `unreal-specialist` (Materials, HLSL, custom shaders — no dedicated shader agent needed)
- **UI Specialist**: `ue-umg-specialist` (UMG widgets, CommonUI, input routing, widget styling)
- **Additional Specialists**:
  - `ue-gas-specialist` — Gameplay Ability System, attributes, gameplay effects, tags
  - `ue-replication-specialist` — property replication, RPCs, netcode, prediction
- **Routing Notes**: Invoke primary for C++ architecture and broad engine decisions. Blueprint specialist for Blueprint graph architecture and BP/C++ boundary. GAS specialist for all ability and attribute code. Replication specialist for any multiplayer systems. UMG specialist for all UI implementation.

### File Extension Routing

| File Extension / Type | Specialist to Spawn |
|-----------------------|---------------------|
| C++ source (.cpp, .h files) | `unreal-specialist` |
| Shader / material (.usf, .ush, Material assets) | `unreal-specialist` |
| UI / widgets (.umg, UMG Widget Blueprints) | `ue-umg-specialist` |
| Level / map files (.umap, .uasset levels) | `unreal-specialist` |
| Plugin files (.uplugin, plugin modules) | `unreal-specialist` |
| Blueprint graphs (.uasset BP classes) | `ue-blueprint-specialist` |
| General architecture review | `unreal-specialist` |
