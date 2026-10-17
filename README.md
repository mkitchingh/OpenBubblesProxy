# OpenBubblesProxy

A small self-hosted proxy that restores self-hosted OpenBubbles phone-number
registration using your own relay iPhone ([JJTech's ValidationRelay](https://github.com/JJTech0130/ValidationRelay)).

## How it works

Apple now rejects the identity the relay reports at the activation step. This
proxy sits between the OpenBubbles app and your registration relay and
rewrites the two fields Apple checks there (serial + UDID). Everything else
passes through untouched, so registration and phone-number setup work again.
No devices are hardcoded: each relay iPhone gets its own identity, generated
and remembered automatically.

## Quick start (Docker + Cloudflare Tunnel)

1. Cloudflare Zero Trust -> Networks -> Tunnels -> create a tunnel, copy the
   token, and add a Public Hostname pointing at `HTTP -> ob-profile-proxy:8080`.
2. `cp .env.example .env` and set `TUNNEL_TOKEN`.
3. `docker compose up -d --build`
4. In OpenBubbles, set the relay URL to your `https://<hostname>` and enter
   the code shown on your iPhone's ValidationRelay app.

Bare Python (no Docker): `python proxy.py` — standard library only.

## Rules

- Never edit, delete, or copy `data/registry.json` entries between
  deployments. It maps each iPhone to the identity Apple activated exactly once.
- Re-registering the same phone? Delete its registry entry first so a
  fresh identity is issued. The old registration is then abandoned.
- Keep the proxy online — renewals fetch validation data through it.
- Keep the relay iPhone online with ValidationRelay connected (display on,
  signed out of Apple ID, iMessage/FaceTime off — per the
  [official docs](https://openbubbles.app/docs/pnr.html)).

## Notes

- `sign-data` returning 401 in the logs is normal; the app falls back
  automatically.
- Apple can change its rules at any time; this is the same category of
  interoperability behavior as the client apps themselves.
