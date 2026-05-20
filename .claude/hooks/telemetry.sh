#!/bin/bash
# RGS Telemetry Hook — outputs status line for Claude Code
# Works in two modes:
#   1. statusLine command: no stdin, just outputs current state
#   2. PostToolUse hook: receives JSON on stdin, estimates ctx from transcript
#
# Output format: ctx: [N]% | model: [model] | [Phase]
#
# Claude Code renders the output of the statusLine command in the CLI footer.

SETTINGS=".claude/settings.json"
STATE_FILE="production/session-state/active.md"

# --- Detect model from hook input or default to sonnet ---
INPUT=""
TRANSCRIPT_PATH=""
if [ -t 0 ]; then
    # No stdin (statusLine mode)
    :
else
    INPUT=$(cat 2>/dev/null)
    if command -v jq >/dev/null 2>&1; then
        TRANSCRIPT_PATH=$(echo "$INPUT" | jq -r '.transcript_path // ""' 2>/dev/null)
    fi
fi

# --- Estimate context usage from transcript file ---
CTX_PCT="??"
if [ -n "$TRANSCRIPT_PATH" ] && [ -f "$TRANSCRIPT_PATH" ]; then
    # Count raw bytes; Sonnet 4.6 context = 200k tokens ≈ 800k chars
    BYTES=$(wc -c < "$TRANSCRIPT_PATH" 2>/dev/null || echo 0)
    # Each JSONL line is a full message object — strip JSON overhead (≈60% content ratio)
    CONTENT_BYTES=$(echo "$BYTES * 6 / 10" | bc 2>/dev/null || echo 0)
    CTX_WINDOW=800000  # 200k tokens × 4 chars/token
    if [ "$CONTENT_BYTES" -gt 0 ] && command -v bc >/dev/null 2>&1; then
        CTX_PCT=$(echo "scale=0; $CONTENT_BYTES * 100 / $CTX_WINDOW" | bc 2>/dev/null || echo "??")
        # Clamp to 99 max (never show 100 — it would be a crash)
        [ "$CTX_PCT" -gt 99 ] 2>/dev/null && CTX_PCT=99
    fi
fi

# --- Determine active model ---
# Read from active.md if agent is named there, else fall back to sonnet
MODEL="sonnet"
if [ -f "$STATE_FILE" ]; then
    AGENT=$(grep -i "^Agent:" "$STATE_FILE" 2>/dev/null | head -1 | sed 's/Agent:[[:space:]]*//')
    if [ -n "$AGENT" ] && [ -f "$SETTINGS" ] && command -v jq >/dev/null 2>&1; then
        IS_OPUS=$(jq -r --arg a "$AGENT" '.model_tiers.opus.agents[] | select(. == $a)' "$SETTINGS" 2>/dev/null)
        IS_HAIKU=$(jq -r --arg a "$AGENT" '.model_tiers.haiku.agents[] | select(. == $a)' "$SETTINGS" 2>/dev/null)
        [ -n "$IS_OPUS" ]  && MODEL="opus"
        [ -n "$IS_HAIKU" ] && MODEL="haiku"
    fi
fi

# --- Determine current phase from active.md STATUS block ---
PHASE="Idle"
if [ -f "$STATE_FILE" ]; then
    # Try STATUS block first
    IN_BLOCK=0
    EPIC="" FEATURE="" TASK=""
    while IFS= read -r line; do
        [ "$line" = "<!-- STATUS -->" ] && IN_BLOCK=1 && continue
        [ "$line" = "<!-- /STATUS -->" ] && IN_BLOCK=0 && continue
        if [ "$IN_BLOCK" -eq 1 ]; then
            case "$line" in
                Epic:*)    EPIC=$(echo "$line"    | sed 's/Epic:[[:space:]]*//');;
                Feature:*) FEATURE=$(echo "$line" | sed 's/Feature:[[:space:]]*//');;
                Task:*)    TASK=$(echo "$line"    | sed 's/Task:[[:space:]]*//');;
            esac
        fi
    done < "$STATE_FILE"

    if [ -n "$EPIC" ] && [ -n "$FEATURE" ]; then
        PHASE="$EPIC > $FEATURE"
        [ -n "$TASK" ] && PHASE="$PHASE > $TASK"
    elif [ -n "$EPIC" ]; then
        PHASE="$EPIC"
    else
        # Fall back: look for Phase: line
        PHASE_LINE=$(grep -i "^Phase:" "$STATE_FILE" 2>/dev/null | head -1 | sed 's/Phase:[[:space:]]*//')
        [ -n "$PHASE_LINE" ] && PHASE="$PHASE_LINE"
    fi
fi

# --- Output status line ---
echo "ctx: ${CTX_PCT}% | model: ${MODEL} | ${PHASE}"
exit 0
