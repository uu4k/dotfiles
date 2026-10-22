# dotfiles

macOS (Apple Silicon / Intel) 向け。`~/.dotfiles` に clone し、`$HOME` へ symlink を張る方式。

## インストール

```sh
curl -fsSL "https://raw.githubusercontent.com/uu4k/dotfiles/master/install.sh" | zsh
```

`install.sh` は冪等。実行順は repo 取得 → macOS 前提 (Xcode CLT / Rosetta) → Homebrew →
`brew bundle` → symlink → 言語環境 (anyenv / rbenv / nodenv / tfenv)。

## 構成

| パス | リンク先 | 備考 |
|---|---|---|
| `.zprofile` | `~/.zprofile` | PATH・環境変数 (brew shellenv, `$HOME/.local/bin`, `GPG_TTY`) |
| `.zshrc` | `~/.zshrc` | interactive 用 (anyenv init, 補完, プロンプト, history) |
| `.gitconfig` | `~/.gitconfig` | git-secrets / GPG 署名 / alias |
| `.git-templates/` | `~/.git-templates/` | git-secrets hooks (以後 init/clone する repo に適用) |
| `.claude/*` | `~/.claude/*` | Claude Code 設定。`~/.claude` には Claude 自身の状態があるためファイル単位でリンク |
| `config/git/ignore` | `~/.config/git/ignore` | global gitignore (`core.excludesfile`) |
| `config/ghostty/config` | `~/Library/Application Support/com.mitchellh.ghostty/config` | |
| `Brewfile` | — | brew / cask / mas / uv / npm / VS Code 拡張の一覧 |

`config/` は先頭が `.` でないため `install.sh` の `.??*` ループに拾われず、明示的にリンクされる。
`~/.zsh/git-prompt.sh` は git 本体の contrib から `install.sh` が取得する (repo には含めない)。

## Brewfile の更新

```sh
brew bundle check --file=~/.dotfiles/Brewfile --no-upgrade --verbose   # 差分確認
brew bundle dump  --describe --force --file=~/.dotfiles/Brewfile      # 実環境から再生成
```

`dump` は推移的依存や一時的に入れたアプリも吐くので、出力後に必ず再キュレーションする。

既にインストール済みのアプリを brew 管理下に取り込むときは `--adopt` を使う:

```sh
brew install --cask --adopt raycast
```

## 注意点

- `terraform` は brew formula が BUSL 移行に伴い 1.5.7 で凍結・deprecated なので、
  `tfenv` 管理にしている (`tfenv install latest`)。`tflint` は brew のまま。
- `cheatsheet` cask は brew で disabled (discontinued) のため Brewfile から除外。
- ruby / node のバージョンは `install.sh` の `RUBY_VERSION` / `NODE_VERSION` で固定。
  新しい版が `install -l` に出ない場合は `brew upgrade ruby-build node-build` 後に再実行する。

## 旧環境からの移行時の掃除

過去の `install.sh` のバグや削除済みファイルに由来する残骸。手動で消す。

```sh
rm -f ~/.CFUserTextEncoding                 # repo から消えたファイルを指す dangling symlink
rm -f "$HOME/.claude/*"                     # リテラル名 '*' の symlink (旧 glob 事故)
rm -f ~/.zsh_sessions/.zsh_sessions         # dangling
rm -f ~/.claude/statusline-command.sh.bk    # 孤児バックアップ
rm -f ~/.bash_profile                       # repo から削除済み (ログインシェルは zsh)
```
