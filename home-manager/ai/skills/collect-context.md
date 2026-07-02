---
default: true
---

# Collect distributed project context

## Why this system exists

Context that lives close to the thing it documents is more likely to be read and
maintained than context centralised in a single file. This project uses distributed
`# context:` markers placed adjacent to the code they explain — capturing **intent,
reasoning, and origin**: things that cannot be derived from reading the code itself.
CLAUDE.md is intentionally minimal; it holds only true cross-cutting invariants and
instructions for collecting the rest.

## Steps

Run these in parallel:

1. `grep -rn "# context:" src/ Justfile`
2. `grep -rn "{# context:" src/ --include="*.html"`
3. Read CLAUDE.md (remaining cross-cutting invariants)
4. Read the module-level docstrings (first 25 lines) of key entry-point files
   (adapt the list to the project at hand)

## Output

Present a concise briefing under: **DB & data model** | **Output pipeline** |
**Segment system** | **Operational constraints**

(Rename / remove sections that don't apply to the project.)

## Self-instruction for new discoveries

When you learn something non-obvious that future sessions will need — a hidden
constraint, a surprising invariant, a design decision that would otherwise require
reading commit history — add a `# context:` marker adjacent to the relevant code.
Do not add it to CLAUDE.md unless it genuinely has no single code home.

| File type         | Syntax                       |
|-------------------|------------------------------|
| Python / Justfile | `# context: explanation`     |
| Jinja template    | `{# context: explanation #}` |
| SQL (MariaDB)     | `-- context: explanation`    |

Markers should state **why**, not **what** — the code already says what it does.
