# bash_sudo_funtion
A simple function to add sudo to the beginning of the command by double pressing ESC


## Install in Linux Generic

```bash
wget -qN https://github.com/insanerask77/bash_sudo_funtion/blob/main/bash_sudo_funtion.sh
chmod +x ./bash_sudo_funtion.sh
source ~/.bashrc
rm ./bash_sudo_funtion.sh
```

## How to use

 Press key "ESC" two times to add sudo in the beginning of the command.

 ## How to unistall

 Remove the lane created in ~/.bashrc

 ```bash
nano ~/.bashrc
delete this lane "bind -x '"\e\e": READLINE_LINE="sudo $READLINE_LINE"; READLINE_POINT=$((READLINE_POINT + 5))'"
save file
source ~/.bashrc
```
