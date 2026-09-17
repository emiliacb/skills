# skills

Emilia's personal skills, installable from several agents/harnesses.

Each published skill is a folder under [`skills/`](skills/) with a `SKILL.md` (YAML frontmatter + instructions). The repo also ships the config files to work as a **Claude Code plugin marketplace**.

## Available skills

| Skill | What it does |
|---|---|
| [`eli5`](skills/eli5/SKILL.md) | Explains a thing (a PR, a diff, a module, a decision) from scratch, in plain language. |

## In progress

Drafts under [`in-progress/`](in-progress/). They are **not** picked up by any of the installers below — every harness discovers `skills/<name>/SKILL.md` and looks nowhere else. Move a folder into `skills/` to publish it.

| Skill | What it does |
|---|---|
| [`notify`](in-progress/notify/SKILL.md) | Sends push notifications to the phone via [ntfy](https://ntfy.sh). |
| [`prune-comments`](in-progress/prune-comments/SKILL.md) | Deletes comments that do not earn their place, in a comment-only diff. |
| [`reduce-complexity`](in-progress/reduce-complexity/SKILL.md) | Per-line complexity reduction pass over the current branch's diff. |
| [`write-pr`](in-progress/write-pr/SKILL.md) | Writes a PR description that carries what the diff cannot show. |

## Setup (for the `notify` skill)

The ntfy topic is **not stored in the repo**. Configure it once:

```bash
mkdir -p ~/.config/notify
cp .env.example ~/.config/notify/.env
# edit ~/.config/notify/.env and set your topic
```

The skill reads `NTFY_TOPIC` from the environment variable or from `~/.config/notify/.env`.

## Installation

### Claude Code (plugin marketplace)

```
/plugin marketplace add emiliacb/skills
/plugin install skills@emiliacb
```

Skills are namespaced: `/skills:eli5`.

### Vercel skills.sh

```bash
npx skills add emiliacb/skills
```

Discovers `skills/<name>/SKILL.md` automatically.

### Hermes Agent

```bash
hermes skills install https://raw.githubusercontent.com/emiliacb/skills/main/skills/eli5/SKILL.md
```

Or clone the repo into `~/.hermes/skills/` and Hermes auto-discovers the skills on startup.

### Pi

```bash
git clone git@github.com:emiliacb/skills.git ~/.pi/agent/skills/emiliacb-skills
```

(use `.pi/skills/` instead of `~/.pi/agent/skills/` for a per-project install). Load with `/skill:eli5`.

## Layout

```
skills/                          # published; one folder serves all four installers
  eli5/
    SKILL.md
in-progress/                     # drafts; not discovered by any installer
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
  marketplace.json               # marketplace catalog (Claude)
  plugin.json                    # plugin manifest (Claude)
.env.example                     # config template for notify; the real .env is not versioned
```
