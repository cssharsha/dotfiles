#!/usr/bin/env bash

while true; do
    # Get a list of current tmux sessions for the main menu.
    CURRENT_SESSIONS=$(tmux list-sessions -F '#S' 2>/dev/null)
    options="[ new session ]
[ kill session ]
${CURRENT_SESSIONS}"

    if [ -n "$TMUX" ]; then
        # INSIDE TMUX
        FZF_TMUX_OPTS="-p 80%,80%"
        CHOICE=$(echo -e "${options}" | fzf-tmux $FZF_TMUX_OPTS --prompt="Select tmux session > ")

        # Exit if no choice was made (e.g., ESC)
        if [[ -z "$CHOICE" ]]; then
            break
        fi

        case "$CHOICE" in
            "[ new session ]")
                tmux command-prompt -p "New Session Name: " "run-shell 'tmux new-session -s \"%%\" -d; tmux switch-client -t \"%%\"'"
                break # Exit loop after action
                ;;
            "[ kill session ]")
                SESSIONS_TO_KILL=$(tmux list-sessions -F '#S' 2>/dev/null)
                if [[ -z "$SESSIONS_TO_KILL" ]]; then
                    tmux display-message "No sessions to kill."
                    continue # Go to next loop iteration
                fi
                SESSION_TO_KILL=$(echo -e "${SESSIONS_TO_KILL}" | fzf-tmux $FZF_TMUX_OPTS --prompt='Kill session > ')
                if [[ -n "$SESSION_TO_KILL" ]]; then
                    tmux kill-session -t "$SESSION_TO_KILL"
                fi
                # After killing, loop continues to show the updated menu
                ;;
            *)
                tmux switch-client -t "$CHOICE"
                break # Exit loop after action
                ;;
        esac
    else
        # OUTSIDE TMUX
        FZF_DEFAULT_OPTS="--height 80% --layout=reverse --border"
        CHOICE=$(echo -e "${options}" | fzf $FZF_DEFAULT_OPTS --prompt="Select tmux session > ")

        # Exit if no choice was made (e.g., ESC)
        if [[ -z "$CHOICE" ]]; then
            break
        fi

        case "$CHOICE" in
            "[ new session ]")
                read -p "Enter new session name: " SESSION_NAME
                if [[ -n "$SESSION_NAME" ]]; then
                    tmux new-session -s "$SESSION_NAME"
                fi
                break # Exit loop after action
                ;;
            "[ kill session ]")
                SESSIONS_TO_KILL=$(tmux list-sessions -F '#S' 2>/dev/null)
                 if [[ -z "$SESSIONS_TO_KILL" ]]; then
                    echo "No sessions to kill."
                    sleep 1 # Give user time to see the message
                    continue # Go to next loop iteration
                fi
                SESSION_TO_KILL=$(echo -e "${SESSIONS_TO_KILL}" | fzf $FZF_DEFAULT_OPTS --prompt='Kill session > ')
                if [[ -n "$SESSION_TO_KILL" ]]; then
                    tmux kill-session -t "$SESSION_TO_KILL"
                fi
                # After killing, loop continues to show the updated menu
                ;;
            *)
                tmux attach-session -t "$CHOICE"
                break # Exit loop after action
                ;;
        esac
    fi
done
