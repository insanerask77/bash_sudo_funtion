#!/usr/bin/env bash
# =============================================================================
# AutoSudo — Installer
# =============================================================================
# Press Esc Esc to prepend 'sudo' to the current command line in bash.
#
# MIT License
# Copyright (c) 2024 insanerask77
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# =============================================================================

set -euo pipefail

# ── Constants ──────────────────────────────────────────────────────────────────
readonly VERSION="2.0.0"
readonly BASHRC="${HOME}/.bashrc"
readonly BACKUP="${HOME}/.bashrc.autosudo.bak"
readonly BEGIN_MARKER="# BEGIN AUTOSUDO - DO NOT EDIT THIS BLOCK"
readonly END_MARKER="# END AUTOSUDO - DO NOT EDIT THIS BLOCK"

# ── Colors (disabled when output is not a terminal) ───────────────────────────
if [[ -t 1 ]]; then
    C_RED='\033[0;31m'; C_GREEN='\033[0;32m'; C_YELLOW='\033[1;33m'
    C_CYAN='\033[0;36m'; C_BOLD='\033[1m'; C_RESET='\033[0m'
else
    C_RED=''; C_GREEN=''; C_YELLOW=''; C_CYAN=''; C_BOLD=''; C_RESET=''
fi

# ── Logging ────────────────────────────────────────────────────────────────────
info()  { printf "${C_CYAN}[INFO]${C_RESET}  %s\n"   "$*"; }
ok()    { printf "${C_GREEN}[OK]${C_RESET}    %s\n"   "$*"; }
warn()  { printf "${C_YELLOW}[WARN]${C_RESET}  %s\n"  "$*"; }
die()   { printf "${C_RED}[ERROR]${C_RESET} %s\n" "$*" >&2; exit 1; }

# ── Guards ─────────────────────────────────────────────────────────────────────
check_bash() {
    [[ -n "${BASH_VERSION:-}" ]] \
        || die "This script requires bash. Run it with: bash $0"
    (( BASH_VERSINFO[0] >= 3 )) \
        || die "bash 3.0+ is required. Current version: ${BASH_VERSION}"
}

is_installed() {
    grep -qF "$BEGIN_MARKER" "$BASHRC" 2>/dev/null
}

# ── Core operations ────────────────────────────────────────────────────────────
backup_bashrc() {
    cp "$BASHRC" "$BACKUP"
    ok "Backup saved → $BACKUP"
}

remove_existing_block() {
    local tmp
    tmp=$(mktemp)
    sed "/$BEGIN_MARKER/,/$END_MARKER/d" "$BASHRC" > "$tmp"
    mv "$tmp" "$BASHRC"
}

write_autosudo_block() {
    # Single-quoted EOF prevents variable expansion: the block is written
    # literally so that $READLINE_LINE/$READLINE_POINT expand at shell runtime,
    # not at install time.
    cat >> "$BASHRC" << 'EOF'

# BEGIN AUTOSUDO - DO NOT EDIT THIS BLOCK
# AutoSudo v2.0.0 — https://github.com/insanerask77/bash_sudo_funtion
# Press Esc Esc to prepend 'sudo' to the current command line.
_autosudo() {
    if [[ "$READLINE_LINE" != sudo\ * ]]; then
        READLINE_LINE="sudo $READLINE_LINE"
        READLINE_POINT=$(( READLINE_POINT + 5 ))
    fi
}
bind -x '"\e\e": _autosudo'
# END AUTOSUDO - DO NOT EDIT THIS BLOCK
EOF
}

# ── Entry point ────────────────────────────────────────────────────────────────
main() {
    check_bash

    printf "\n${C_BOLD}AutoSudo v${VERSION} — Installer${C_RESET}\n"
    printf "%s\n\n" "─────────────────────────────────────"

    # Create ~/.bashrc if it doesn't exist yet
    if [[ ! -f "$BASHRC" ]]; then
        touch "$BASHRC"
        info "Created $BASHRC"
    fi

    if is_installed; then
        warn "AutoSudo is already installed in $BASHRC. Nothing to do."
        printf "\n  Run ${C_BOLD}source ~/.bashrc${C_RESET} if the shortcut isn't active yet.\n\n"
        exit 0
    fi

    backup_bashrc
    remove_existing_block   # clean up any stale partial install
    write_autosudo_block

    ok "AutoSudo installed in $BASHRC"
    printf "\n${C_BOLD}Activate it now:${C_RESET}\n"
    printf "  source ~/.bashrc\n\n"
    printf "${C_BOLD}Usage:${C_RESET}\n"
    printf "  Type any command and press ${C_BOLD}Esc Esc${C_RESET} to prepend 'sudo'\n"
    printf "  Example: type ${C_CYAN}apt update${C_RESET}, press Esc Esc → ${C_CYAN}sudo apt update${C_RESET}\n\n"
}

main "$@"
