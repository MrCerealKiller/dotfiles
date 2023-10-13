#################
## PREZTO INIT ##
#################

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

##################
## GEN. EXPORTS ##
##################

#export RMW_IMPLEMENTATION=rmw_cyclonedds_cpp
export TERM=xterm-256color        # Default Terminal Emulator
export EDITOR=vim                 # Default Text Editor
fpath=("/usr/local/bin/" $fpath)  # Add homebrew to path

#############
## HISTORY ##
#############

HISTCONTROL=ignoreboth
HISTSIZE=1000
setopt HIST_EXPIRE_DUPS_FIRST

#################
## ZSH OPTIONS ##
#################

setopt MULTIOS          # Allow multiple outputs
setopt IGNORE_EOF       # Keep processes online for <10 EOF
setopt NO_CLOBBER       # Do not clobber when using pipes
setopt RC_EXPAND_PARAM  # More rational param expansion
setopt +o NO_MATCH
setopt NO_BEEP

unsetopt CORRECT_ALL    # Kind of annoying honestly...

##################
## KEY BINDINGS ##
##################

# Set Home and End keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

###################
## OTHER SOURCES ##
###################

if [[ -s "/opt/ros/humble/setup.zsh" ]]; then
  source "/opt/ros/humble/setup.zsh"
fi

if [[ -s "${HOME}/.roscompat-aliases.zsh" ]]; then
  source "${HOME}/.roscompat-aliases.zsh"
fi

function load-esp-idf
{
  if [[ -s "${HOME}/tools/esp-idf/export.sh" ]]; then
    source "${HOME}/tools/esp-idf/export.sh"
  fi
}

#############
## ALIASES ##
#############

alias op="xdg-open"
alias touchall="find . -type f -exec touch {} +"
alias degreen="chmod -R a-x,o-w,+X "
alias ssh-forget="ssh-keygen -f \"${HOME}/.ssh/known_hosts\" -R "

###############
## FUNCTIONS ##
###############

# Removed due to obsolescence. Should update

###################
## AUTO-APPENDED ##
###################

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

