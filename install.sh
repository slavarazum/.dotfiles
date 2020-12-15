#!/bin/sh

echo "Awesome Mac setup running..."

if [ -f .env ]; then
source .env
fi

git config --global user.name $GIT_NAME
git config --global user.email $GIT_EMAIL

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle

# Create MySQL user for local development
mysql -u root < create-valet-user.sql

# Install PHP evnironment
echo 'PHP environment installation'
echo '-----------------'
source php_setup.sh

# Create a Sites directory
mkdir $HOME/Development
mkdir $HOME/Development/code

$HOME/.composer/vendor/bin/valet park $HOME/Development/code

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm $HOME/.zshrc
ln -s $HOME/.dotfiles/shell/.zshrc $HOME/.zshrc

# Symlink the Mackup config file to the home directory
ln -s $HOME/.dotfiles/shell/.mackup.cfg $HOME/.mackup.cfg

# Symlink the MySQL config file to the home directory
ln -s $HOME/.dotfiles/shell/.my.cnf $HOME/.my.cnf

# Add global gitignore
ln -s $HOME/.dotfiles/shell/.global-gitignore $HOME/.global-gitignore
git config --global core.excludesfile $HOME/.global-gitignore

echo 'Install oh-my-zsh'
echo '-----------------'
rm -rf $HOME/.oh-my-zsh
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo 'Install oh-my-zsh spaceship prompt'
echo '-----------------'
git clone https://github.com/denysdovhan/spaceship-prompt.git "$HOME/.dotfiles/oh-my-zsh-custom/themes/spaceship-prompt" --depth=1
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"

echo 'Setup MacOS defaults'
echo '-----------------'
source macos-defaults.sh
