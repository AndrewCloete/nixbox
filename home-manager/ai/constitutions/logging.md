# Logging

Logs must be optimised for machine readability. All log output must be newline-delimited
JSON (one object per line) so that `grep`, `jq`, and `sed` can operate on it without
a parser.

Rules:
- The `msg` field must be a static string — it uniquely identifies the log site.
  Dynamic values belong in additional fields (e.g. `{"msg": "query executed",
  "duration_ms": 42, "rows": 7}`).
- Use four levels: `debug`, `info`, `warning`, `error`. Choose based on whether the
  reader needs to act.
- A runtime parameter (env var `LOG_FILE=<path>` or CLI flag `--log-file <path>`,
  documented in the Justfile) must redirect log output to a tmp file so the AI can
  query it during debugging.
