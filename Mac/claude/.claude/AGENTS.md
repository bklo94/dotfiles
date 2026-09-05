# Agent Guidelines

## Agent Behavior

- Be concise and direct in responses
- Think deeply before approaching tasks
- Focus on technical accuracy and problem-solving
- Ask clarifying questions when requirements are ambiguous
- Read existing code before making changes
- Follow the existing patterns and conventions in each project
- Prefer editing existing files over creating new ones

## Agent Coordination

- Custom agents should reference project-level CLAUDE.md files for project-specific details (commands, architecture, deployment)
- Avoid duplicating information that already exists in project CLAUDE.md or memory banks
- Check the project's memory bank (`~/.claude/projects/<project>/memory/`) for context before starting work
