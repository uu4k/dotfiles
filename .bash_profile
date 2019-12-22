eval "$(nodenv init -)"

export PATH="$PATH:~/development/flutter/bin"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

eval "$(rbenv init -)"

source /usr/local/etc/bash_completion.d/git-prompt.sh

export PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$ '

