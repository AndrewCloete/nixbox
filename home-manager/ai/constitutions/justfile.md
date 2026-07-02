# Justfile

Every project must have a Justfile. If one does not exist, create it before writing
any other scaffolding. The Justfile is the canonical interface for all development
lifecycle commands (build, test, run, migrate, lint, etc.). Both the human and the AI
interact with the project exclusively through `just`.

Requirements:
- Every recipe must have a `# Description: ...` comment immediately above it for
  human and machine consumption.
- Recipe commands must pass all flags explicitly — never rely on a tool's default
  behaviour being implicit. A reader must be able to understand exactly what will run
  without knowing the tool's defaults.
- New commands discovered during a session must be added to the Justfile before the
  session ends.
