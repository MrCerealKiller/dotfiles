# Reasonable
alias zshreload='source "${HOME}"/.zshrc'
alias op='xdg-open'
alias untar='tar -xvf'
alias lsserial='ls -l /dev/ttyUSB* /dev/ttyACM*'
alias showip='ip -brief address'

# Sketchy
# Recursively touch all files in the current directory to updated
# their "last modified" timestamp; this is because clocks are hard
alias touchall='find . type f -exec touch {} +'
# Solves issues of permissions on transferred files looking terrible
alias degreen='chmod -R a-x,o-w,+X'
