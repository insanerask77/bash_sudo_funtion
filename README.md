# bash_sudo_funtion (AutoSudo):smiling_imp:
A simple function to add sudo to the beginning of the command by double pressing ESC

#### This installation make a original backup of your `~/.bashrc` 
#### You can find it in `~/.bashrc_original`
## Manual Installation :writing_hand:
```bash
# Edit ~/.bashrc
nano ~/.bashrc
# Copy and Paste this lane into ~/.bashrc
bind -x '"\e\e": READLINE_LINE="sudo $READLINE_LINE"; READLINE_POINT=$((READLINE_POINT + 5))'
# Save file
# Execute this command
source ~/.bashrc

```

## Install in Linux Generic :alien:

```bash
wget -qN https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/bash_sudo_funtion.sh
chmod +x ./bash_sudo_funtion.sh
./bash_sudo_funtion.sh
source ~/.bashrc
rm ./bash_sudo_funtion.sh
```

## How to use :book:

 Press key "ESC" two times to add sudo in the beginning of the command.

## How to unistall :x:
### Auto Unistall
```bash
wget -qN https://raw.githubusercontent.com/insanerask77/bash_sudo_funtion/main/uninstall_autosudo.sh
chmod +x ./uninstall_autosudo.sh
./uninstall_autosudo.sh
source ~/.bashrc
rm ./uninstall_autosudo.sh
```
### Manual Unistall
 Remove the lane created in ~/.bashrc

 ```bash
# Edit ~/.bashrc
nano ~/.bashrc
# Delete this lane
bind -x '"\e\e": READLINE_LINE="sudo $READLINE_LINE"; READLINE_POINT=$((READLINE_POINT + 5))'
# Save file
# Execute this command
source ~/.bashrc
 ```
