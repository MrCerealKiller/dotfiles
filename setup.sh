#!/bin/bash
#
# Setup and installation for new systems, installing packages and configs 

################################################################################
# Scaffolding #
###############

err_cnt=0

# Styling
ae_reset="\e[0m"
ae_title="\e[35;1m"
ae_header="\e[4;1m"
ae_warning="\e[33m"
ae_success="\e[32m"
ae_error="\e[31;1m"
ae_info=$ae_reset # no styling
ae_debug="\e[2m"
_echo_title()   { echo -ne "${ae_title}$1${ae_reset}"   ; }
_echo_header()  { echo -ne "${ae_header}$1${ae_reset}"  ; }
_echo_warning() { echo -ne "${ae_warning}$1${ae_reset}" ; }
_echo_success() { echo -ne "${ae_success}$1${ae_reset}" ; }
_echo_error()   { echo -ne "${ae_error}$1${ae_reset}"   ; }
_echo_info()    { echo -ne "${ae_info}$1${ae_reset}"    ; }
_echo_debug()   { echo -ne "${ae_debug}$1${ae_reset}"   ; }

# Symlinking with checks
_symlink() {
  local success=0
  _echo_debug "Linking $1 to $2... "

  # Check paths exist
  if [[ ! -e "$1" ]]; then
    _echo_error "Failed.\n\t$1 does not exist\r\n"
    return 1
  elif [[ ! -d "$(dirname $2)" ]]; then
    _echo_error "Failed.\n\tPath to $2 does not exist\r\n"
    return 1
  fi  

  # Actually perform link
  ln -sf "$1" "$2" || success=1

  # Feedback
  if [[ "${success}" -ne 0 ]] ; then
    _echo_error "Failed.\n\tPlease check for errors or run manually\r\n"
    err_cnt+=1
  else
    _echo_debug "Success.\r\n"
    return 1
  fi
}

################################################################################
# Checking privileges #
#######################

check_privileges() {

  # No error checking here, they're captured by the escalation...

  _echo_info "Checking privileges...\r\n"

  _echo_debug "Current effective user: $( whoami )\r\n"
  _echo_debug "Current sudo user: ${SUDO_USER}\r\n"

  sudo -n true 2>/dev/null
  sudo_check_exit_code=$?

  if [[ "${sudo_check_exit_code}" -gt 0 ]]; then
    _echo_info "Currently logged in as $( whoami )\r\n"
    _echo_warning "Requesting sudo privileges...\r\n\n"
    exec sudo "$0" "$@"
  elif [[ -z "${SUDO_USER}" ]]; then
      _echo_warning "Privilege is available, escalating entire script...\r\n\n"
      exec sudo "$0" "$@"
  fi

  _echo_info "Okay\r\n\n"
  return 0
}

################################################################################
# Title splash #
################

title_splash() {
_echo_title '
   __  __       ____                    _ _  ___ _ _           _
  |  \/  |_ __ / ___|___ _ __ ___  __ _| | |/ (_) | | ___ _ __( )___
  | |\/| | `__| |   / _ \ `__/ _ \/ _` | | ` /| | | |/ _ \ `__|// __|
  | |  | | |  | |__|  __/ | |  __/ (_| | | . \| | | |  __/ |    \__ \
  |_|__|_|_|  _\____\___|_|  \___|\__,_|_|_|\_\_|_|_|\___|_|    |___/
  / ___|  ___| |_ _   _ _ __   / ___|  ___ _ __(_)_ __ | |_
  \___ \ / _ \ __| | | | `_ \  \___ \ / __| `__| | `_ \| __|
   ___) |  __/ |_| |_| | |_) |  ___) | (__| |  | | |_) | |_
  |____/ \___|\__|\__,_| .__/  |____/ \___|_|  |_| .__/ \__|
  #####################|_|#######################|_|########



'
  return 0
}

################################################################################
# Get paths #
#############

get_paths() {
  _echo_header "Getting paths\r\n"

  # Necessary because the home environment variable
  # doesn't work uses root with sudo privileges

  if [[ -n "${SUDO_USER}" ]]; then
      user_home_path="$( getent passwd "${SUDO_USER}" | cut -d: -f6 )"
  else
      user_home_path="${HOME}"
  fi
  _echo_info "Using user home path: $user_home_path\r\n"

  dotfiles_path="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
  _echo_info "Using dotfiles path: ${dotfiles_path}\r\n"

  _echo_success "Done\r\n\n"
  return 0
}

################################################################################
# apt installs #
################

apt_installs() {
  local apt_err_cnt=0

  _echo_header "General apt installations\r\n"

  apt-get -q update

  if [[ -f "${dotfiles_path}/packages/apt-packages.txt" ]]; then

    apt_packages=''
    while IFS= read -r line; do
      # Substring manipulation and sed used to allow hash-styled comments
      apt_packages+="$( echo "${line%%#*}" | sed 's/[[:blank:]]//g; s/^/ /' )"
    done < "${dotfiles_path}/packages/apt-packages.txt"

    _echo_debug "Reading: ${dotfiles_path}/packages/apt-packages.txt\r\n"
    _echo_debug "Packages to install: ${apt_packages}\r\n"

    apt-get install ${apt_packages} -q -y
  else
    _echo_error "${dotfiles_path}/packages/apt-packages.txt does not exist.\r\n"
    _echo_error "Skipping...\r\n"
  fi

  if [[ "${apt_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${apt_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${apt_err_cnt}"
}

################################################################################
# zsh installation #
####################

zsh_install() {
  local zsh_err_cnt=0

  _echo_header "Installing zsh\r\n"

  _echo_info "Installing zsh dependencies\r\n"
  apt-get install zsh fasd -q -y

  _echo_info "Cloning zprezto\r\n"
  # NOTE: delegating to SUDO_USER for their github credentials
  sudo -u "${SUDO_USER}" git clone -q --recursive \
    "https://github.com/sorin-ionescu/prezto.git" "${user_home_path}/.zprezto"

  _echo_info "Linking config files\r\n"
  _symlink "${dotfiles_path}/config/zshrc" "${user_home_path}/.zshrc"
  _symlink "${dotfiles_path}/config/zpreztorc" "${user_home_path}/.zpreztorc"

  _echo_info "Updating user shell to zsh\r\n"
  chsh -s "/usr/bin/zsh" "${SUDO_USER}"
  _echo_warning "Not changing root shell; please do so manually\r\n"

  if [[ "${zsh_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${zsh_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${zsh_err_cnt}"
}

################################################################################
# gogh installation #
#####################

gogh_install() {
  local gogh_err_cnt=0

  _echo_header "Installing gogh\r\n"

  _echo_info "Installing gogh dependencies\r\n"
  apt-get install dconf-cli uuid-runtime dbus-x11 -q -y

  sudo -u "${SUDO_USER}" git clone -q --recursive \
    "https://github.com/Gogh-Co/Gogh.git" "${user_home_path}/.gogh"

  _echo_info "Applying Monokai Pro Machine for gnome-terminal\r\n"
  _echo_info "If something else is desired, feel free to run gogh manually\r\n"

  # NOTE: running in user login environment
  sudo -u "${SUDO_USER}" -i TERMINAL='gnome-terminal' \
    "${user_home_path}"/.gogh/installs/monokai-pro-machine.sh

  if [[ "${gogh_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${gogh_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${gogh_err_cnt}"
}

################################################################################
# tmux installation #
#####################

tmux_install() {
  local tmux_err_cnt=0

  _echo_header "Installing tmux\r\n"

  _echo_info "Installing tmux dependencies\r\n"
  apt-get install tmux -q -y

  _echo_info "Linking config files\r\n"
  _symlink "${dotfiles_path}/config/tmux.conf" "${user_home_path}/.tmux.conf"

  if [[ "${tmux_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${tmux_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${tmux_err_cnt}"
}

################################################################################
# vim installation #
####################

vim_install() {
  local vim_err_cnt=0

  _echo_header "Installing vim\r\n"

  _echo_info "Installing vim dependencies\r\n"
  apt-get install vim -q -y

  _echo_info "Linking config files\r\n"
  _symlink "${dotfiles_path}/config/vimrc" "${user_home_path}/.vimrc"

  # Install vim Plugins
  _echo_info "Installing vim plugins\r\n"
  if [[ ! -f "${user_home_path}/.vim/autoload/plug.vim" ]]; then
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # NOTE: delegating to SUDO_USER for their environment
    sudo -H -u "${SUDO_USER}" vim +PlugInstall +qall
  fi

  if [[ "${vim_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${vim_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${vim_err_cnt}"
}

################################################################################
# conky installation #
######################

conky_install() {
  local conky_err_cnt=0

  _echo_header "Installing conky\r\n"

  _echo_info "Installing conky dependencies\r\n"
  apt-get install conky-all fonts-font-awesome -q -y

  _echo_info "Linking config files\r\n"
  mkdir -p "${user_home_path}/.config/conky" # not done automatically by conky
  _symlink "${dotfiles_path}/config/conky.conf" \
    "${user_home_path}/.config/conky/conky.conf"

  if [[ "${conky_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${conky_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${conky_err_cnt}"
}

################################################################################
# Manage groups and additional permissions #
############################################

groups_config() {
  local groups_err_cnt=0

  _echo_header "Updating user permissions\r\n"

  _echo_info "Adding ${SUDO_USER} to dialout\r\n"
  usermod -aG dialout ${SUDO_USER}

  _echo_info "Adding ${SUDO_USER} to video\r\n"
  usermod -aG video ${SUDO_USER}

  _echo_info "Adding ${SUDO_USER} to input\r\n"
  usermod -aG input ${SUDO_USER}

  if [[ "${groups_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${groups_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${groups_err_cnt}"
}

################################################################################
# Link any additional configs #
###############################

misc_configs() {
  local misc_err_cnt=0

  _echo_header "Running additional configurations\r\n"

  _echo_info "Applying custom udev rules\r\n"
  _symlink "${dotfiles_path}/config/114-mck.rules" \
    "/etc/udev/rules.d/114-mck.rules"

  _echo_info "Linking aliases as '~/.zalias'\r\n"
  if [[ -d "${user_home_path}"/.zaliases ]]; then
    _echo_warning ".zaliases already exists; not overwriting...\r\n"
  else
    _symlink "${dotfiles_path}/aliases" "${user_home_path}/.zaliases"
  fi
  _echo_debug "Not changing rc file! Make sure that aliases are sourced\r\n"

  _echo_info "Linking functions as '~/.zcripts'\r\n"
  if [[ -d "${user_home_path}"/.zcripts ]]; then
    _echo_warning ".zcripts already exists; not overwriting...\r\n"
  else
  _symlink "${dotfiles_path}/functions" "${user_home_path}/.zcripts"
  fi
  _echo_debug "Not changing rc file! Make sure that functions are sourced\r\n"

  if [[ "${misc_err_cnt}" -gt 0 ]]; then
    _echo_error "Failed with ${misc_err_cnt}... but pushing forward\r\n\n"
  else
  _echo_success "Done\r\n\n"
  fi

  return "${misc_err_cnt}"
}

################################################################################
# Logo splash #
###############

logo_splash() {
  echo #style
  _echo_title "$( cat "${dotfiles_path}"/meta/mck_ascii.txt )"
  echo # style
  return
}

################################################################################
# main #
########

main() {
  check_privileges
  title_splash
  get_paths

  apt_installs
  zsh_install
  gogh_install
  tmux_install
  vim_install
  conky_install
  groups_config
  misc_configs

  logo_splash
  _echo_success "Setup is complete!\r\n"
  _echo_success "Please restart your computer for changes to take effect\r\n\n"
}

main "$@"
