# Constitution

## Project context

Run `/collect-context` at the start of any session. It explains the context
system, collects distributed markers from the codebase, and tells you how to
add new ones.

## Dependencies and packages

When adding dependencies, the AI must look up the latest most stable version. Where
possible it must use the appropriate package manager command to add and update
dependencies rather than manually changing the dependency files (e.g. using `uv add`
over modifying `pyproject.toml`).

## Use a justfile

The Justfile is an integral part of the development experience as well as project
context. The AI must use `just` to build and use clean commands for the development
life-cycle. This not only optimises token usage for commands run often but serves as
self-documenting context for a clean AI session. It must contain docstrings both for
human and machine consumption. The human is also expected to interact with the project
via `just`.

Just commands should not rely on default arguments for the underlying system commands
being used. They must declare them explicitly so that the developer reading the
justfile can clearly see what is being run.

## Logging

Logs must be optimised for machine readability over human readability. Logs must be in
JSON format. The log message (`msg`) may not be a dynamic / interpolated string.
Rather, it must be a single static string that uniquely identifies that log event —
dynamic content belongs in other keys of the JSON object. Debug, Info, Warning, and
Error log levels must be used. A runtime parameter must allow logs to be written to a
tmp file so that the AI can easily query over it. Each JSON object must be on a single
line for easy `grep`/`sed` filter operations (token-efficient).

## Debugging methodology

Errors and buggy behaviour must be treated as **theories** to be proven and verified.
Unless the source of a bug is trivially obvious, use the logging system to collect
runtime feedback before drawing conclusions. Perform an online search to build
evidence for theories when the cause is not immediately clear.

## Database schema and migration management

Use a proper migration tracking system (like Rails, Django, or sqlx migrations) rather
than an idempotent seed script. The AI must be aware of migration state and must not
assume the database matches the code. Design for explicit migration tracking up front —
do not discover the need for it after a failed seed step.
