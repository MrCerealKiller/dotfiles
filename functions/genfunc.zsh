print-path() {
  tr ':' '\n' <<< "${PATH}"
}

ssh-forget() {
  ssh-keygen -f "${HOME}"/.ssh/known_hosts -R $1
}

git-rewind() {
  [[ $# -eq 1 && $1 =~ ^[0-9]+$ ]] ||
    { echo "Usage: $0 <integer>" >&2; exit 2; }

  git reset --hard HEAD~$1
}

# TODO : Set up some network testing...
