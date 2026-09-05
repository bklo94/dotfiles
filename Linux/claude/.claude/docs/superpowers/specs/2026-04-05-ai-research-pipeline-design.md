# AI Research Pipeline — Design Spec

## Overview

A multi-agent system that takes a research task through a structured pipeline: research, parallel critical + creative analysis, post-mortem review, and documentation. An AI Manager orchestrates the full pipeline and ensures memory and documentation are updated after every run.

## Architecture

Linear pipeline with parallel branch:

```
User → Manager → Researcher → [Critical + Creative (parallel)] → Post-Mortem → Documenter → Memory Update
```

## Agent Inventory

All agents are stored globally in `~/.claude/agents/`:

| Agent | File | Role |
|-------|------|------|
| AI Manager | `ai-manager.md` | Orchestrates pipeline, dispatches agents, presents final summary |
| Researcher | `researcher.md` | Deep research on any topic (codebase + web) |
| Critical Analyst | `critical-analyst.md` | Finds flaws, risks, counterarguments |
| Creative Analyst | `creative-analyst.md` | Finds novel angles, unexpected connections |
| Post-Mortem | `post-mortem.md` | Reviews all transcripts, identifies patterns and blind spots |
| Documenter | `documenter.md` | Writes reports, updates memory bank |

## Pipeline Stages

### Stage 1: Research

- **Agent:** Researcher
- **Input:** The user's research task
- **Tools available:** Grep, Glob, Read (codebase), WebSearch, WebFetch (web)
- **Output:** Structured findings with sources and confidence levels
- **Output file:** `~/.claude/ai-pipeline/staging/research-<timestamp>.md`

### Stage 2: Critical + Creative Analysis (Parallel)

Both agents receive the research output file and process it independently.

**Critical Analyst:**
- Identifies logical gaps, unsupported claims, risks, counterarguments
- Rates each finding: Critical / Important / Observation
- **Output file:** `~/.claude/ai-pipeline/staging/critical-<timestamp>.md`

**Creative Analyst:**
- Identifies novel applications, cross-domain connections, opportunities
- Generates "what if" scenarios and alternative approaches
- **Output file:** `~/.claude/ai-pipeline/staging/creative-<timestamp>.md`

### Stage 3: Post-Mortem

- **Agent:** Post-Mortem
- **Input:** All previous stage outputs + agent transcripts
- **Responsibilities:**
  - Identify blind spots shared by all agents
  - Find contradictions between critical and creative analyses
  - Assess research quality and coverage
  - Suggest pipeline improvements
- **Output file:** `~/.claude/ai-pipeline/staging/postmortem-<timestamp>.md`

### Stage 4: Documentation

- **Agent:** Documenter
- **Input:** All stage outputs
- **Actions:**
  1. Write consolidated report to `~/.claude/ai-pipeline/reports/YYYY-MM-DD-<topic>.md`
  2. Save memory entry to memory bank with key findings
  3. Update `MEMORY.md` index

### Stage 5: Manager Summary

- Manager receives the final report
- Presents a concise summary to the user
- Highlights key findings, critical risks, and creative opportunities

## File Structure

```
~/.claude/
├── agents/
│   ├── ai-manager.md
│   ├── researcher.md
│   ├── critical-analyst.md
│   ├── creative-analyst.md
│   ├── post-mortem.md
│   └── documenter.md
├── ai-pipeline/
│   ├── reports/          # Final consolidated reports
│   │   └── YYYY-MM-DD-<topic>.md
│   └── staging/          # Intermediate outputs between stages
│       ├── research-<ts>.md
│       ├── critical-<ts>.md
│       ├── creative-<ts>.md
│       └── postmortem-<ts>.md
```

## Memory & Documentation Protocol

After every pipeline run:

1. **Full report** saved to `~/.claude/ai-pipeline/reports/YYYY-MM-DD-<topic>.md`
2. **Memory entry** saved to the relevant project memory bank (or global memory if no project context)
3. **MEMORY.md index** updated with a one-line pointer to the new memory entry
4. **Report structure:**
   - Task description
   - Research findings (with sources)
   - Critical analysis (risks and gaps)
   - Creative analysis (opportunities and novel angles)
   - Post-mortem meta-analysis (blind spots, contradictions)
   - Key takeaways

## Manager Agent Behavior

The AI Manager:

1. Receives the research task from the user
2. Creates staging directory and initializes the pipeline
3. Dispatches the Researcher with the task
4. After research completes, dispatches Critical and Creative agents in parallel
5. After both analyses complete, dispatches Post-Mortem agent
6. After post-mortem, dispatches Documenter
7. Receives final report, presents summary to user
8. Cleans up staging files (optional, reports are preserved)

The manager passes context between stages by reading the previous stage's output file and including it in the next agent's prompt.

## Agent Prompt Structure

Each agent follows this pattern:

```markdown
---
name: <agent-name>
description: <when to use this agent>
model: inherit
---

# <Agent Name>

<Agent identity and role>

## Input

<What the agent receives>

## Process

<Steps the agent follows>

## Output

<What the agent produces and where>

## Constraints

<Rules the agent must follow>
```

## Triggering the Pipeline

The user triggers the pipeline by asking Claude to run research, e.g.:
- "Research X"
- "Run the AI pipeline on Y"
- "Use the research team to investigate Z"

Claude recognizes the intent and dispatches the AI Manager agent. There is no slash command — the manager is invoked through the Agent tool when the user's request matches research tasks.

## Memory Bank Path

When updating memory, the Documenter uses:
- **Project context exists:** `~/.claude/projects/<project>/memory/`
- **No project context:** `~/.claude/projects/-home-bklo--claude/memory/` (global memory)

## Guard Clauses

- If the research task is trivial (e.g., a simple lookup), the manager may short-circuit by doing the research itself and skipping the full pipeline
- If a stage fails, the manager logs the failure and continues with available data
- Staging files are timestamped to prevent collisions between concurrent runs
