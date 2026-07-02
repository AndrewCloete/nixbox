# Debugging Methodology

Treat every error or unexpected behaviour as a **theory**, not a known fact. Before
making any code change to fix a bug:

1. **State the theory** — write out the hypothesised cause in your response.
2. **Collect evidence** — use the logging system to observe actual runtime behaviour.
   Add temporary `debug` log statements if existing logs are insufficient.
3. **Verify before fixing** — confirm the theory matches the evidence. If it does not,
   revise the theory and repeat.
4. **Search when uncertain** — perform a web search to validate assumptions about
   library behaviour, error codes, or framework internals before drawing conclusions.

Do not patch code based on intuition alone. The log file is your instrument.

References: [[logging]]
