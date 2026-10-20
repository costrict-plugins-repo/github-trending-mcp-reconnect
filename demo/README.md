# Demo

`demo.gif` at the top of the project README walks through what
`mcp-reconnect --path Reconnect` does in 3 visible frames:

1. **/mcp menu open** — cursor (`❯`) on the default first action (`1. View tools`)
2. **Down keystroke** — cursor moves to `2. Reconnect` (the text-match navigation)
3. **Enter** — actual MCP server reconnect confirmed (`⎿  Reconnected to gitnexus.`)

The demo shows the key sequence manually so you can SEE the cursor scroll and
the selection happen. The same sequence is what the shipped binary automates
via `mcp-reconnect --path Reconnect <session>`.

Real demo: actual Claude Code v2.1.150 session in a project directory,
real `/mcp` menu, real reconnect of the real MCP server configured there
(in the captured recording, gitnexus). No simulation.

## How to rebuild

```bash
# Requirements: tmux, asciinema, agg, Claude Code installed.
cd demo
# Optional: point the demo session at a trusted project with an MCP server.
# Defaults to the current directory if unset.
# export DEMO_PROJECT_DIR=/path/to/your/project
./run_demo.sh                       # smoke-test (no recording)
asciinema rec --cols 110 --rows 30 \
    -c ./run_demo.sh \
    -t "mcp-reconnect v1.2.0 — cursor scroll + selection" \
    --overwrite demo.cast
agg --font-size 14 --speed 1.0 --theme monokai demo.cast demo.gif
```

## What `run_demo.sh` does

Spins a disposable Claude Code session in a fresh tmux pane (cwd
`$DEMO_PROJECT_DIR`, defaulting to the current directory — point it at a
project that is pre-trusted in `~/.claude.json` and has an MCP server in its
`.mcp.json`, so no trust-prompt handling is needed). Opens `/mcp` with `Escape` →
`/mcp` text → legacy `Enter` + Kitty-protocol CSI-u `Enter`. Captures
the menu state in Frame 1. Sends `Down`. Captures cursor moved in Frame 2.
Sends `Enter` + CSI-u `Enter`. Waits 8s for the real reconnect to fire.
Captures the confirmation in Frame 3.

Total recording: ~38 seconds.

## Why manual stepping instead of calling mcp-reconnect inside the recording

`mcp-reconnect`'s `cleanup_previous()` function kills any other
`bin/mcp-reconnect` processes via `pgrep -f`. When called from inside an
asciinema recording context, that pgrep matched the wrapper process chain
and sent SIGURG up the tree, killing the recording. The manual-step demo
emits the exact same key sequence the shipped binary produces (for the
single-server case — `Down` then `Enter`), so the demo is faithful to
what `mcp-reconnect --path Reconnect` does. If you want to verify the
binary works end-to-end, run it against a real session yourself — the
verbose logs print the cursor positions it navigates through.
