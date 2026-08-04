#!/usr/bin/env bash
# =============================================================================
# AutoSudo — Uninstaller
# =============================================================================
# Removes the AutoSudo block from ~/.bashrc.
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
}

has_begin_marker() { grep -qF "$BEGIN_MARKER" "$BASHRC" 2>/dev/null; }
has_end_marker()   { grep -qF "$END_MARKER"   "$BASHRC" 2>/dev/null; }

# ── Core operations ────────────────────────────────────────────────────────────
remove_block() {
    local tmp
    tmp=$(mktemp)
    sed "/$BEGIN_MARKER/,/$END_MARKER/d" "$BASHRC" > "$tmp"
    mv "$tmp" "$BASHRC"
}

offer_restore() {
    if [[ -f "$BACKUP" ]]; then
        info "A backup exists at $BACKUP"
        printf "  Restore it with: ${C_BOLD}cp $BACKUP $BASHRC && source $BASHRC${C_RESET}\n"
    fi
}

# ── Entry point ────────────────────────────────────────────────────────────────
main() {
    check_bash

    printf "\n${C_BOLD}AutoSudo v${VERSION} — Uninstaller${C_RESET}\n"
    printf "%s\n\n" "───────────────────────────────────────"

    [[ -f "$BASHRC" ]] || die "$BASHRC not found. Nothing to uninstall."

    if ! has_begin_marker && ! has_end_marker; then
        warn "AutoSudo markers not found in $BASHRC. It may already be uninstalled."
        offer_restore
        exit 0
    fi

    if has_begin_marker && ! has_end_marker; then
        die "BEGIN marker found but END marker is missing in $BASHRC.\n" \
            "       Please inspect the file manually and remove the AutoSudo block."
    fi

    if ! has_begin_marker && has_end_marker; then
        die "END marker found but BEGIN marker is missing in $BASHRC.\n" \
            "       Please inspect the file manually and remove the AutoSudo block."
    fi

    remove_block

    # Verify the block was actually removed
    if has_begin_marker; then
        die "Failed to remove AutoSudo block from $BASHRC. Please check the file manually."
    fi

    ok "AutoSudo removed from $BASHRC"
    printf "\n${C_BOLD}Activate the change:${C_RESET}\n"
    printf "  source ~/.bashrc\n\n"
    offer_restore
    printf "\n"
}

main "$@"
