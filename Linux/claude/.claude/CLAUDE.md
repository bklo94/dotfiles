# Global Guidelines

## MANDATORY CHECKPOINTS — Hard Gates

These are non-negotiable gates. Skipping any of these is a failure, not an oversight.

### Before Every Commit
- [ ] **Regression tests exist** for all bug fixes and new features. If none exist, STOP and write them first.
- [ ] **Test suite passes**. Run the project-specific test command. Do not commit failing tests.
- [ ] **Resume updated** at `~/Github/Resume` if this is a new feature (not a bug fix or refactor).

### Before Marking Work Complete
- [ ] All mandatory checkpoints above are satisfied.
- [ ] Non-obvious patterns, gotchas, or debugging insights saved to the project memory bank.
- [ ] **Bug fixes saved to memory bank** — the root cause, the fix, and any gotchas discovered during debugging.

### Regression Test Requirements
- Test names must be traceable to the original issue: `it('should not crash when X is null, fixes #123')` or `it('supports feature Y per spec ABC')`
- Bug fixes: write a test that reproduces the bug first, confirm it fails, then verify the fix passes.
- New features: write tests covering core behavior and edge cases.

---

## AUTONOMY — Never Ask to Confirm Implementation (HARD RULE)

**After researching/planning a task, IMPLEMENT IT DIRECTLY. Never ask "should I proceed?", "confirm?", or present a plan and wait for a go-ahead.** A confirmation prompt after research is a failure mode, not diligence.

- Do the research, decide the approach, then **build** — in the same turn.
- Only ask a clarifying question BEFORE starting work, and ONLY if the request is genuinely ambiguous (two materially different implementations and no way to infer which). If you can infer a sensible default, pick it and implement.
- Presenting a short plan inline as you execute is fine; pausing to ask permission to execute is not.
- This overrides any default that suggests plan-approval or "confirm before implementing" for bounded/architectural work. The user has explicitly and repeatedly forbidden post-research confirmation prompts.
- Exceptions requiring a real question: destructive/irreversible/outward-facing actions that are NOT already authorized by standing instructions (e.g. "always deploy" feedback counts as standing authorization), or a genuine fork where guessing wrong wastes more than a quick question saves. Implementation choice is NEVER such a fork — just implement.

---

## Workflows & Ultracode (Default Behavior)

**Tool selection**
- **Match the tool to the task's shape** — **Agent** for one delegated subagent doing multi-step work (e.g. "find every caller of a given function"); **Workflow** for deterministic multi-agent orchestration when coverage, confidence, or scale is the point (e.g. "audit every API route for auth"); **`TaskCreate`/`TaskUpdate`/`TaskList`** as a lightweight progress tracker, NOT as an orchestration mechanism.
- **Pick the Agent by capability** — set `subagent_type` to fit the work (`backend-developer`, `frontend-developer`, `explorer`, `code-reviewer`, `general-purpose`); name spawned agents so they can be resumed or redirected via `SendMessage`.
- **Work SOLO on trivial or conversational turns** — a single file read, quick fix, answered question, or already-verified edit costs more to orchestrate than it saves.

**Opt-in gate & ultracode**
- **Gate Workflow behind explicit opt-in** — author one only when the user includes the keyword "ultracode", ultracode is ON for the session, the user asks for multi-agent orchestration in their own words, a skill or slash command instructs it, or the user names a saved workflow. Otherwise spawn one Agent, or briefly describe what a workflow could do and ask.
- **When ultracode is ON, it's a standing default** — author and run a workflow for EVERY substantive task by default; token cost is not a constraint. Opt in per-turn by including "ultracode" in the prompt.

**Workflow authoring**
- **Use Workflow to be comprehensive, confident, or to take on scale** — a deterministic multi-agent JS script (`agent()`/`pipeline()`/`parallel()`/`phase()`/`log()`) for fan-out coverage on audits/migrations/broad sweeps, independent perspectives with adversarial verification before committing, or breadth a single context cannot hold.
- **Run multi-phase work as a sequence of workflows** — one per phase (understand → design → implement → review), staying in the loop and reading output between them; orchestrating is not fire-and-forget.
- **Default to `pipeline()`** — stage results flow forward incrementally; reach for a `parallel()` barrier only when a stage genuinely needs ALL prior results together before it can proceed.
- **Adversarially verify findings** — spawn skeptics per finding and kill any a majority refute; use a judge panel (N attempts scored → synthesize) for generative output; loop-until-dry for unknown-size discovery.
- **Size workflows to the task** — default to medium (under ~15 agents) unless the user raises the limit (Dynamic workflow size in `/config`).
- **Use the planning skills as scaffolding** — `writing-plans`/`executing-plans` for multi-step work, `subagent-driven-development` for plans with independent tasks, `dispatching-parallel-agents` for 2+ independent subtasks with no shared state.

## User Preferences
- **NEVER ask to confirm implementation after research** — research, decide, implement in one turn. See the AUTONOMY hard rule above. This is the user's most strongly-stated preference.
- Communication style: concise, direct, no unnecessary preamble
- Always think deeply before responding — thorough analysis over quick answers
- Prefer functional programming patterns when the language supports it

## Package Managers
- Use `bun` for all TypeScript/JavaScript package management and script execution — never use `npm` or `npx`
- Use `bunx` instead of `npx` for running CLI tools without installing
- Use `bundle exec <cmd>` (or `bin/rails`/`bin/rake` binstubs) for Ruby/Rails projects

## Code Style (TypeScript projects)
- TypeScript strict mode always
- Prefer functional components in React
- Prefer `type` over `interface` for data structures
- No `any` types — use `unknown` if type is truly unknown

## Testing
- Test behavior, not implementation
- Run project-specific test commands before committing (see project CLAUDE.md)

## Secrets — Proton Pass (default secrets source)
- **Retrieve secrets via `pass-agent`** (wrapper at `~/.local/bin/pass-agent`) — it runs pass-cli as the scoped `claude-code` Proton Pass agent with an isolated session and auto re-login. **Never use bare `pass-cli`** — that touches bklo's personal session.
- Audited commands (`item view/create/update/trash/untrash`, `vault update`) REQUIRE a reason: `PROTON_PASS_AGENT_REASON="why" pass-agent item view --vault-name <vault> --item-title <item> --field password`
- Discovery: `pass-agent vault list --output json`, `pass-agent item list --output json`
- Agent has no vault access until granted. Grants/audit (personal session, not pass-agent): `pass-cli agent access grant claude-code --vault-name <vault> --role viewer|editor|manager`, `pass-cli agent monitor claude-code`

## Memory Bank
- Maintain a memory bank in `~/.claude/projects/<project>/memory/` for each project (durable per-project gotchas/decisions — distinct from the cross-project MCP `mcp__memory__*` knowledge-graph tools)
- Save learnings about the project: architecture decisions, gotchas, non-obvious patterns, debugging insights
- **Save all bug fixes to memory** — root cause, what was wrong, and the fix applied. This prevents repeating the same debugging on similar issues later.
- Use memory types: user, feedback, project, reference
- Keep MEMORY.md concise (under 200 lines) — it's an index, not a document
- After solving non-trivial problems or discovering non-obvious patterns, save them to memory
- Before starting work on a project, check the memory bank for relevant context

## Project Context & Settings Precedence
- Check project-level CLAUDE.md for project-specific commands, architecture, and conventions
- These global settings are overrides — project-level files take precedence
- Custom agents should reference project CLAUDE.md files instead of duplicating info
