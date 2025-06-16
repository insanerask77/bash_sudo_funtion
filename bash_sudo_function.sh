#!/bin/bash

# Check if running in bash
if [ -z "$BASH_VERSION" ]; then
    echo "This script is intended to be run with bash. Exiting." >&2
    exit 1
fi

AUTOSUDO_BEGIN_MARKER="# BEGIN AUTOSUDO - DO NOT EDIT THIS LINE"
AUTOSUDO_END_MARKER="# END AUTOSUDO - DO NOT EDIT THIS LINE"
COMMAND_TO_INSERT='bind -x '"'"'"\e\e": READLINE_LINE="sudo $READLINE_LINE"; READLINE_POINT=$((READLINE_POINT + 5))'"'"

# Create ~/.bashrc if it doesn't exist
if [ ! -f ~/.bashrc ]; then
    touch ~/.bashrc
    echo "Created ~/.bashrc as it did not exist."
fi

# Check if autosudo is already installed
if grep -qF "$AUTOSUDO_BEGIN_MARKER" ~/.bashrc && grep -qF "$COMMAND_TO_INSERT" ~/.bashrc && grep -qF "$AUTOSUDO_END_MARKER" ~/.bashrc; then
    echo "autosudo is already installed in ~/.bashrc. No changes have been made."
else
    # Create a backup of .bashrc
    cp ~/.bashrc ~/.bashrc.autosudo.bak
    echo "Backed up ~/.bashrc to ~/.bashrc.autosudo.bak"

    # Remove existing autosudo block if present (to handle partial/old installations)
    sed -i "/$AUTOSUDO_BEGIN_MARKER/,/$AUTOSUDO_END_MARKER/d" ~/.bashrc

    # Append the new autosudo block
    echo "$AUTOSUDO_BEGIN_MARKER" >> ~/.bashrc
    echo "$COMMAND_TO_INSERT" >> ~/.bashrc
    echo "$AUTOSUDO_END_MARKER" >> ~/.bashrc
    echo "autosudo installed successfully in ~/.bashrc."
    echo "Please source your ~/.bashrc or open a new terminal to use it."
fi
