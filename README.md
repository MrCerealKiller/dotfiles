# MrCerealKiller - Personal dotfiles

## New System Setup (Ubuntu 18.04)
**Initial Steps:**
1. Remove bloatware
2. Update and upgrade
3. Make sure all drivers are working properly

**Git Configuration:**
* Generate ssh-key:
    1. `ssh-keygen -t rsa -b 4096 -C "email"`
    2. `ssh-add /path/to/generated/key`
    3. _Add key to your Github account_
* Set Global Configs:
    1. `git config --global user.name "uname"`
    2. `git config --global user.email "email"`
    3. `git config --global push.default simple

**Zsh Install**
1. `sudo apt-get install zsh`
2. `sudo apt-get install fasd`
3. `git clone -q --recursive git@github.com:sorin-ionescu/prezto.git ~/.zprezto`
4. `ln -sf /path/to/dotfiles/zshrc /path/to/home/.zshrc`
5. `ln -sf /path/to/dotfiles/zpreztorc /path/to/home/.zpreztorc`
6. `chsh -s /usr/bin/zsh root`
7. `chsh -s /usr/bin/zsh <user>`

## Usual Software Packages
**Install Basics:**
* vim
* git
* zsh
* wget
* curl
* python-pip

**Usual Apt Installs:**
* tmux
* tmuxinator
* wine-stable
* htop
* lm-sensors
* tree
* tlp
* tlp-rdw

**Usual Python Installs:**
* ipython
* pysensors
* catkin_tools (for ROS)
* catkin_lint (for ROS)
* anaconda
* yapf
* futures

**Usual Ubuntu Software Installs:**
* Postman
* Spotify
* Mailspring
* Signal
* VLC
* OBS

## Usage
1. Install dependencies
2. `cd <path>/<to>/dotfiles`
3. `./setup.sh`
