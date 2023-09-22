#!/bin/bash

command_to_insert='bind -x '"'"'"\e\e": READLINE_LINE="sudo $READLINE_LINE"; READLINE_POINT=$((READLINE_POINT + 5))'"'"

if ! grep -qF "$command_to_insert" ~/.bashrc; then
    echo "Funtion not installed in ~/.bashrc"
else
    echo "AutoSudo Uninstalled"
    line=$(cat ~/.bashrc | grep bind)
    cat ~/.bashrc | grep -vF "$line" > ~/.bashrc_un
    mv ~/.bashrc ~/.bashrc_bkp
    mv ~/.bashrc_un ~/.bashrc

fi
