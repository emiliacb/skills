---
name: delegate
description: Use always you find yourself in a main thread. We want to delegate everything we can to subagents.
---

# Delegate

Use the subagents Manager, Explorer, Implementer, Planner, Refactorer, Retro, Shipper and Tester.

This skill needs a harness that can load those subagents from the `agents/` directory shipped
beside it. Without them there is nothing to delegate to, and the skill does not apply.

## Descriptions

**manager** — Owns a task end to end and delegates every step of it to subagents. Runs no commands at all. Spawns explorers for context, a planner for the spec and plan, implementers for the code and for every shell command, a refactorer for cleanup, a tester for verification. Writes the Definition of Ready, scores the plan against it, and sends feedback until it passes. Use for any task big enough to need a plan.

**explorer** — Read-only codebase reconnaissance. Answers one specific question about how code works, where something lives, what calls what, or what breaks if X changes, and reports findings with file:line citations instead of file dumps. Cannot write, edit, or spawn agents.

**implementer** — Executes one task from an implementation plan, test first. Writes the test, watches it fail, makes it pass, stops. Runs only the test file it is working on, never the full suite, and never commits or pushes. Expects manager feedback and revises in place.

**planner** — Turns a task into a spec with Given/When/Then acceptance criteria plus a step by step implementation plan. Confirms every file and symbol it names by spawning explorers first. Expects to receive feedback from a manager and to revise the same document in place. Use when a task needs a plan before any code.

**refactorer** — Directs the cleanup of a finished diff without editing code itself. Decides what to delete, split, dedupe, rename and un-comment, then dispatches each change to an implementer and verifies the result. Spawns explorers for the facts it needs. Scoped strictly to the diff. Runs after the implementer, before verification.

**retro** — Reads a finished session and proposes changes to these agent prompts, based on how the run actually performed and on every place the human had to correct, repeat or push back. Proposes only; it holds no Write and no Edit. Runs as the manager's last step.

**shipper** — Opens a draft pull request whose description follows the project's PR-description skill, then drives it through the automated review until the reviewer signs off with zero unresolved comments. It pushes, so it only runs when the human explicitly asks to ship or to open a PR.

**tester** — Runs the repository's tests and checks on a finished branch and reports the real output, pass or fail. Discovers the commands from the repo's own docs and skills instead of guessing them, does the required setup first, and never edits code to make a run green. Runs as the manager's verification step.
