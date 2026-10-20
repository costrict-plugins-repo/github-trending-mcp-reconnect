#!/bin/bash
set -e
unset TMUX TMUX_PANE
stty cols 110 rows 30 2>/dev/null || true
SESS=ccmr-demo

# Project directory the demo Claude Code session runs in. Point this at any
# directory that has an MCP server configured in its .mcp.json (so the /mcp
# menu has something to reconnect). Defaults to the current working directory.
DEMO_PROJECT_DIR="${DEMO_PROJECT_DIR:-$PWD}"

echo "mcp-reconnect v1.2.0 — cursor scroll + selection demo"
sleep 1
tmux kill-session -t $SESS 2>/dev/null || true
sleep 0.3

echo
echo "\$ # spin Claude Code in tmux (cwd: $DEMO_PROJECT_DIR)"
tmux new-session -d -s $SESS -x 110 -y 30 -c "$DEMO_PROJECT_DIR"
tmux send-keys -t $SESS "claude --dangerously-skip-permissions" Enter
sleep 15

echo "\$ # open /mcp"
tmux send-keys -t $SESS "Escape"; sleep 1
tmux send-keys -t $SESS -l "/mcp"; sleep 0.3
tmux send-keys -t $SESS Enter; sleep 0.2
tmux send-keys -t $SESS -H 1b 5b 31 33 75
sleep 4

echo
echo "── FRAME 1: menu open, cursor on '1. View tools' ──"
tmux capture-pane -t $SESS -p | tail -24
sleep 2

echo
echo "\$ tmux send-keys Down  # cursor moves to next item"
tmux send-keys -t $SESS Down; sleep 0.8

echo "── FRAME 2: cursor on '2. Reconnect' ──"
tmux capture-pane -t $SESS -p | tail -24
sleep 2

echo
echo "\$ tmux send-keys Enter  # select"
tmux send-keys -t $SESS Enter; sleep 0.2
tmux send-keys -t $SESS -H 1b 5b 31 33 75
sleep 8

echo "── FRAME 3: actual reconnect confirmation ──"
tmux capture-pane -t $SESS -p | tail -24
sleep 3

echo
echo "## All of the above = mcp-reconnect --path Reconnect ccmr-demo"
echo "## (which reads ❯ cursor line, sends Down until it matches 'Reconnect', sends Enter)"
echo "## github.com/palios-taey/mcp-reconnect"
sleep 3

tmux kill-session -t $SESS 2>/dev/null || true
