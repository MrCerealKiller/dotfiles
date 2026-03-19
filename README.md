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
* **functions**: Contains shell function scripts that will get linked to the
home directory to be linked with the core rc file
* **meta**: Contains meta information for the script itself
* **packages**: Package lists for global installation, separated by package
manager (e.x. `apt`, `pip`, etc.)
* **ros**: Contains ROS installation script and (eventually) a similar
typical-package installation file
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
6. Inkscpape
7. Shotcut
8. VLC
9. OBS
10. Postman

## TODOs
* Finish error handling in main script
* Port and link some previous tooling
* Integrate python environment setup and installation into core setup

## Disclaimer
This repository is public and free to use at your own risk.
There are some baked in assumptions based on my typical setups, hardware,
and workflows.

_Do you trust me??_
No need to trust me, just look through the scipts and see what they do.
Maybe fork it and star instead?

I am not responsible for damages, data loss, or miconfigurations that
may arise from the use of this repository.
