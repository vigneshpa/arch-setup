#!/bin/sh -x

set -eo pipefail

# Arch linux  packages

depackages=( zsh starship zsh-syntax-highlighting zsh-autosuggestions fortune-mod )
depackages="${depackages[@]}"
sudo pacman -S $depackages --noconfirm

sudo usermod -s /bin/zsh $(whoami)

dot_files_dir="$HOME/.config/zsh"
mkdir -p $dot_files_dir

echo "export ZDOTDIR=~/.config/zsh" > ~/.zshenv

cat > "$dot_files_dir/.zshrc" <<- EOM
#!/usr/bin/env zsh

# If not running interactively, don't do anything
[[ \$- != *i* ]] && return

# History
HISTFILE="\$ZDOTDIR/.histfile"
HISTSIZE=1000
SAVEHIST=1000

# Tab Completions
autoload -Uz compinit
zstyle ':completion:*' menu select
#case insensitive completion
#zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit
_comp_options+=(globdots)

# Disabling beep
unsetopt BEEP

# Aliases
alias ls='ls --color=auto'

# Starship
eval "\$(starship init zsh)"

# Ignore failed commands
zshaddhistory() { whence \${\${(z)1}[1]} >| /dev/null || return 1 }

# Adding tab completions to autosuggestions
ZSH_AUTOSUGGEST_STRATEGY=(history completion) #comment it if you think it is slowing down

# Syntax highlition and auto completions
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Launching fortune
fortune
EOM
