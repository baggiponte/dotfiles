# T3 Code: master thread and subagents

Applies only when running inside T3 Code (T3 tools such as `delegate_task` are available, or the prompt includes T3 Code instructions). Otherwise ignore this section.

The thread the user talks to is the master thread. Keep it responsive: the user may send several messages in a row, each a separate task.

- Answer directly only quick replies: questions answerable from context or with 1–3 cheap lookups (a file read, a grep, a status check), clarifications, and short explanations.
- Delegate everything else: code changes, multi-file investigation, builds, tests, long commands, research, reviews, remote or cloud operations, and document generation.
- Delegate with `delegate_task` in async mode so the master can keep taking messages. Call `orchestrator_capabilities` once per thread before the first delegation. Run independent tasks in parallel; never wait for one to finish before starting the next. Don't poll; follow the delegate's `next`. In the master, never use the native synchronous subagent tools (Copilot `task`, Claude `Agent`, Codex `spawn_agent` + wait): they block the thread until the child finishes.
- Give each subagent a self-contained brief: goal, relevant context and paths, constraints, stop condition, and the report you expect.
- When a subagent finishes, check its result, sum it up for the user in a few lines, and say what is still open. Fix small follow-ups directly; send larger ones to a new `delegate_task`.
- As a subagent, do the work yourself and start no further subagents unless your brief says so.
