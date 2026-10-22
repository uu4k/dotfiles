# Brewfile - uu4k/dotfiles
#
# usage:   brew bundle --file=~/.dotfiles/Brewfile
# check:   brew bundle check --file=~/.dotfiles/Brewfile --no-upgrade --verbose
# refresh: brew bundle dump --describe --force --file=~/.dotfiles/Brewfile
#          (dump は推移的依存や未使用アプリも吐くので、出力後に必ず再キュレーションする)
#
# tap は意図的に 0 行:
#   homebrew/bundle -> Homebrew 4 以降 brew 本体に統合済み
#   heroku/brew     -> 非推奨。heroku CLI は使っていないため install.sh からも削除

# --- version managers -------------------------------------------------------
brew "anyenv"
brew "rbenv"
brew "ruby-build"
brew "nodenv"
brew "node-build"
brew "tfenv"       # terraform 本体はこちらで管理する。
                   # brew の terraform formula は BUSL 移行に伴い 1.5.7 で凍結・deprecated

# --- CLI / dev tools --------------------------------------------------------
brew "git"
brew "gh"
brew "git-secrets"
brew "gibo"
brew "gnupg"
brew "jq"
brew "tree"
brew "wget"
brew "gcc"
brew "graphviz"
brew "awscli"
brew "tflint"
brew "uv"
brew "mas"
brew "zsh-completions"
brew "openssl@3", link: true
brew "yarn", args: ["ignore-dependencies"]   # node は nodenv 管理なので brew の node を引かせない

# --- databases --------------------------------------------------------------
brew "mysql@8.4"      # 旧: mysql@5.7 (2023-10 EOL / brew で deprecated="unsupported")
brew "postgresql@18"  # 旧: bare "postgresql"

# --- python -----------------------------------------------------------------
brew "python@3.14"    # 旧: メタ formula "python3"
brew "python@3.11"    # 既存プロジェクト向けに併存
                      # python@3.9 は EOL のため削除

# --- GUI apps ---------------------------------------------------------------
cask "ghostty"
cask "iterm2"
cask "visual-studio-code"
cask "claude-code"
cask "codex"
cask "docker-desktop"           # 旧 cask 名 "docker" からリネーム済み
cask "google-chrome"
cask "vivaldi"
cask "google-japanese-ime"
cask "slack"
cask "notion"
cask "raycast"                  # 旧: alfred
cask "rectangle"                # 旧: spectacle (開発終了)
cask "flux-app"                 # 旧 cask 名 "flux" からリネーム済み
cask "appcleaner"

# 意図的に除外したもの:
#   cheatsheet            brew で disabled (discontinued)。残すと brew bundle が失敗する
#   spectacle             開発終了 -> rectangle
#   sequel-pro-nightly    開発終了 -> mas "Sequel Ace"
#   google-backup-and-sync 提供終了 (代替が必要なら cask "google-drive")
#   alfred                raycast に移行
#   kindle honto rescuetime discord postman          長期未使用
#   unity unity-hub android-studio rubymine
#   displaylink ngrok dropbox                        重量級・用途限定。必要時に個別インストール

# --- Mac App Store ----------------------------------------------------------
mas "Xcode", id: 497799835
mas "Bear", id: 1091189122
mas "Sequel Ace", id: 1518036000      # sequel-pro-nightly の代替
mas "LINE", id: 539883307
mas "Keynote", id: 409183694
mas "Numbers", id: 409203825
mas "Pages", id: 409201541
mas "GarageBand", id: 682658836
mas "iMovie", id: 408981434
mas "Prime Video", id: 545519333
mas "RunCat", id: 1429033973
mas "Display Menu", id: 549083868
mas "Bluetooth MIDI Connect", id: 1074606480
# 除外: Pocket (2025-07 サービス終了) / TweetDeck (2023 廃止)

# --- language-level tools ---------------------------------------------------
uv "specify-cli", source: "git+https://github.com/github/spec-kit.git"
npm "corepack"
npm "@github/copilot"
npm "@google/gemini-cli"

# --- VS Code extensions -----------------------------------------------------
# 不要なものは行ごと削除してよい
vscode "anthropic.claude-code"
vscode "csharpier.csharpier-vscode"
vscode "google.gemini-cli-vscode-ide-companion"
vscode "google.geminicodeassist"
vscode "k--kato.intellij-idea-keybindings"
vscode "ms-azuretools.vscode-azure-github-copilot"
vscode "ms-azuretools.vscode-azure-mcp-server"
vscode "ms-azuretools.vscode-azureresourcegroups"
vscode "ms-azuretools.vscode-containers"
vscode "ms-azuretools.vscode-docker"
vscode "ms-ceintl.vscode-language-pack-ja"
vscode "ms-dotnettools.csharp"
vscode "ms-dotnettools.vscode-dotnet-runtime"
vscode "ms-python.debugpy"
vscode "ms-python.python"
vscode "ms-python.vscode-pylance"
vscode "ms-toolsai.jupyter"
vscode "ms-toolsai.jupyter-keymap"
vscode "ms-toolsai.jupyter-renderers"
vscode "ms-toolsai.vscode-jupyter-cell-tags"
vscode "ms-toolsai.vscode-jupyter-slideshow"
vscode "ms-vscode-remote.remote-containers"
vscode "ms-windows-ai-studio.windows-ai-studio"
vscode "pulkitgangwar.nextjs-snippets"
vscode "teamsdevapp.vscode-ai-foundry"
vscode "vscodevim.vim"
vscode "zhang-renyang.vscode-react"
