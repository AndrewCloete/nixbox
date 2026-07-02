# Claude context — AI best-practices folder

This folder is a curated, versioned collection of AI development best practices.
It is both a source-of-truth and a marshal system: `just marshal <target>` copies
selected items into a new project, stamped with the git SHA so versioning can be
tracked programmatically across all projects on this machine.

## Architecture decisions

### Decoupled constitution files (`constitutions/`)
Each principle is a separate file so projects can cherry-pick what applies — a web
project needs `logging.md` and `debugging.md` but probably not `migrations.md`.
The `default: true` frontmatter field controls pre-selection in the marshal picker.
Constitution files must be self-contained so they can be copied to any project
independently. The exception is advisory cross-references using `[[name]]` links,
which are non-binding.

### `AGENTS.md` is the canonical AI entrypoint (always written on marshal)
Every marshalled project gets an `AGENTS.md` derived from `templates/entrypoint.md`.
It is the vendor-agnostic file that instructs any AI agent to read `constitutions/`
and `skills/` before starting work. It is also the native entrypoint for OpenAI
Codex, so no stub is needed for that vendor.

### Vendor stubs are thin redirects, not content
`CLAUDE.md`, `GEMINI.md`, and other vendor-specific files in a marshalled project
contain only one instruction: "Read `AGENTS.md`". All real content lives in
`AGENTS.md`. This keeps the system DRY — one source, many vendor redirects.
`config/vendors.yaml` is the authoritative vendor list. Claude and Gemini are
defaults; all others are opt-in during marshal.

### Skills are vendor-agnostic procedures
Skills (`skills/`) are plain procedural markdown that any LLM can follow. The
difference between vendors is invocation only:
- **Claude Code**: formal `/skill-name` slash command via the Skill tool
- **All others**: model reads `skills/` at startup (instructed by `AGENTS.md`)
  and internalises the procedures — no formal registration mechanism exists

Formal skill registration only adds value for on-demand, repeatable invocation.
Startup procedures (like `collect-context`) work equally well for all vendors
because the constitution instructs the agent to follow them at session start.
There is no need to write vendor-specific skill wrappers.

### Short SHA in marshalled frontmatter
Marshalled files carry a short git SHA (`source_sha`). This is intentionally short —
a scraper running across all projects on this machine only needs to identify the
version, not perform full commit lookups. The combination of `source_sha` +
`marshalled_at` is sufficient to answer "is this current?" and "when was it
installed?".

## Invariants

- `AGENTS.md` is always written on marshal — never make it optional.
- Vendor stubs must not contain real content — only the redirect instruction.
- `templates/entrypoint.md` is the single source for `AGENTS.md` content.
- Constitution files must be self-contained — no cross-file hard dependencies.
- Do not put implementation-specific content here (file paths, function names from a
  specific project) — that belongs in individual project CLAUDE.md files or
  `# context:` markers in code.

## When editing this folder

- **New constitution**: create `constitutions/<name>.md` with `default:` frontmatter.
- **New skill**: create `skills/<name>.md` with `default:` frontmatter.
- **New vendor**: add an entry to `config/vendors.yaml`.
- Prefer concrete, enforceable rules over abstract principles in all documents.
- Run `just list` to verify new files are discoverable before committing.
