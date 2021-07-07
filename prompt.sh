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
# If not running interactively, don't do anything
[[ \$- != *i* ]] && return


# Lines configured by zsh-newuser-install
HISTFILE=./.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename './.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall


# Custom Script
alias ls='ls --color=auto'
eval "\$(starship init zsh)"
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
fortune
EOM
