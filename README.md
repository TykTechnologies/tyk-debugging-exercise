# Tyk Troubleshooting Exercise

Welcome, and thanks for taking the time. This is **not a test of Tyk-specific
knowledge** — everything you need is discoverable from logs, error output, and
the public docs. We want to see *how you debug*.

## The scenario

A customer, **Initech**, handed us this stack and said:

> "Our gateway won't stay up, and even when it does, our analytics dashboard is
> empty. Can you fix it?"

Your job: **get the stack healthy and prove that API traffic flows end-to-end.**

## What's in the box

A Docker Compose stack:

| Service | Role |
|---|---|
| `tyk-gateway` | The API gateway (port `8080`) |
| `tyk-pump` | Ships analytics from the gateway into the database |
| `redis` | Gateway's data store |
| `postgres` | Where analytics land (`tyk_analytics` db, user/pass `tyk`/`tyk`) |
| `httpbin` | A dummy upstream the API proxies to |

The gateway proxies `GET /initech/` → the `httpbin` upstream.

## Getting started

The stack is already running (and already broken). Useful commands:

```bash
docker compose ps                     # what's up / crash-looping
docker compose logs -f tyk-gateway    # gateway logs
docker compose logs -f tyk-pump       # pump logs
docker compose restart tyk-gateway    # reload after a config change
docker compose up -d                  # bring everything back up
```

Config you can edit lives in `./conf/`.

## What "done" looks like

1. A request through the gateway succeeds:
   ```bash
   curl -i http://localhost:8080/initech/get
   # expect HTTP 200
   ```
2. That request shows up in the analytics database:
   ```bash
   docker compose exec postgres \
     psql -U tyk -d tyk_analytics -c "SELECT count(*) FROM tyk_analytics;"
   # expect a non-zero count (give the pump ~10s to flush)
   ```

## Ground rules

- **Use AI however you like** — Copilot, ChatGPT, Claude, anything. Just narrate
  what you're doing and why as you go.
- Docs are fair game: https://tyk.io/docs/
- ~30 minutes. It's fine if you don't finish — we care about your approach.
