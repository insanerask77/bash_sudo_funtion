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

# Check if .bashrc exists
if [ ! -f "$BASHRC_FILE" ]; then
    echo "$BASHRC_FILE does not exist. Nothing to do." >&2
    exit 1
fi

# Check if autosudo is installed
if grep -qF "$AUTOSUDO_BEGIN_MARKER" "$BASHRC_FILE"; then
    # Remove the autosudo block
    sed -i.autosudo.tmp "/$AUTOSUDO_BEGIN_MARKER/,/$AUTOSUDO_END_MARKER/d" "$BASHRC_FILE"
    # Check if sed command was successful by seeing if the temp file was created (sed only creates it if it makes changes)
    # However, sed -i without extension on Linux might behave differently than on macOS regarding the temp file.
    # A more robust check is to grep again for the marker.
    if ! grep -qF "$AUTOSUDO_BEGIN_MARKER" "$BASHRC_FILE"; then
        echo "autosudo successfully uninstalled from $BASHRC_FILE."
        echo "Please source your $BASHRC_FILE or open a new terminal for changes to take effect."
        if [ -f "$BACKUP_FILE" ]; then
            echo "A backup of your original .bashrc was found at $BACKUP_FILE."
            echo "You can manually restore it if needed: cp $BACKUP_FILE $BASHRC_FILE"
        fi
        # Clean up temporary file if created by sed (platform dependent)
        rm -f "$BASHRC_FILE.autosudo.tmp"
    else
        echo "Error: Failed to remove autosudo block from $BASHRC_FILE. Please check the file manually." >&2
        # Attempt to restore from the temp file if it exists, as -i might have made partial changes
        if [ -f "$BASHRC_FILE.autosudo.tmp" ]; then
             mv "$BASHRC_FILE.autosudo.tmp" "$BASHRC_FILE"
        fi
        exit 1
    fi
else
    echo "autosudo markers not found in $BASHRC_FILE. It seems autosudo is not installed."
fi
