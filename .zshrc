## Settings
setopt MENU_COMPLETE
# cd tab ignore case
zstyle ':completion:*' menu no matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Enable Ctrl-x-e to edit command line
bindkey -e
autoload -U edit-command-line
zle -N edit-command-line
bindkey '^xe' edit-command-line
bindkey '^x^e' edit-command-line

# bindkey '^w' backward-kill-word
# how zsh decide a word, useful /foo/bar ctrl-w /foo
# autoload -U select-word-style
# select-word-style bash

# only work perfectly solution 
export WORDCHARS=

export EDITOR=nvim
export LANG=en_US.UTF-8

export BAT_THEME="Nord"
export MANPAGER="sh -c 'col -bx | bat -l man -p'"

## Alias
# alias ls to exa
alias ls=exa
alias ll='ls -alF -snewest'

# alias cat to bat
alias cat=bat

# alias git to hub
eval "$(hub alias -s)"

alias g=git
alias lg=lazygit
alias k=kubectl
alias ks='kubectl -n kube-system'

alias vim=nvim
alias vi=nvim

## Tools

# HomeBrew
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/Users/ruizhang/.local/bin

# bigdata
export SPARK_HOME="/Users/ruizhang/bigdata/spark-3.2.1-bin-hadoop3.2"
export PATH=$PATH:$SPARK_HOME/bin
# HomeBrew END

## fnm
eval "$(fnm env)"

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# alt-c
bindkey "ç" fzf-cd-widget

## UI

# starship
eval "$(starship init zsh)"

# solve tmux term color
# export TERM=alacritty

# highlight
source /Users/ruizhang/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# make zsh completion system work
autoload -U +X compinit && compinit
source <(kubectl completion zsh)

export PATH="/usr/local/opt/binutils/bin:$PATH"

export TOOLPREFIX=x86_64-elf-
export QEMU=qemu-system-i386
[ -f "/Users/ruizhang/.ghcup/env" ] && source "/Users/ruizhang/.ghcup/env" # ghcup-env

# z
eval "$(zoxide init zsh)"

source /Users/ruizhang/.config/broot/launcher/bash/br

eval "$(atuin init zsh)"

fpath=(/Users/ruizhang/.zsh/zsh-completions/src $fpath)
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export JAVA_HOME=$(/usr/libexec/java_home)

clear-ctrl-r() {
  zle autosuggest-clear
  # TODO clear autosuggestions before list history
  zle _atuin_search_widget
}

zle -N clear-ctrl-r

bindkey '^R' clear-ctrl-r

# ignore commands for zsh-autosuggestions plugin
ZSH_AUTOSUGGEST_HISTORY_IGNORE="g stash*"

# create tmux session
# TODO hard code work path, needed change if workspace path changed
tmux_work() {
  # check if session exists, if not create one, if so attach it
  session="work"
  tmux has-session -t $session 2>/dev/null

  if [ $? != 0 ]; then
    # Use -d to allow the rest of the function to run
    tmux new-session -d -s work -c "/Users/ruizhang/Work/workspace/ivoss_web"
    tmux rename-window npm
    # -d to prevent current window from changing
    tmux new-window -d -n front -c "/Users/ruizhang/Work/workspace/ivoss_web"
    tmux new-window -d -n back -c "/Users/ruizhang/Work/workspace/ivoss_web_service"
    tmux new-window -d -n bss/bigdata -c "/Users/ruizhang/Work/ivoss_bigdata"
    tmux new-window -d -n other
    tmux new-window -d -n ssh
    # -d to detach any other client (which there shouldn't be,
    # since you just created the session).
    tmux attach-session -d -t work
  else 
    tmux attach-session -t $session
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
