# skills

Emilia's personal skills, installable from four agent harnesses.

A skill is a folder under [`skills/`](skills/) holding a `SKILL.md`: YAML frontmatter plus instructions. The repo also ships the config files that make it a **Claude Code plugin marketplace**.

## Skills

| Skill | What it does |
|---|---|
| [`eli5`](skills/eli5/SKILL.md) | Explains a thing (a PR, a diff, a module, a decision) from scratch, in plain language. |

## Drafts

[`in-progress/`](in-progress/) holds skills that are still being written: `delegate`, `notify`, `prune-comments`, `reduce-complexity` and `write-pr`.

The Claude Code plugin publishes only `skills/`, so it never installs them. The two installers that clone the whole repo, Hermes and Pi, discover every `SKILL.md` inside it, drafts included.

## Installation

### Claude Code

```
/plugin marketplace add emiliacb/skills
/plugin install skills@emiliacb
```

Installed skills are namespaced: `/skills:eli5`.

### Vercel skills

```bash
npx skills add emiliacb/skills
```

See the [Agent Skills docs](https://vercel.com/docs/agent-resources/skills) for how the CLI resolves a GitHub source.

### Hermes Agent

```bash
hermes skills install https://raw.githubusercontent.com/emiliacb/skills/main/skills/eli5/SKILL.md
```

That installs a single skill from its URL. Cloning the repo into `~/.hermes/skills/` instead makes Hermes discover every `SKILL.md` in it on startup.

### Pi

```bash
git clone https://github.com/emiliacb/skills.git ~/.pi/agent/skills/emiliacb-skills
```

Use `.pi/skills/` instead of `~/.pi/agent/skills/` for a per-project install. Skills load as `/skill:eli5`.

## Layout

```
skills/
  eli5/
    SKILL.md
in-progress/
  delegate/
    SKILL.md
    agents/
  notify/
    SKILL.md
    scripts/
  prune-comments/
    SKILL.md
  reduce-complexity/
    SKILL.md
    references/
  write-pr/
    SKILL.md
.claude-plugin/
  marketplace.json
  plugin.json
.env.example                     # config template for notify; the real .env is not versioned
LICENSE
```
