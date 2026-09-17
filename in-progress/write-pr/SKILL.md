---
name: write-pr
description: Use when writing or rewriting the description of a pull request, merge request or changelist, and when a description comes back as too long, too dense, jargon-heavy or hard to follow.
---

# Writing PR descriptions

## Overview

The reviewer already has the diff. A description that summarises the diff carries no information.

A description carries only what the diff cannot show: the mental model, the code that looks deletable but is load-bearing, the decisions a human made, and the scope boundary.

## The shape

Write these parts, in this order. No section headers.

**0. The ticket reference**, on its own first line, in whatever form the tracker links (`Closes ABC-123`).

**1. One paragraph.** The mental model, in this order: what the thing is, what it did before, what it does now, and the mechanism in one or two steps. Someone who has never opened this subsystem must be able to follow the bullets after reading it.

**2. Six to ten bullets, one fact each**, in this order: first the code that looks deletable but is load-bearing, then the decisions, then the boundary, then the verification. At ten, the reader is skimming, so keep the facts that survive the test below and drop the rest.

**3. At least one bullet for a decision a human made**: a cap, an exclusion, a default, a threshold, an ordering. These are invisible in the diff and expensive to rediscover in review. Load-bearing code is easier to find, so it fills the bullets first and starves this slot. Write this bullet before you fill the earlier ones.

**4. One bullet for what the change does NOT do.** Name the nearest thing a reader would expect and did not get: the UI for a capability that only exists in the API, the case still handled by hand, the follow-up. Write this one early too, for the same reason.

**5. A bullet for verification**: what passed, with real numbers.

## The first words of every bullet

Every bullet opens with the noun phrase that says what the subject is. The identifier follows the noun. This is the shape:

```
The <what it is> `<identifier>` <what it does>.
```

Openings that match the shape:

- The transform option `seriesValues` lists the four health statuses.
- The SQL column `secondaryValue` is selected right after `value`.
- The tool parameter `owners` matches a name exactly.
- The seed loader `generateCanvasWidgets` keeps a widget's datasources.

Nouns that place a subject: option, parameter, column, table, filter, check, component, function, route, job, transform, flag, default.

Read back the first three words of each bullet before you finish. If they are an identifier, the bullet needs its noun.

Backticks are not an explanation. Without the noun, the reader cannot tell a column from a parameter from a function.

## Which facts earn a bullet

Ask of each candidate: would the reviewer learn this by reading the diff?

- **Yes, so cut it.** "Adds a parameter, validated against the enum" is the diff read aloud.
- **No, so keep it.** Code whose removal fails silently. A cast, a guard or an order that prevents a wrong value. Two similar things kept separate on purpose, and the failure that follows merging them. A cap, an exclusion or a default that a human chose. A deliberate omission.

Prefer the fact whose absence would let a future reader delete working code as dead weight.

## Sentences

Under 25 words. One idea each. Active voice. Simple present. One word per concept, reused.

A sentence carrying a fact and its consequence is two sentences. State the fact, then state what happens without it.

Facts survive verbatim: paths, identifiers, numbers, names, URLs. Simplify the prose around a fact, never the fact.

## Quick reference

| Include | Cut |
|---|---|
| Why a line that looks pointless must stay | What the diff already shows |
| A cast or guard that prevents a silent wrong value | One section per file or per layer |
| Two similar things kept apart, and why | Links to plans or specs the reviewer cannot open |
| Caps, exclusions and defaults chosen by a human | Adjectives about quality ("robust", "clean") |
| What the change does not do | Restated commit messages |
| Test counts and check results | Narration of how the work went |

## Common mistakes

- **Organised by file or by layer.** That groups the diff, not the reviewer's questions.
- **Identifiers with no noun in front of them.** The reader stops to guess what the thing is.
- **The decisions are missing.** A cap of 12 rows, an excluded status: invisible in the diff, expensive in review.
- **No boundary.** The reviewer hunts for a feature that was never in scope.
- **Prose that argues.** Design debate belongs in the commit message or a comment thread. The description states.
