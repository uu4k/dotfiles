#!/bin/bash
GITHUB_URL=https://github.com/uu4k/dotfiles
DOTPATH=~/.dotfiles

if [ -e $DOTPATH ]; then
    cd $DOTPATH
    git pull
else
    if which -s git; then
        git clone --recursive "$GITHUB_URL" "$DOTPATH"

    elif which -s curl || has "wget"; then
        tarball="$GITHUB_URL/archive/master.tar.gz"

        if has "curl"; then
            curl -L "$tarball"

        elif has "wget"; then
            wget -O - "$tarball"

        fi | tar zxv

        mv -f dotfiles-master "$DOTPATH"

    else
        die "curl or wget required"
    fi

    cd $DOTPATH
fi

if [ $? -ne 0 ]; then
    die "not found: $DOTPATH"
fi

for f in .??*
do
    [ "$f" = ".git" ] && continue

    ln -snfv "$DOTPATH/$f" "$HOME/$f"
done

# instal xcode command line tools
xcode-select --install > /dev/null 2>&1

# install homebrew
which -s brew || /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

brew bundle
