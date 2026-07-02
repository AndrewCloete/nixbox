---
default: false
---

# Database and State-Store Migrations

Any persistent store with a schema (relational DB, document store, vector index,
key-value schema, etc.) must be managed with explicit, versioned migrations — not
idempotent seed scripts. Migrations must be tracked so the AI always knows whether the
running schema matches the code.

Rules:
- Choose a migration tool appropriate to the stack at project setup; do not defer this
  decision.
- The AI must query migration state before assuming the schema matches the models.
- Destructive migration steps (column drops, table renames, data transforms) require
  explicit user confirmation before execution.
- Never modify migration files that have already been applied to any environment.
