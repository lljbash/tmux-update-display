#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
tmux set-hook -g client-attached "run-shell $CURRENT_DIR/scripts/tmux-update-display.sh"
