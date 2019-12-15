eval "$(nodenv init -)"

export PATH="$PATH:~/development/flutter/bin"

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"

eval "$(rbenv init -)"
