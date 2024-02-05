#!/usr/bin/env bash

# https://github.com/ThePrimeagen/.dotfiles/blob/master/bin/.local/scripts/tmux-sessionizer
# Filename: ~/github/dotfiles-latest/tmux/tools/tmux-sessionizer.sh
# Remember to make this file executable
# Filename: ~/github/dotfiles-latest/tmux/tools/linkarzu/tmux-sshonizer-agen.sh

# Check if one argument is being provided
if [[ $# -eq 1 ]]; then
	# Use the provided argument as the selected directory
	SSH_NAME=$1
elif [[ $# -eq 0 ]]; then
	# Explicitly specified 0 in case someone decides to pass more than 1 argument
	# Call the ssh-select script which will open fzf to select a host
	~/github/dotfiles-latest/tmux/tools/linkarzu/ssh-select.sh
	# Debugging, uncomment below if you need to see what's being selected
	# tmux display-message -d 10000 "Directory selected via fzf: $SSH_NAME"
else
	# This will hopefully catch your attention
	tmux display-message -d 500 "This script expects zero or one argument."
	sleep 1
	tmux display-message -d 500 "This script expects zero or one argument."
	sleep 1
	tmux display-message -d 5000 "This script expects zero or one argument."
fi

# Add 'ssh' to beginning of name for easier identification
# SELECTED_NAME=$SSH_NAME
SELECTED_NAME="ssh-$SSH_NAME"
# Debugging below
# tmux display-message -d 3000 "SSH_NAME: $SSH_NAME"
# sleep 3
# tmux display-message -d 3000 "SELECTED_NAME: $SELECTED_NAME"

###############################################################################
# I commented this section, uncomment if needed
# I don't need to check if tmux is running, because by default, when I open
# my terminal, tmux opens
###############################################################################

# # Check if tmux is currently running by looking for its process
# tmux_running=$(pgrep tmux)
# # If tmux is not running and the TMUX environment variable is not set, start a new tmux session with the selected directory
# if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
# 	# I included quotes in "$SSH_NAME" because wasn't changing to dirs that have a space
# 	# Like the iCloud dir
# 	tmux new-session -s $SSH_NAME_name -c "$SSH_NAME"
# 	exit 0
# fi

###############################################################################

# If a tmux session with the desired name does not already exist, create it in detached mode
if ! tmux has-session -t=$SELECTED_NAME 2>/dev/null; then
	# I included quotes in "$SSH_NAME" because wasn't changing to dirs that have a space
	# Like the iCloud dir
	tmux new-session -s "$SELECTED_NAME" -d "ssh $SSH_NAME"
fi

# Switch to the tmux session with the name derived from the selected directory
tmux switch-client -t $SELECTED_NAME