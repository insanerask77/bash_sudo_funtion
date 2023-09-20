#!/bin/bash

# Comando one-liner para insertar "sudo" al principio de la línea de comandos
command_to_insert='bind -x '"'"'"\e\e": READLINE_LINE="sudo $READLINE_LINE"; READLINE_POINT=$((READLINE_POINT + 5))'"'">

# Verificar si el comando ya existe en .bashrc
if ! grep -qF "$command_to_insert" ~/.bashrc; then
    echo "$command_to_insert" >> ~/.bashrc
    echo "Command inserted in en ~/.bashrc"
else
    echo "The command already exists in ~/.bashrc, no changes have been made."
fi
