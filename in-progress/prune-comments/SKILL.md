---
name: prune-comments
description: Delete comments that do not earn their place, keeping only what someone could break by not knowing. Comment-only diff, mechanically verified. Use when code reads as over-commented, when a review flags comment noise, after agent-written code (which over-explains by default), or when the user asks to prune, thin, or clean up comments.
---

# Prune comments

Over-commenting is a defect, not politeness. Every comment that restates the code
costs a reader attention and buries the two or three comments that carry real
information. This skill removes the noise and leaves the signal, in a diff that
touches nothing but comments.

**Announce at start:** "Using prune-comments on <scope>."

## Scope

Default to the current branch's diff, not the whole repo: prune what was just
written, since that is where the noise is.

```bash
git diff --name-only $(git merge-base HEAD origin/main) -- '*.ts' '*.tsx' '*.js' '*.py' '*.go' '*.rs'
```

Override with whatever the user names: paths, a directory, a single symbol, or a
different base (`--base <ref>`). If they name a file, prune only that file.

When the diff touches a file only partly, prune only the comments **inside or
about the changed code**. Comments elsewhere in that file are someone else's
decision and are out of scope, even when they look like noise. Say so rather
than silently widening the blast radius.

## The rule

**Keep a comment only if someone could break the code by not knowing it.**

That is the whole test. Apply it per comment, out loud, before deleting.

### Keep

- **Load-bearing detail**: why a cast, an escape order, a regex alternation
  order, or an await is required. `// the ::text casts exist because a bare
  parameter used only in IS NULL fails to prepare with 42P18` is a keep: delete
  it and the next person "simplifies" the cast away.
- **Non-obvious termination or convergence** of a loop or recursion.
- **An invariant a caller must not violate**, especially one the types cannot
  express. `// never touches the claim: a preview is not an attempt` is a keep.
- **A platform or protocol fact** the reader is unlikely to know: `// Slack
  mrkdwn is not markdown, bold is a single asterisk`.
- **A deliberate divergence that reads as a mistake** without the note, e.g.
  intentionally not mirroring a sibling function's guard.
- **A named limitation with its ceiling**, e.g. a global lock with the upgrade
  path, or a degradation that only works in one direction.

### Cut

- Restatements of the next line: `// increment the counter`, `// import the icon`.
- Structural narration: `// 1) build the context`, `// then render the footer`.
  If the steps need labels, the function needs splitting instead.
- Standard language or library behaviour every reader of this codebase knows.
- Rationale for something the types already enforce. A three-line note on the
  `default:` case of an exhaustive switch is the classic offender.
- Doc blocks that restate the signature. Trim to the part not derivable from the
  name and types; if nothing is left, delete the block.
- History and process: `// added in the refactor`, `// per task 3`, `// legacy`.
  Comments describe the present, never the changelog.
- Section banners decorating an obvious structure.

### Fix, do not just cut

A comment that is **wrong** is worse than no comment: it actively misleads.
When you find one that no longer matches the code, correct it rather than
deleting it, and call it out separately in your report. A stale comment usually
means the code changed and the invariant may have too, so read the code twice
before deciding which one is right.

## Process

1. **Read the whole file before touching it.** A comment can only be judged
   against the code it sits on, and often against a caller elsewhere.
2. For each comment, state the verdict and the reason. If the reason is "it
   might help someone", that is a cut.
3. Edit comments only. Do not reformat, reorder, rename, or "improve" code while
   you are in there, however tempting. A mixed diff cannot be reviewed as a
   comment pass, and a behaviour change hidden in one is how this goes wrong.
4. More than two or three files: dispatch one subagent per file group with the
   rule above quoted verbatim and the same comment-only constraint. Require each
   to report **what it kept and why**, not just how much it removed. Judgment is
   what needs reviewing here; a large diff is not evidence of good work, and a
   small one is not evidence of care.

## Verify

Two checks, both required.

**First, get a clean baseline, or the first check is worthless.** The comment-only
diff only proves anything if the pass is the *only* thing in the diff. Before
starting, commit the surrounding work (or snapshot the files elsewhere) so there
is something to diff the pass against. Running the check against a working tree
that already carries unrelated edits prints those edits as false positives and
tells you nothing. If you skipped this and cannot isolate the pass, say so and
rely on the behaviour check alone rather than reporting a verification you did
not actually perform.

**The diff is comment-only.** Every changed line must be a comment or blank:

```bash
git diff -U0 -- <files> \
  | grep -E '^[+-]' | grep -vE '^(\+\+\+|---)' \
  | grep -vE '^[+-]\s*(//|/\*|\*|\*/|#)' \
  | grep -vE '^[+-]\s*$'
```

Empty output means the pass was clean. Any line printed is executable code you
changed by accident: revert it. This misses a trailing comment removed from the
end of a code line, so read those hunks yourself.

**Behaviour is unchanged.** Run the project's typecheck and test suite. They were
passing before the pass; anything red now is something you broke. A comment pass
that needs a test updated is not a comment pass.

## Report

- Comment lines removed, per file.
- Every comment kept, with its one-line reason.
- Every comment corrected because it was wrong, with what it claimed versus what
  the code does.
- Anything left alone because it was out of scope.
