# MrCerealKiller - Personal dotfiles

## /brief
This repository keeps typical system intallation and configuration files to
unify setups across machines and speed up deployment of new machines. The
`setup.sh` script can automate typical installation steps.

> ⚠️ The setup script assumes you have git installed and have used it to
> clone the repository (see below).

## Index
* **aliases**: Contains shell alias scripts that will get linked to the home
directory to be linked with the core rc file
* **config**: All configuration files for various tools and programs, to be
symlinked to their appropriate destinations
* **packages**: Package lists for global installation, separated by package
manager (e.x. `apt`, `pip`, etc.)
* **`setup.sh`**: Script to automatically set up basic configurations

## Prerequisites
This is meant to streamline setup and there are very few prerequisites;
however, a few things should be done ahead of running the setup script.

### First steps
1. Remove bloatware
2. Initial `apt` update and upgrade
3. Make sure all drivers are working properly (_Here's looking at you nvidia_)

### `git` Configuration
1. Generate ssh-key:
    1. `ssh-keygen -t rsa -b 4096 -C "<email>"`
    2. `ssh-add /path/to/generated/key`
    3. _Add public key to your Github account_
2. Set Global Configs:
    1. `git config --global user.name "uname"`
    2. `git config --global user.email "email"`
    3. `git config --global push.default simple`
3. _Clone this repository_

## Snapd-managed installs (Optional)
1. VSCode
2. Spotify
3. Mailspring
4. Signal
5. Gimp
6. VLC
7. OBS
8. Postman

## TODOs
* Create separate ROS setup script
* Integrate python environment setup and installation into core setup
