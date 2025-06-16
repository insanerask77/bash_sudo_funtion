# Bash AutoSudo :smiling_imp:

A simple bash function to automatically prepend `sudo` to your current command line by pressing the `Esc` key twice.

This script modifies your `~/.bashrc` file to add this functionality.

**Important:** These scripts are designed for `bash`. Ensure you are running them in a bash environment.

## Installation

The installation script will:
- Check if you're running it with `bash`.
- Create `~/.bashrc` if it doesn't exist.
- Back up your existing `~/.bashrc` to `~/.bashrc.autosudo.bak` before making changes.
- Add the autosudo function, clearly marked, to your `~/.bashrc`.

Choose one of the methods below:

**Method 1: One-liner with `curl`**

Execute the following command in your bash terminal:

```bash
curl -sSL https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/bash_sudo_function.sh | bash
```
*(Note: Please verify the URL if the repository location changes.)*

**Method 2: `wget`**

```bash
wget https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/bash_sudo_function.sh
chmod +x bash_sudo_function.sh
bash ./bash_sudo_function.sh
# rm ./bash_sudo_function.sh # Optional: remove the script after installation
```

After installation, you **must** source your `~/.bashrc` file or open a new terminal session for the changes to take effect:
```bash
source ~/.bashrc
```

## Usage :book:

Once installed and your `~/.bashrc` is sourced:
1. Type any command in your terminal.
2. Press the `Esc` key twice.
3. `sudo ` will be prepended to your command line, and your cursor will be positioned after `sudo `.

Example:
If you type `apt update` and then press `Esc` `Esc`, your command line will change to `sudo apt update`.

## Uninstallation

The uninstallation script will:
- Check if you're running it with `bash`.
- Attempt to safely remove the autosudo block from your `~/.bashrc`.
- Inform you if a backup (`~/.bashrc.autosudo.bak`) exists.

Choose one of the methods below:

**Method 1: One-liner with `curl`**
```bash
curl -sSL https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/uninstall_autosudo.sh | bash
```
*(Note: Please verify the URL if the repository location changes.)*

**Method 2: `wget`**
```bash
wget https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/uninstall_autosudo.sh
chmod +x uninstall_autosudo.sh
bash ./uninstall_autosudo.sh
# rm ./uninstall_autosudo.sh # Optional: remove the script after uninstallation
```

After uninstallation, you **must** source your `~/.bashrc` file or open a new terminal session for the changes to take effect:
```bash
source ~/.bashrc
```

### Manual Uninstallation

If you prefer to uninstall manually or if the script fails:
1. Open your `~/.bashrc` file with a text editor (e.g., `nano ~/.bashrc`).
2. Look for the block of text starting with `# BEGIN AUTOSUDO - DO NOT EDIT THIS LINE` and ending with `# END AUTOSUDO - DO NOT EDIT THIS LINE`.
3. Delete this entire block, including the begin and end marker lines.
4. Save the file.
5. Source your `~/.bashrc` or open a new terminal.

If you have a backup at `~/.bashrc.autosudo.bak`, you can also restore it using:
```bash
cp ~/.bashrc.autosudo.bak ~/.bashrc
source ~/.bashrc
```
