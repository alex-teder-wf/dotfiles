---
name: alex-markdown-view
description: Render and serve local .md files. Use when user asks to write, render, view or preview a Markdown document.
---

# Markdown view

Generate the requested markdown document and make it available through the local preview server.

## Storage

Use `/tmp/alex-markdown-view/` directory on this machine.

## Procedure

1. `mkdir -p /tmp/alex-markdown-view`.
2. If `/tmp/alex-markdown-view/index.html` is missing, copy it from this skill's folder.
3. Put the `.md` file in the storage dir: write it there directly, or `cp` it in if it already exists elsewhere on disk.
4. Check the server is up and serving the right directory: `curl -s localhost:8765/index.html`. If it fails, start it (see below).
5. Output the preview URL: `http://127.0.0.1:8765/index.html?file=<filename>.md`.

## Start server

Run in the background, do not wait on it: `python3 -m http.server 8765 --bind 127.0.0.1 --directory /tmp/alex-markdown-view`

## Considerations

- Don't narrate this process to the user — only surface it if something goes wrong.
- Never bind the server to `0.0.0.0`; loopback only.
- Filenames: lowercase, always hyphen-separated.
- Ask before overwriting an unrelated existing document in the storage dir.
