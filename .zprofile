# .zprofile - login shell 用。PATH と環境変数はここに置く
# (interactive subshell ごとに再評価されるのを避けるため .zshrc からは分離)

# Homebrew (Apple Silicon: /opt/homebrew, Intel: /usr/local)
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [ -x "$_brew" ]; then
        eval "$("$_brew" shellenv)"
        break
    fi
done
unset _brew

# uv tool / spec-kit などが入れるユーザローカルの実行ファイル
# (入れ子のシェルや path_helper 経由で二重に入るのを防ぐ)
case ":$PATH:" in
    *":$HOME/.local/bin:"*) ;;
    *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

export EDITOR=vim

# gpg の pinentry が TTY を掴めるようにする
# (旧 .zshrc では `export GPG_TTY=\$(tty)` とエスケープされており、
#  実値がリテラル文字列 "$(tty)" になっていた)
export GPG_TTY=$(tty)
