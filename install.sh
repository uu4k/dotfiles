#!/bin/zsh
GITHUB_URL=https://github.com/uu4k/dotfiles
DOTPATH=~/.dotfiles

if [ -e $DOTPATH ]; then
    cd $DOTPATH
    git pull
else
    if which -s git; then
        git clone --recursive "$GITHUB_URL" "$DOTPATH"
        git remote set-url origin git@github.com:uu4k/dotfiles.git

    	cd $DOTPATH
    elif which -s curl || has "wget"; then
        tarball="$GITHUB_URL/archive/master.tar.gz"

        if has "curl"; then
            curl -L "$tarball"

        elif has "wget"; then
            wget -O - "$tarball"

        fi | tar zxv

        mv -f dotfiles-master "$DOTPATH"

    	cd $DOTPATH
    else
        die "curl or wget required"
    fi
fi

if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

# zsh
mkdir ~/.zsh
curl -o ~/.zsh/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
source ~/.zprofile

# instal xcode command line tools
xcode-select --install > /dev/null 2>&1
sudo xcodebuild -license accept

# Rosetta 2
sudo softwareupdate --install-rosetta

# install homebrew
which -s brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle

# anyenv
anyenv init
anyenv install --init
anyenv install rbenv
anyenv install nodenv
# exec $SHELL -l

# install heroku plugin
heroku plugins:install heroku-config

# install nodejs
nodenv install -s 10.16.3
nodenv global 10.16.3

# instal vue
# yarn cache clean
yarn global add @vue/cli

