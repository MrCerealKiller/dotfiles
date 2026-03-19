#!/bin/bash
#
# Installation of ROS2

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
}

################################################################################
# Checking locale #
###################

check_locale() {
  _echo_header "Checking locale\r\n"

  if [[ -n "${LANG}" && "${LANG}" == *"UTF-8"* ]]; then
    _echo_info "Already using a UTF-8 locale (${LANG})\r\n"
    _echo_info "This should be okay; skipping locale setup\r\n"
  else
    apt-get update -qq && apt-get install locales
    if [[ $? -eq 0 ]]; then
      locale-gen en_CA en_CA.UTF-8
      update-locale LC_ALL=en_CA.UTF-8 LANG=en_CA.UTF-8
      export LANG=en_CA.UTF-8
    else
    	_echo_error "Could not install locales, exiting\r\n"
    	exit 1
    fi
    _echo_info "Updated locale\r\n"
  fi

  _echo_success "Done\r\n\n"
}

################################################################################
# Prereq installs #
###################

prereq_installs() {
  local apt_err_cnt=0

  _echo_header "Prerequisite apt installations\r\n"

  apt-get update -qq || apt_err_cnt+=1
  apt-get install software-properties-common curl -qq -y || apt_err_cnt+=1
  add-apt-repository universe -y || apt_err_cnt+=1

  if [[ "${apt_err_cnt}" -gt 0 ]]; then
    _echo_error "Could not install dependencies, exiting\r\n"
    exit 1
  else
    _echo_success "Done\r\n\n"
  fi

  return "${apt_err_cnt}" # should always return 0
}

################################################################################
# ROS ppa #
###########

ros_ppa() {
  local ppa_err_cnt=0
  local ppa_ver_url='https://api.github.com/repos/ros-infrastructure/ros-apt-source/releases/latest'

  _echo_header "Linking ROS ppa\r\n"

  export ROS_APT_SOURCE_VERSION=$( curl -s "${ppa_ver_url}" \
    | grep -F "tag_name" \
    | awk -F'"' '{print $4}' )
  _echo_debug "ROS source version: ${ROS_APT_SOURCE_VERSION}\r\n"

  # Honestly this is gross and I don't even want to try  and simplify it
  # Just copied from ROS docs
  curl -L -o /tmp/ros2-apt-source.deb "https://github.com/ros-infrastructure/ros-apt-source/releases/download/${ROS_APT_SOURCE_VERSION}/ros2-apt-source_${ROS_APT_SOURCE_VERSION}.$(. /etc/os-release && echo ${UBUNTU_CODENAME:-${VERSION_CODENAME}})_all.deb" || ppa_err_cnt+=1
  if [[ "${ppa_err_cnt}" -gt 0 ]]; then
    _echo_error "Could not get deb, exiting\r\n"
    exit 1
  else
    dpkg -i /tmp/ros2-apt-source.deb || ppa_err_cnt+=1
    if [[ "${ppa_err_cnt}" -gt 0 ]]; then
      _echo_error "Could not install deb, exiting\r\n"
      exit 1
    else
      _echo_success "Done\r\n\n"
    fi
  fi

  return 0
}

################################################################################
# ROS installation #
####################

ros_install() {
  local ros_err_cnt=0

  _echo_header "Installing ROS\r\n"
  _echo_warning "This may take a while!\r\n"

  apt-get update -qq || ros_err_cnt+=1
  apt-get install ros-dev-tools ros-jazzy-desktop -qq -y || ros_err_cnt+=1

  if [[ "${apt_err_cnt}" -gt 0 ]]; then
    _echo_error "Something went wrong during apt installation, exiting\r\n"
    exit 1
  else
    _echo_success "Done\r\n\n"
  fi

  return 0
}

################################################################################
# main #
########

main() {
  check_privileges
  check_locale

  prereq_installs
  ros_ppa
  ros_install

  _echo_success "Setup is complete!\r\n"
  _echo_success "Make sure to source the ROS setup.zsh\r\n\n"
}

main "$@"
