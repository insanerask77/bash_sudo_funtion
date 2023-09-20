Intert into ~/.bashrc

bind -x '"\e\e": READLINE_LINE="sudo $READLINE_LINE"; READLINE_POINT=$((READLINE_POINT + 5))'

source ~/.bashrc
