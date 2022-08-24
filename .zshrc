## Settings
setopt MENU_COMPLETE
# cd tab ignore case
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

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

## Alias
# alias ls to exa
alias ls=exa
alias ll='ls -l'

# alias cat to bat
alias cat=bat

# alias git to hub
eval "$(hub alias -s)"

alias g=git

alias vim=nvim
alias vi=nvim

## Tools

# HomeBrew
export PATH="/usr/local/bin:$PATH"
export PATH="/usr/local/sbin:$PATH"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
export PATH=$PATH:/Users/ruizhang/.local/bin

# TODO asmebly
export PATH=$PATH:/Users/ruizhang/Documents/cs/basics/asm/nasm-2.15.05/

# bigdata
export SPARK_HOME="/Users/ruizhang/bigdata/spark-3.2.1-bin-hadoop3.2"
export PATH=$PATH:$SPARK_HOME/bin
# HomeBrew END

## fnm
eval "$(fnm env)"

## fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

FD_OPTIONS="--follow --exclude .git --exclude node_modules"

export FZF_DEFAULT_COMMAND="git ls-files --cached --others --exclude-standard | fd --type f --type l $FD_OPTIONS"
export FZF_CTRL_T_COMMAND="fd $FD_OPTIONS"
export FZF_ALT_C_COMMAND="fd --type d $FD_OPTIONS"

export FZF_DEFAULT_OPTS='--height 60% --border --reverse'
export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
export FZF_ALT_C_OPTS="--preview 'tree -C {} | head -200'"

fzf-history-widget-accept() {
  fzf-history-widget
  zle accept-line
}
zle     -N     fzf-history-widget-accept
bindkey '^X^R' fzf-history-widget-accept

# alt-c
bindkey "ç" fzf-cd-widget

# GIT heart FZF
# -------------

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

_gf() {
  is_in_git_repo || return
  git -c color.status=always status --short |
  fzf-down -m --ansi --nth 2..,.. \
    --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1})' |
  cut -c4- | sed 's/.* -> //'
}

_gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --color=always --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1)' |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

_gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {}'
}

_gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always' |
  grep -o "[a-f0-9]\{7,\}"
}

_gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1}' |
  cut -d$'\t' -f1
}

_gs() {
  is_in_git_repo || return
  git stash list | fzf-down --reverse -d: --preview 'git show --color=always {1}' |
  cut -d: -f1
}

join-lines() {
  local item
  while read item; do
    echo -n "${(q)item} "
  done
}

bind-git-helper() {
  local c
  for c in $@; do
    eval "fzf-g$c-widget() { local result=\$(_g$c | join-lines); zle reset-prompt; LBUFFER+=\$result }"
    eval "zle -N fzf-g$c-widget"
    eval "bindkey '^g^$c' fzf-g$c-widget"
  done
}
bind-git-helper f b t r h s
unset -f bind-git-helper

## UI

# starship
eval "$(starship init zsh)"

# solve tmux term color
# export TERM=alacritty

# highlight
source /Users/ruizhang/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# fzf-tab
source /Users/ruizhang/.config/fzf-tab/fzf-tab.plugin.zsh

# make zsh completion system work
autoload -Uz compinit && compinit
export PATH="/usr/local/opt/binutils/bin:$PATH"

export TOOLPREFIX=x86_64-elf-
export QEMU=qemu-system-i386
[ -f "/Users/ruizhang/.ghcup/env" ] && source "/Users/ruizhang/.ghcup/env" # ghcup-env

# z
eval "$(zoxide init zsh)"

source /Users/ruizhang/.config/broot/launcher/bash/br

eval "$(atuin init zsh)"

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
