# skills

Emilia's personal skills, installable from several agents/harnesses.

Each skill is a folder under [`skills/`](skills/) with a `SKILL.md` (YAML frontmatter + instructions). The repo also ships the config files to work as a **Claude Code plugin marketplace**.

## Available skills

| Skill | What it does |
|---|---|
| [`notify`](skills/notify/SKILL.md) | Sends push notifications to the phone via [ntfy](https://ntfy.sh). |

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

Skills are namespaced: `/skills:notify`.

### Vercel skills.sh

```bash
npx skills add emiliacb/skills
```

Discovers `skills/<name>/SKILL.md` automatically.

### Hermes Agent

```bash
hermes skills install https://raw.githubusercontent.com/emiliacb/skills/main/skills/notify/SKILL.md
```

Or clone the repo into `~/.hermes/skills/` and Hermes auto-discovers the skills on startup.

### Pi

```bash
git clone git@github.com:emiliacb/skills.git ~/.pi/agent/skills/emiliacb-skills
```

(use `.pi/skills/` instead of `~/.pi/agent/skills/` for a per-project install). Load with `/skill:notify`.

## Layout

```
skills/                          # one folder serves all four installers
  notify/
    SKILL.md
.claude-plugin/
  marketplace.json               # marketplace catalog (Claude)
  plugin.json                    # plugin manifest (Claude)
.env.example                     # config template; the real .env is not versioned
```
