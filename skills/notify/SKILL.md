---
name: notify
description: Use when Emilia explicitly asks to be notified on her phone ("avisame al celular", "mandame un ntfy", "notify me"), when /goal is active and there is a completion, blocker, or result to report, or when the user invokes /notify. Do NOT use unprompted for routine work.
---

# Notify — push notification to phone via ntfy

Sends a push notification by publishing to an ntfy topic. The topic is **not hardcoded**: it is read from the `NTFY_TOPIC` environment variable or from `~/.config/notify/.env`.

## Resolve the topic (always first)

```bash
TOPIC="${NTFY_TOPIC:-$(grep -sh '^NTFY_TOPIC=' ~/.config/notify/.env | tail -1 | cut -d= -f2-)}"
[ -z "$TOPIC" ] && echo "NTFY_TOPIC not set. Copy .env.example to ~/.config/notify/.env and set the topic." && exit 1
```

With `$TOPIC` resolved, publish:

```bash
curl -d 'message' "https://ntfy.sh/$TOPIC"
```

## When to use

- `/goal` is active and there is something to report (task finished, blocker, result).
- The user explicitly asks to be notified via ntfy / on their phone.
- **Never otherwise.** Do not send notifications for routine work.

## Message format

- Always set `Title:` to identify the thread/project: `[repo-or-topic] what happened`.
- Do not include the time: ntfy timestamps messages automatically.

Full example:

```bash
TOPIC="${NTFY_TOPIC:-$(grep -sh '^NTFY_TOPIC=' ~/.config/notify/.env | tail -1 | cut -d= -f2-)}"
curl -H "Title: [sonora-api] tests OK" -H "Tags: white_check_mark" -H "Priority: 4" \
  -H "Click: https://github.com/org/repo/pull/42" \
  -d 'Los 42 tests pasaron, PR listo para review' \
  "https://ntfy.sh/$TOPIC"
```

## Available headers

| Header | Use |
|---|---|
| `Title: ...` | Title; identifies the project/thread |
| `Tags: robot,warning` | Emoji shortcodes: `white_check_mark`, `x`, `warning`, `tada`, `rotating_light`, `robot` |
| `Priority: 1-5` | 3 default, 4 important, 5 urgent (distinct sound), 1-2 silent |
| `Click: https://...` | URL opened when tapping the notification (PR, dashboard, doc) |
| `Markdown: yes` | Renders the message body as markdown |
| `Actions: view, Label, https://url` | Action buttons (view/http/copy; separate multiple with `;`) |
| `At: tomorrow, 10am` / `In: 30m` | Scheduled delivery (10 s to 3 days) |

## Screenshots and files

```bash
TOPIC="${NTFY_TOPIC:-$(grep -sh '^NTFY_TOPIC=' ~/.config/notify/.env | tail -1 | cut -d= -f2-)}"
curl -T screenshot.png -H "Filename: screenshot.png" -H "Title: [topic] screenshot" \
  "https://ntfy.sh/$TOPIC"
```

Max 15 MB; the attachment expires on the server after ~3 h. Images show as a preview on the phone.

## On failure

If the curl fails (timeout, network error), retry once. If it still fails, do not insist: report the notification in the conversation and continue.

## Priority — quick guide

- **5 + `Tags: rotating_light`**: something broke and needs action now.
- **4**: something the user was waiting on finished (long build, deploy, /goal completed).
- **3 (default)**: informational notice that was explicitly requested.
- **1-2**: almost never; only for an explicitly silent notification.
