#################
## PREZTO INIT ##
#################

if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

##################
## GEN. EXPORTS ##
##################

export TERM=xterm-256color        # Default Terminal Emulator
export EDITOR=vim                 # Default Text Editor
fpath=("/usr/local/bin/" $fpath)  # Add homebrew to path

#############
## HISTORY ##
#############

HISTCONTROL=ignoreboth
HISTSIZE=1000

#################
## ZSH OPTIONS ##
#################

setopt MULTIOS          # Allow multiple outputs
setopt IGNORE_EOF       # Keep processes online for <10 EOF
setopt NO_CLOBBER       # Do not clobber when using pipes
setopt RC_EXPAND_PARAM  # More rational param expansion
setopt +o NO_MATCH

unsetopt CORRECT_ALL    # Kind of annoying honestly...

##################
## KEY BINDINGS ##
##################

# Set Home and End keys
bindkey '\e[1~' beginning-of-line
bindkey '\e[4~' end-of-line

#############
## ALIASES ##
#############

alias local_ros_master="export ROS_MASTER_URI=http://localhost:11311"
alias auv_ros_master="export ROS_MASTER_URI=http://10.10.10.10:11311"
alias gannet_ros_master="export ROS_MASTER_URI=http://gannet:11311"
alias roboat="ssh -y mrl@192.168.11.2"
alias op="xdg-open"
alias resetwifi="sudo systemctl restart network-manager.service"
alias convert_2_pdf="~/tools/convert_2_pdf.sh"

###############
## FUNCTIONS ##
###############

pyserve () {
  pushd $1; python3 -m http.server 9999; popd;
}

ethros () {
  IP=$(ifconfig eth0 | grep "inet addr:" | cut -d: -f2 | awk '{ print $1 }')
  export ROS_IP=$IP
}

wlanros () {
  IP=$(ifconfig wlan0 | grep "inet addr:" | cut -d: -f2 | awk '{ print $1 }')
  export ROS_IP=$IP
}

###################
## OTHER SOURCES ##
###################

# None for now...

#####################
## MCGILL ROBOTICS ##
#####################

export ROBOT=auv
export IAMROBOT=false
export ROBOTIC_PATH=/home/jeremy
if [[ -f ${ROBOTIC_PATH}/compsys/roboticrc ]]; then
  source ${ROBOTIC_PATH}/compsys/roboticrc
fi

auv() {
  # wlanros
  auv_ros_master
  source ${ROBOTIC_PATH}/auv/catkin_ws/devel/setup.zsh
}
