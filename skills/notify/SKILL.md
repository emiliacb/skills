---
name: notify
description: Use when the user explicitly asks to be notified on their phone ("avisame al celular", "mandame un ntfy", "notify me"), when a long-running task, /goal, or background job completes or hits a blocker, or when the user invokes /notify. Do NOT use unprompted for routine work.
---

# Notify — push notification to phone via ntfy

Sends a push notification by publishing to an ntfy topic. The topic, server, and optional auth token are read from environment variables or from `~/.config/notify/.env`.

## Resolve config (always first)

```bash
TOPIC="${NTFY_TOPIC:-$(grep -sh '^NTFY_TOPIC=' ~/.config/notify/.env 2>/dev/null | tail -1 | cut -d= -f2-)}"
SERVER="${NTFY_SERVER:-https://ntfy.sh}"
TOKEN="${NTFY_TOKEN:-}"
[ -z "$TOPIC" ] && echo "NTFY_TOPIC not set. Copy .env.example to ~/.config/notify/.env and set the topic." && exit 1
```

With config resolved, publish using the helper script:

```bash
bash skills/notify/scripts/notify.sh "Title" "Message" [priority] [click-url]
```

Or with raw curl:

```bash
curl -H "Title: Title" -H "Priority: 3" -d 'Message' "$SERVER/$TOPIC"
```

## When to use

- A long-running task, background job, or goal completes or hits a blocker and the user is not actively watching.
- The user explicitly asks to be notified via ntfy / on their phone.
- **Never otherwise.** Do not send notifications for routine work.

## Message format

- Always set `Title:` to identify the thread/project: `[repo-or-topic] what happened`.
- Do not include the time: ntfy timestamps messages automatically.

Full example with the helper script:

```bash
bash skills/notify/scripts/notify.sh "[sonora-api] tests OK" \
  "Los 42 tests pasaron, PR listo para review" 4 \
  "https://github.com/org/repo/pull/42"
```

Or with raw curl (pass token if the topic is protected):

```bash
curl -H "Title: [sonora-api] tests OK" -H "Tags: white_check_mark" \
  -H "Priority: 4" -H "Click: https://github.com/org/repo/pull/42" \
  -H "Authorization: Bearer $TOKEN" \
  -d 'Los 42 tests pasaron, PR listo para review' \
  "$SERVER/$TOPIC"
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

## Screenshots and files

```bash
bash skills/notify/scripts/notify.sh "[topic] screenshot" "" 3 "" | curl -T screenshot.png \
  -H "Filename: screenshot.png" "$SERVER/$TOPIC"
```

Max 15 MB; the attachment expires on the server after ~3 h. Images show as a preview on the phone.

## Infallible notifications via hooks

Skills fire only when the model decides to use them. For guaranteed notifications on task completion (regardless of model routing), configure a platform hook instead. Example for Hermes `settings.json`:

```json
{
  "hooks": {
    "stop": [
      {
        "command": "bash skills/notify/scripts/notify.sh \"Hermes stopped\" \"Session ended\" 3",
        "platforms": ["all"]
      }
    ],
    "notification": [
      {
        "command": "bash skills/notify/scripts/notify.sh \"{{title}}\" \"{{message}}\" {{priority}}",
        "platforms": ["all"]
      }
    ]
  }
}
```

With hooks the phone pings every time — no skill invocation needed. Use the skill when the user explicitly asks; use hooks when the notification must be deterministic.

## On failure

If the curl fails (timeout, network error), retry once. If it still fails, do not insist: report the notification in the conversation and continue.

## Priority — quick guide

- **5 + `Tags: rotating_light`**: something broke and needs action now.
- **4**: something the user was waiting on finished (long build, deploy, /goal completed).
- **3 (default)**: informational notice that was explicitly requested.
- **1-2**: almost never; only for an explicitly silent notification.
