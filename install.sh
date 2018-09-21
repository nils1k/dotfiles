#!/bin/sh

echo "Setting up your Mac..."

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (see Brewfile)
brew bundle

# Make ZSH the default shell environment
chsh -s $(which zsh)

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
echo "Symlinking dotfiles to the home directory"

rm -rf $HOME/.zshrc
ln -s $HOME/.dotfiles/.zshrc $HOME/.zshrc

for file in $( ls -A | grep -vE '\.exclude*|\.git$|\.gitignore|.*.md|Brewfile' ) ; do
  $targetFile = "$PWD/$file"

  if [ -f "$targetFile" ]
  then
    rm -f "$targetFile"
  fi

  # TODO: Command for removing all broken symlinks here...?

  ln -sv "$PWD/$file" "$HOME"
done

echo "Symlinking complete"

# Set macOS preferences
# We will run this last because this will reload the shell
source .macos