---
name: reduce-complexity
description: Per-line complexity reduction pass over the current branch's diff. Trigger phrases: "simplify code", "clean up", "refactor for clarity", "de-clever this", "review readability", "reduce complexity", or before opening a PR. Flattens dense expressions into boring, statement-shaped code without changing behavior. Differs from generic /simplify by targeting per-line density (ternaries, nested optional chaining, inline casts) rather than just removing lines.
---

# Reduce Complexity

> **Not `/simplify`.** Claude Code already ships a native `/simplify` command that removes lines and collapses blocks. This skill does the opposite: it *adds* lines to flatten dense expressions. One idea per line, named intermediates, early returns. When the user says "simplify" they usually mean "make readable" — this skill handles the cases where readable means more lines, not fewer.

Reduce the complexity of each line, NOT the line count. The taste being enforced:
boring, flat, statement-shaped code. One idea per line. Named intermediates over
inline expressions. `if`/early-return over ternary chains. A dumb 5-line block
beats a clever 1-liner.

## Phase 0 — Scope

1. Get the diff: `git diff origin/main...HEAD` (fall back to `main...HEAD`, then
   `HEAD~1`), plus uncommitted changes (`git diff HEAD`).
2. Only lines the branch added or changed are in scope. Pre-existing code only if
   the diff touched that exact statement.
3. If an argument was passed (PR number, file path), review that instead.

## Phase 1 — Review

Launch ONE review subagent via the Agent tool (read-only; its final message is
data for you, not the user). Give it the diff scope and this hunt list:

> If the harness does not support subagents (Claude Code /skills.sh without Agent tool, Pi, etc.), run the review inline yourself using the same hunt list below. The output format and rules stay identical.

1. **Ternaries doing too much**: nested ternary chains (rewrite as keyed map,
   if/return helper, or switch); ternaries whose branches contain function calls,
   object literals, or JSX beyond a trivial expression.
2. **Dense expressions**: multiple chained calls + optional chaining + nullish
   coalescing on one line where a named intermediate would tell the reader what
   the value IS; boolean conditions combining 3+ clauses inline (name the halves);
   inline `as` casts patching inference instead of restructuring (prefer typed
   declarations/annotations).
3. **Clever one-liners**: `??=` map-building, `.filter(Boolean) as X[]`,
   destructure-and-rename gymnastics, expression-bodied arrows hiding side
   effects — where a plain loop/if/block reads faster.
4. **Comments** that don't match the code, or that explain the obvious while
   missing the non-obvious.
5. **Naming**: variables in NEW code whose name forces a lookup (`result`,
   `data`, bare `map`).

Rules the reviewer must follow (pass verbatim):

- Behavior-preserving rewrites only.
- No new abstractions, no helpers shared across files, no type refactors —
  statement-level restructuring within each function.
- Respect the codebase's existing idiom.
- Skip anything where the rewrite would be longer AND no clearer.
- Each finding must include: file, line, one sentence on WHAT is complex, and
  the EXACT paste-ready replacement.

### Language-specific hunt list (TypeScript / JavaScript)

This skill was originally written for TS/JS codebases. When working in other
languages, translate the concepts: ternary chains → nested conditional
expressions, `as` casts → unsafe casts, `??=` → default-assignment idioms,
JSX → templating logic. For a language-agnostic core, see
`references/generic-hunt-list.md`.

## Phase 2 — Apply

1. Apply each rewrite. Skip any that would change behavior or that you judge a
   false positive — note skips, don't argue.
2. Run the project's own checks: its formatter/lint-fix command, its
   typechecker, and targeted tests for the touched files (discover them from
   CLAUDE.md or package scripts; don't guess tool names).
3. Finish with a summary of applied vs skipped findings.

## Worked example

Before — a repository call inside a ternary branch inside a `Promise.all` argument:

```ts
const [items, childCounts, siblingCounts] = await Promise.all([
  repo.findItems(ids),
  repo.countChildren(ids),
  parentId ? repo.countSiblings(await repo.findChainRootIds(parentId)) : Promise.resolve([]),
]);
```

After — await the prerequisite first, name it, keep the `Promise.all` flat:

```ts
const chainRootIds = parentId ? await repo.findChainRootIds(parentId) : [];
const [items, childCounts, siblingCounts] = await Promise.all([
  repo.findItems(ids),
  repo.countChildren(ids),
  repo.countSiblings(chainRootIds),
]);
```

Each line now holds one idea, and the intermediate's name says what the value is.
Check the callee before keeping a guard: here `countSiblings` already returns
empty for empty input, so no ternary is needed inside the `Promise.all` at all.
