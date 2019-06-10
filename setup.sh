#!/usr/bin/env bash

# TODO this should probably be a makefile instead. one day

# @afirth 2019
# sets up my ubuntu 18 terminal, more or less

set -eux -o pipefail

# install zsh and oh-my-zsh
set +x
which zsh || sudo apt-get update && sudo apt-get -y install zsh
test -f $HOME/.oh-my-zsh/oh-my-zsh.sh || instal_oh_my_zsh
set -x

# install vim-gtk3
# it's already aliased to vi in zshrc
which vim || sudo apt-get -y install vim-gtk3

#link selected files from this repo for ubuntu
FILES=".bash_profile
.gitconfig
.oh-my-zsh/custom
.vimrc
.zshrc"

set +e
for f in $FILES
do
	ln -sr $PWD/$f $HOME/$f
done
set -e

chsh -s /usr/bin/zsh

set +x echo Log out and log back in for chsh to take effect

install_oh_my_zsh () {
  curl -Lo install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
  sh install.sh --unattended
  rm install.sh
}
