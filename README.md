# AutoSudo

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
[![Bash](https://img.shields.io/badge/bash-3.0%2B-blue.svg)](https://www.gnu.org/software/bash/)
[![Shell: bash only](https://img.shields.io/badge/shell-bash%20only-lightgrey.svg)](#requirements)

Press **Esc Esc** to instantly prepend `sudo` to your current command line — no retyping, no copy-paste.

```
$ apt update        ← you type this
$ sudo apt update   ← after pressing Esc Esc
```

---

## Requirements

- **bash 3.0+** (the script does not support `sh`, `zsh`, `fish`, or other shells)
- A Unix-like system (Linux, macOS, WSL)

---

## Installation

The installer will:

1. Verify you are running **bash**.
2. Create `~/.bashrc` if it does not exist.
3. Back up your existing `~/.bashrc` to `~/.bashrc.autosudo.bak`.
4. Append the AutoSudo block, clearly delimited by markers, to `~/.bashrc`.

### One-liner (curl)

```bash
curl -sSL https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/install.sh | bash
```

### One-liner (wget)

```bash
wget -qO- https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/install.sh | bash
```

### Manual

```bash
git clone https://github.com/insanerask77/bash_sudo_funtion.git
cd bash_sudo_funtion
bash install.sh
```

### Activate

After installation, reload your shell configuration:

```bash
source ~/.bashrc
```

Or simply open a new terminal.

---

## Usage

1. Type any command in your terminal.
2. Press **Esc** twice.
3. `sudo ` is prepended and your cursor is repositioned after it.

| Before | After Esc Esc |
|--------|---------------|
| `apt update` | `sudo apt update` |
| `systemctl restart nginx` | `sudo systemctl restart nginx` |
| `nano /etc/hosts` | `sudo nano /etc/hosts` |

> If the command already starts with `sudo`, pressing Esc Esc has no effect.

---

## How it works

The installer appends the following block to `~/.bashrc`:

```bash
# BEGIN AUTOSUDO - DO NOT EDIT THIS BLOCK
_autosudo() {
    if [[ "$READLINE_LINE" != sudo\ * ]]; then
        READLINE_LINE="sudo $READLINE_LINE"
        READLINE_POINT=$(( READLINE_POINT + 5 ))
    fi
}
bind -x '"\e\e": _autosudo'
# END AUTOSUDO - DO NOT EDIT THIS BLOCK
```

`bind -x` maps the double-Escape sequence (`\e\e`) to the `_autosudo` shell function. The function modifies `READLINE_LINE` (the current input buffer) and advances `READLINE_POINT` (the cursor) by 5 characters — the length of `"sudo "`.

---

## Uninstallation

The uninstaller removes the AutoSudo block from `~/.bashrc` using the delimiters written at install time.

### One-liner (curl)

```bash
curl -sSL https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/uninstall.sh | bash
```

### One-liner (wget)

```bash
wget -qO- https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/uninstall.sh | bash
```

### Manual

```bash
bash uninstall.sh
```

Then reload your shell:

```bash
source ~/.bashrc
```

### Manual uninstallation (fallback)

Open `~/.bashrc` in any editor and delete the block between:

```
# BEGIN AUTOSUDO - DO NOT EDIT THIS BLOCK
```

and:

```
# END AUTOSUDO - DO NOT EDIT THIS BLOCK
```

including both marker lines. To restore the backup created at install time:

```bash
cp ~/.bashrc.autosudo.bak ~/.bashrc
source ~/.bashrc
```

---

## Contributing

Contributions, bug reports, and feature requests are welcome.

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/my-improvement`
3. Commit your changes: `git commit -m "feat: describe change"`
4. Push and open a Pull Request.

Please run [ShellCheck](https://www.shellcheck.net/) on any modified scripts before submitting.

---

## License

This project is licensed under the [MIT License](LICENSE).  
Copyright (c) 2024 insanerask77.
