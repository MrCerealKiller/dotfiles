# Symlink Config Files
echo "Symlinking dotfiles to their appropriate file locations..."
echo "(Please make sure you're running this script from the dotfiles repo.)"

ln -sfv "$(pwd)/zshrc" "${HOME}/.zshrc"
ln -sfv "$(pwd)/zpreztorc" "${HOME}/.zpreztorc"
ln -sfv "$(pwd)/vimrc" "${HOME}/.vimrc"
ln -sfv "$(pwd)/tmux.conf" "${HOME}/.tmux.conf"

# Vim Plugins
if [[ ! -f "${HOME}/.vim/autoload/plug.vim" ]]; then
  echo "Setting up vim plugins..."
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  vim +PlugInstall +qall
fi

echo "Done."
