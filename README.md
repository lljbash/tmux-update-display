# tmux update $DISPLAY

Inspired by https://gist.github.com/mikeboiko/b6e50210b4fb351b036f1103ea3c18a9.

### The problem:

When you `ssh -X` into a machine and attach to an existing tmux session, the session contains the old $DISPLAY env variable.

In order the x-server/client to work properly, you have to update $DISPLAY after connection.

For example, the old $DISPLAY=:0 and you need to change to DISPLAY=localhost:10.0 for the ssh session to perform x-forwarding properly.

### The solution:

When attaching to tmux session, update $DISPLAY for each tmux pane in that session This is performed by using tmux send-keys to the shell.

This script handles updating $DISPLAY within vim also.

## Recommendation

Install [zsh-renew-tmux-env](https://github.com/lljbash/zsh-renew-tmux-env) for zsh users to update $DISPLAY silently.

## Installation
### Installation with [Tmux Plugin Manager](https://github.com/tmux-plugins/tpm) (recommended)

Add plugin to the list of TPM plugins in `.tmux.conf`:

```shell
set -g @plugin 'lljbash/tmux-update-display'
```

Hit `prefix + I` to fetch the plugin and source it.

### Manual Installation

Clone the repo:

```shell
$ git clone https://github.com/lljbash/tmux-update-display ~/clone/path
```

Add this line to the bottom of `.tmux.conf`:

```shell
run-shell ~/clone/path/update-display.tmux
```

Reload TMUX environment:

```shell
# type this in terminal
$ tmux source-file ~/.tmux.conf
```
