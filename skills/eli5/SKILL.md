---
name: eli5
description: "Use when the user wants a from-scratch explanation of a thing (a PR, a diff, a module, a decision): 'explain X like I'm five', 'eli5', 'why are there so many changes in this PR', 'what does this PR/change/module actually do'."
license: MIT
---

# /eli5 - explain a thing from scratch

The user named a thing (a PR, a diff, a module, a decision, a concept) and wants to understand it the way a smart friend with no context would: what it is, what it is for, and why it looks the way it does.

This is not a simpler re-explanation of the previous answer: it is a fresh explanation of the thing the user named, written as if nothing had been said about it yet. You may read the thing (the diff, the PR body, the files) before answering. You may not invent: every claim traces to something you read or something already said in this conversation.

## Shape

Flat prose, casual and direct ("ok so", "basically", "the point is"). No headers. One short numbered list is allowed for the goals; everything else is sentences. Answer in the language the user wrote in.

1. **One sentence: what the thing does that was not true before.** Lead with the outcome someone would notice, not the mechanism.
2. **The goals, as a short numbered list.** Each goal is one line a non-engineer could repeat: what problem it removes or what it makes possible. Two to five items. If the thing has one goal, say so in a sentence instead of a list.
3. **Why it is as big (or as small) as it is.** This is the part people actually ask for. Name the pattern: "one change repeated in every place that did X by hand", "one new piece plus the wiring at each caller", "mostly tests", "mostly text cleanup found along the way". Then list the files or areas grouped by that pattern, so the size stops looking like noise. Keep the names verbatim.
4. **What it deliberately does not do**, in one or two sentences, and where that work lives instead if you know.

## Rules

- **Facts survive verbatim.** Every path, filename, command, number, URL, name and decision stays exactly as it appears in the source. Simplify the explanation around the facts, never the facts.
- **Mechanism only when it explains a why.** Name a function, table or file when it is the answer to "where does that happen" or "why is this file in the diff". Never as decoration.
- **Distinguish what you read from what you infer.** If you are guessing at intent, say "I think" once and move on. Never present a guess as the author's stated goal.
- **No new work.** Do not review, do not suggest changes, do not score. If you notice a problem, one sentence at the end, clearly marked as an aside, and nothing more.
- **Length follows clarity.** Cut preamble, hedging and recaps; keep every sentence that removes a possible misunderstanding. Do not pad to look thorough, do not trim a needed sentence to look short.
- **Edge case:** if the named thing cannot be found (no such PR, file or message), say so in one line and ask which one they meant.
