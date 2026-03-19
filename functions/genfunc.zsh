print-path() {
  tr ':' '\n' <<< "${PATH}"
}

ssh-forget() {
  ssh-keygen -f "${HOME}"/.ssh/known_hosts -R $1
}

# TODO : Set up some network testing...
