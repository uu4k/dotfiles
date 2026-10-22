#!/bin/zsh
# uu4k/dotfiles installer
#   curl -fsSL "https://raw.githubusercontent.com/uu4k/dotfiles/master/install.sh" | zsh
#
# 実行順: repo 取得 -> macOS 前提 -> Homebrew -> brew bundle -> symlink -> 言語環境

GITHUB_URL=https://github.com/uu4k/dotfiles
DOTPATH="$HOME/.dotfiles"

die()  { print -u2 -- "error: $*"; exit 1 }
warn() { print -u2 -- "warn: $*" }

# ---------------------------------------------------------------- repo 取得 --
if [ -d "$DOTPATH/.git" ]; then
    git -C "$DOTPATH" pull --ff-only || die "git pull failed in $DOTPATH"
else
    command -v git >/dev/null || die "git required. run: xcode-select --install"
    git clone "$GITHUB_URL" "$DOTPATH" || die "git clone failed"
    # cd より先に実行すると呼び出し元の repo を書き換えてしまうので clone 済みパスを明示する
    git -C "$DOTPATH" remote set-url origin git@github.com:uu4k/dotfiles.git
fi

cd "$DOTPATH" || die "not found: $DOTPATH"

# ------------------------------------------------------------ macOS 前提 --
# Xcode command line tools
xcode-select --install > /dev/null 2>&1
sudo xcodebuild -license accept

# Rosetta 2 (Intel バイナリ用。Apple は将来的に縮小予定)
sudo softwareupdate --install-rosetta --agree-to-license

# -------------------------------------------------------------- Homebrew --
if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" \
        || die "homebrew install failed"
fi
for _brew in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    [ -x "$_brew" ] && { eval "$("$_brew" shellenv)"; break }
done
unset _brew
command -v brew >/dev/null || die "brew not on PATH"

# 1st pass: formula / cask / mas / vscode を入れる。
# npm エントリは node 未導入の初回では失敗するため、言語環境構築後に 2nd pass を回す
brew bundle --file="$DOTPATH/Brewfile" || warn "brew bundle (1st pass): 失敗したエントリあり"

# --------------------------------------------------------------- symlink --
# repo 直下の dotfile を $HOME へ張る
for f in .??*; do
    case "$f" in
        .git|.gitignore|.claude|.DS_Store) continue ;;
    esac
    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

# Claude Code: ~/.claude には Claude 自身の状態ファイルがあるのでファイル単位で張る
mkdir -p "$HOME/.claude"
for f in .claude/*(N); do
    [ -e "$f" ] || continue
    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

# XDG / アプリ固有の設定 (repo では config/ 配下。先頭が . ではないので上のループに拾われない)
mkdir -p "$HOME/.config/git"
ln -snfv "$DOTPATH/config/git/ignore" "$HOME/.config/git/ignore"

GHOSTTY_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty"
mkdir -p "$GHOSTTY_DIR"
ln -snfv "$DOTPATH/config/ghostty/config" "$GHOSTTY_DIR/config"

# zsh prompt (git 本体の contrib から取得)
mkdir -p "$HOME/.zsh"
curl -fsSL -o "$HOME/.zsh/git-prompt.sh" \
    https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh \
    || warn "git-prompt.sh の取得に失敗。プロンプトは git 情報なしで動作します"

source "$HOME/.zprofile"

# --------------------------------------------------------- 言語環境 (anyenv) --
command -v anyenv >/dev/null || die "anyenv not found (Brewfile を確認)"
eval "$(anyenv init -)"

[ -d "$HOME/.config/anyenv/anyenv-install" ] || anyenv install --init

anyenv envs | grep -qx rbenv  || anyenv install rbenv
anyenv envs | grep -qx nodenv || anyenv install nodenv
eval "$(anyenv init -)"

# バージョンは ruby-build / node-build の定義で入手可能な最新。
# 新しい版が見えない場合は `brew upgrade ruby-build node-build` の後に再実行する
RUBY_VERSION=3.4.6    # 3.2 系は 2026-03 EOL
NODE_VERSION=24.9.0   # 現 LTS

rbenv install -s "$RUBY_VERSION" && rbenv global "$RUBY_VERSION"
nodenv install -s "$NODE_VERSION" && nodenv global "$NODE_VERSION"
nodenv rehash

# terraform は brew の formula が BUSL 移行で 1.5.7 凍結・deprecated なので tfenv で管理する
if command -v tfenv >/dev/null; then
    tfenv install latest && tfenv use latest
fi

# 2nd pass: node が入ったので Brewfile の npm グローバルを回収する
brew bundle --file="$DOTPATH/Brewfile" || warn "brew bundle (2nd pass): 失敗したエントリあり"

print -- "done. 新しいシェルを開いてください: exec \$SHELL -l"
