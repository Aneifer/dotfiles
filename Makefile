.SHELLFLAGS := -eu -o pipefail -c
MAKEFLAGS += --warn-undefined-variables
SHELL = /bin/bash
.SUFFIXES:

dotfiles = .bash_profile \
        .gitconfig \
        .oh-my-zsh/custom/themes/afirth.zsh-theme \
        .tmux.conf \
        .vimrc \
        .zshrc
links := $(patsubst %,$(HOME)/%,$(dotfiles))

apt := /usr/bin/apt-fast
curl := /usr/bin/curl
git-creds := /usr/share/doc/git/contrib/credential/libsecret/git-credential-libsecret
golang := /usr/local/bin/go
oh-my-zsh := $(HOME)/.oh-my-zsh/oh-my-zsh.sh
tmux := /usr/bin/tmux
vim := /usr/bin/vim
xinitrc := $(HOME)/.xinitrc
zsh := /usr/bin/zsh
zsh-auto := $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions

.PHONY: all
all: $(oh-my-zsh) $(zsh-auto) $(links) $(golang) gcloud $(git-creds) $(vim) $(tmux) $(curl) $(apt)

.PHONY: gcloud
gcloud: $(curl)
	echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] http://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
	curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key --keyring /usr/share/keyrings/cloud.google.gpg add -
	$(apt) install -y google-cloud-sdk
	echo "run gcloud init"

.PHONY: capslock
# so you can use the keyboard
capslock: $(xinitrc)

# TODO
#https://askubuntu.com/questions/1102641/run-a-command-on-start-up-please
#https://bbs.archlinux.org/viewtopic.php?id=189989
$(xinitrc):
	$(warning this does not work reliably, use gnome-tweaks)
	echo setxkbmap -option caps:swapescape > $@
	source $@

## GOLANG
GO_VERSION := 1.14
$(golang): /usr/local/go
	sudo ln -fs /usr/local/go/bin/go /usr/local/bin

/usr/local/go: | $(curl)
	curl -fsSL https://dl.google.com/go/go$(GO_VERSION).linux-amd64.tar.gz | sudo tar -C /usr/local -xvz

# install vim-gtk3
# it's already aliased to vi in zshrc
$(vim):
	which vim || $(apt) -y install vim-gtk3

$(tmux):
	which tmux || $(apt) -y install tmux
	git clone https://github.com/tmux-plugins/tpm $(HOME)/.tmux/plugins/tpm

## dotfile links
# depends on zsh because otherwise zsh install breaks
.PHONY: dotfiles
dotfiles: $(links) | $(zsh)

$(links): $(HOME)/%: %
	@mkdir -p $(@D)
	ln -fsr $< $@

$(git-creds): | $(apt)
	$(apt) install -y libsecret-1-0 libsecret-1-dev
	sudo $(MAKE) -C /usr/share/doc/git/contrib/credential/libsecret

## ZSH
### oh-my-zsh
$(oh-my-zsh): | $(zsh) $(curl)
	curl -Lo /tmp/install.sh https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
	-sh /tmp/install.sh --unattended
	rm /tmp/install.sh
	# will be replaced by link
	rm $(HOME)/.zshrc

### zsh-auto-suggestions
$(zsh-auto): $(oh-my-zsh)
	git clone https://github.com/zsh-users/zsh-autosuggestions $(HOME)/.oh-my-zsh/custom/plugins/zsh-autosuggestions

### zsh itself
$(zsh): | $(apt)
	$(apt) install -y zsh
	chsh -s /usr/bin/zsh
	@echo Logout and back in to use zsh

## curl
$(curl): | $(apt)
	$(apt) install -y curl

## Apt-fast
$(apt):
	sudo add-apt-repository -y ppa:apt-fast/stable
	sudo apt-get update
	sudo apt-get -y install apt-fast
