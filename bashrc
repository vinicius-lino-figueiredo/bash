# shellcheck shell=bash
# ~/.bash/bashrc — config universal de bash

# Só shells interativos
[[ $- != *i* ]] && return

### ---[ Diretório base ]-------------------------------------------------------

BASH_DIR="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

### ---[ PATH ]-----------------------------------------------------------------

export GOPATH="$HOME/go"
PATH="$HOME/.local/share/mise/shims:$GOPATH/bin:$PATH"
PATH="$HOME/bin/:$PATH"
PATH="$HOME/usr/bin/:$PATH"
PATH="$HOME/usr/sbin/:$PATH"

### ---[ Variáveis ]------------------------------------------------------------

export EDITOR=nvim
export LESS=-R
export HISTSIZE=50000
export HISTFILESIZE=50000
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_history
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }history -a; history -n"
shopt -s histappend

### ---[ Prompt ]---------------------------------------------------------------

__git_branch() {
    git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null
}

PS1='\[\033[1;37m\]\A '
PS1+='\[$([ $? -eq 0 ] && echo "\033[0;32m" || echo "\033[0;31m")\]󰣚 '
PS1+='\[\033[1;36m\]\W'
PS1+='$(branch=$(__git_branch); [ -n "$branch" ] && echo " \[\033[0;37m\]git:(\[\033[0;91m\]$branch\[\033[0;37m\])\[\033[0m\]")'
PS1+='\[\033[0m\] \$ '

### ---[ fzf ]------------------------------------------------------------------

# Key-bindings instalados pelo mise (arquivo estático, sem eval)
FZF_KEYBINDINGS="$HOME/.local/share/mise/installs/fzf/latest/shell/key-bindings.bash"
[[ -f "$FZF_KEYBINDINGS" ]] && source "$FZF_KEYBINDINGS"

### ---[ Sources ]--------------------------------------------------------------

source "$BASH_DIR/alias.sh"
[[ -f "$BASH_DIR/local.sh" ]] && source "$BASH_DIR/local.sh"
