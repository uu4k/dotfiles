# .zshrc - interactive shell 用
# PATH / 環境変数は .zprofile を参照

# anyenv -> rbenv / nodenv
command -v anyenv >/dev/null && eval "$(anyenv init -)"
command -v rbenv  >/dev/null && eval "$(rbenv init -)"
command -v nodenv >/dev/null && eval "$(nodenv init -)"

# zsh-completions(補完機能)の設定
# HOMEBREW_PREFIX は .zprofile の brew shellenv が設定する
# (旧設定は Intel 前提の /usr/local/share/zsh-completions を見ており一度も発火していなかった)
if [ -n "${HOMEBREW_PREFIX}" ]; then
    [ -d "$HOMEBREW_PREFIX/share/zsh-completions" ] && \
        fpath=("$HOMEBREW_PREFIX/share/zsh-completions" $fpath)
    [ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ] && \
        fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" $fpath)
fi
autoload -U compinit
compinit -u

# prompt
# git-prompt.sh は install.sh が ~/.zsh へ取得する。
# 取得に失敗していてもプロンプトが壊れないようフォールバックする
setopt PROMPT_SUBST
if [ -r ~/.zsh/git-prompt.sh ]; then
    source ~/.zsh/git-prompt.sh
    GIT_PS1_SHOWDIRTYSTATE=true
    GIT_PS1_SHOWUNTRACKEDFILES=true
    GIT_PS1_SHOWSTASHSTATE=true
    GIT_PS1_SHOWUPSTREAM=auto
    PS1='%F{green}%n@%m%f: %F{cyan}%~%f %F{red}$(__git_ps1 "(%s)")%f\$ '
else
    PS1='%F{green}%n@%m%f: %F{cyan}%~%f\$ '
fi

# history
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

# 同時に起動しているzshの間でhistoryを共有する
setopt share_history

# 同じコマンドをhistoryに残さない
setopt hist_ignore_all_dups

# スペースから始まるコマンドをhistoryに残さない
setopt hist_ignore_space

# historyに保存するときに余分なスペースを削除する
setopt hist_reduce_blanks

# 高機能なワイルドカード展開を使用する
setopt extended_glob

# コマンドのスペルミスを指摘
setopt correct
