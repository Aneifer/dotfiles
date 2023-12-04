# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:${HOME}/.local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="afirth"

## zsh options
# always start in tmux
export ZSH_TMUX_AUTOSTART=true
# change autosuggest color for solarized dark
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=60'


# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  asdf
  common-aliases
  git
  tmux
  vi-mode
  z # fast dir switching
  zsh-autosuggestions # fish style autocomplete
)

DISABLE_MAGIC_FUNCTIONS=true #BUG https://stackoverflow.com/questions/25614613/how-to-disable-zsh-substitution-autocomplete-with-url-and-backslashes
source $ZSH/oh-my-zsh.sh

# Preferred editor for local and remote sessions
 if [[ -n $SSH_CONNECTION ]]; then
   export EDITOR='vim'
 else
   export EDITOR='nvim'
 fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# bindings for pgup/pgdown during autocomplete
bindkey "^[[5~" history-beginning-search-backward
bindkey "^[[6~" history-beginning-search-forward

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#

alias zzz="systemctl suspend -i"
alias ll='ls -laht'
#preserve aliases in watch commands. can't pass args though
alias wat='watch '

alias xc='xclip -sel clip'

alias afiy='apt-fast install -y'
alias pkzs='pkill zoom; pkill slack'

alias history='omz_history -i'

## theme switching
light_theme='NumixSolarizedLightBlue'
dark_theme='NumixSolarizedDarkBlue'
function switch_gtk_theme() {
  # get current theme
  current_theme=$(gsettings get org.gnome.desktop.interface gtk-theme \
    | sed 's/[^a-zA-Z0-9]//g')
  case $current_theme in
    $light_theme)
      gsettings set org.gnome.desktop.interface gtk-theme $dark_theme
      ;;
    $dark_theme)
      gsettings set org.gnome.desktop.interface gtk-theme $light_theme
      ;;
  esac
}
alias bgt='switch_gtk_theme'


# git branch creation
unalias gcb
function gcb {
  git checkout -b `date +%F`-"$1"
}

alias vi='nvim'
alias drsh='docker run --rm -it --entrypoint=sh'

#git overrides
alias gl='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'
alias gcm='git commit -m'

alias gfin='echo -n Fixed in $(git rev-parse --short HEAD) | xclip -sel clip'

## HISTORY
# unsetopt share_history
## prepend lines with space to keep them from being recorded
setopt hist_ignore_space
export HISTSIZE=100000
export SAVEHIST=HISTSIZE

## don't complete long lines
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=40
## and be faster
export ZSH_AUTOSUGGEST_USE_ASYNC=true


## magical regex globs
setopt extendedglob


# term prefs -> profiles -> show bold text in bright colors
zle_highlight=(default:bold)
# if [ ! "$TMUX" = "" ]; then export TERM=xterm-256color; fi #https://github.com/zsh-users/zsh-autosuggestions/issues/229


fpath=($fpath ~/.zsh/completion)
autoload -U compinit
compinit

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/an/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/an/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/an/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/an/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

