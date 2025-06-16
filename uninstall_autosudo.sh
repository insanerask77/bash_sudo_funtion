#!/bin/bash

# Check if running in bash
if [ -z "$BASH_VERSION" ]; then
    echo "This script is intended to be run with bash. Exiting." >&2
    exit 1
fi

AUTOSUDO_BEGIN_MARKER="# BEGIN AUTOSUDO - DO NOT EDIT THIS LINE"
AUTOSUDO_END_MARKER="# END AUTOSUDO - DO NOT EDIT THIS LINE"
BASHRC_FILE=~/.bashrc
BACKUP_FILE=~/.bashrc.autosudo.bak
COMMAND_HINT="bind -x '\"\e\e\": READLINE_LINE=\"sudo \$READLINE_LINE\"; READLINE_POINT=\$((\$READLINE_POINT + 5))'"

# Check if .bashrc exists
if [ ! -f "$BASHRC_FILE" ]; then
    echo "$BASHRC_FILE does not exist. Nothing to do." >&2
    exit 1
fi

# Check for markers
has_begin_marker=$(grep -qF "$AUTOSUDO_BEGIN_MARKER" "$BASHRC_FILE" && echo true || echo false)
has_end_marker=$(grep -qF "$AUTOSUDO_END_MARKER" "$BASHRC_FILE" && echo true || echo false)

if $has_begin_marker && $has_end_marker; then
    # Both markers are present, proceed with normal uninstallation
    sed -i.autosudo.tmp "/$AUTOSUDO_BEGIN_MARKER/,/$AUTOSUDO_END_MARKER/d" "$BASHRC_FILE"

    # Verify removal
    if ! grep -qF "$AUTOSUDO_BEGIN_MARKER" "$BASHRC_FILE"; then
        echo "autosudo successfully uninstalled from $BASHRC_FILE."
        echo "Please source your $BASHRC_FILE or open a new terminal for changes to take effect."
        if [ -f "$BACKUP_FILE" ]; then
            echo "A backup of your original .bashrc was found at $BACKUP_FILE."
            echo "You can manually restore it if needed: cp $BACKUP_FILE $BASHRC_FILE"
        fi
        rm -f "$BASHRC_FILE.autosudo.tmp"
    else
        echo "Error: Failed to remove autosudo block from $BASHRC_FILE. Please check the file manually." >&2
        if [ -f "$BASHRC_FILE.autosudo.tmp" ]; then
             mv "$BASHRC_FILE.autosudo.tmp" "$BASHRC_FILE" # Attempt to restore
        fi
        exit 1
    fi
elif $has_begin_marker; then
    # Only BEGIN marker is present, indicating a corrupted installation
    echo "Warning: autosudo BEGIN marker found in $BASHRC_FILE, but the END marker is missing." >&2
    echo "This indicates a potentially corrupted installation or manual modification." >&2
    echo "Please inspect $BASHRC_FILE manually and remove the autosudo entry." >&2
    echo "The autosudo entry typically looks like: $COMMAND_HINT" >&2
    echo "You might also find lines starting with '$AUTOSUDO_BEGIN_MARKER'." >&2
    exit 1
else
    # Neither marker is present (or only END marker, which we treat as not installed)
    echo "autosudo markers not found in $BASHRC_FILE. It seems autosudo is not installed."
fi
