#!/usr/bin/env zsh

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Starship prompt
eval "$(starship init zsh)"

# Disabling beep
unsetopt BEEP

# History
HISTFILE="$ZDOTDIR/cache/.histfile"
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# Ignore failed commands
zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }

# Tab Completions
autoload -Uz compinit
zstyle ':completion:*' menu select
#case insensitive completion
zstyle ':completion:*' matcher-list '' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zmodload zsh/complist
compinit -d "$ZDOTDIR/cache/.zcompdump"
_comp_options+=(globdots)

# Aliases
alias ls='ls --color=auto'
[ -z  $EDITOR ] && EDITOR=nano
alias zshrc="$EDITOR ~/.config/zsh/.zshrc"

# Adding tab completions to autosuggestions
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=150
#ZSH_AUTOSUGGEST_HISTORY_IGNORE="{cd} *"
ZSH_AUTOSUGGEST_STRATEGY=(completion) #comment it if you think it is slowing down

# Loading plugins
source "$ZPLUGDIR_X/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
source "$ZPLUGDIR_X/zsh-history-substring-search/zsh-history-substring-search.zsh"
source "$ZPLUGDIR_X/zsh-autosuggestions/zsh-autosuggestions.zsh"

# Key bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Launching fortune
fortune
