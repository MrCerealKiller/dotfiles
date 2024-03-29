set nocompatible
syntax on

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

" Plugins
if filereadable($HOME.'/.vim/autoload/plug.vim')
  call plug#begin('~/.vim/plugged')
  " Theme
  Plug 'morhetz/gruvbox'

  " Syntax
  Plug 'plasticboy/vim-markdown'
  Plug 'sudar/vim-arduino-syntax'
  Plug 'vim-syntastic/syntastic'

  " Autocomplete
  Plug 'lifepillar/vim-mucomplete'
  Plug 'davidhalter/jedi-vim'

  " Autoformat
  Plug 'Chiel92/vim-autoformat'

  " Status line
  Plug 'itchyny/lightline.vim'

  " FZF for file search
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'

  " Nerdtree
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " Git wrapper
  Plug 'tpope/vim-fugitive'

  " Show buffers in tabline
  Plug 'ap/vim-buftabline'

  " Show changed lines in gutter
  Plug 'airblade/vim-gitgutter'

  " Multiple cursors
  Plug 'terryma/vim-multiple-cursors'

  " Allow (un-)commenting lines with <leader>cc
  Plug 'scrooloose/nerdcommenter'

  " Show trailing whitespace
  Plug 'bronson/vim-trailing-whitespace'
  call plug#end()
endif

" Mappings <leader> = <space>
let mapleader = " "
" Open FZF with <Ctrl>-P
nnoremap <silent> <C-p> :FZF<CR>
" Open NerdTree with <Ctrl>-t
nnoremap <silent> <C-t> :NERDTreeToggle<CR>
" Autoformat with <leader>f
nnoremap <silent> <leader>f :Autoformat<CR>
" Switch to previous buffer with <leader><space>
nnoremap <silent> <leader><space> <C-^><CR>
" Clear search highlights with <leader>l
nnoremap <silent> <leader>l :nohlsearch<CR><C-l>

" Basic settings
set showcmd             " Show (partial) command in status line
set showmatch           " Show matching brackets
set showmode            " Show current mode
set ruler               " Show the line and column numbers of the cursor
set colorcolumn=80      " Show line at 80th column
set number              " Show the line numbers on the left side
set formatoptions+=o    " Continue comment marker in new lines
set textwidth=0         " Hard-wrap long lines as you type them
set noerrorbells        " No beeps
set modeline            " Enable modeline
set linespace=0         " Set line-spacing to minimum
set nojoinspaces        " Prevents 2 spaces after punctuation on a join (J)
set splitbelow          " Horizontal split below current
set splitright          " Vertical split to right of current
set mouse=a             " Set mouse mode on
set laststatus=2        " Show status line
set hidden              " Show abandoned buffers
set showtabline=2       " Show tabline
set confirm             " Raise a dialog instead of failing for some operations

" Autocompletion options
set wildmenu              " Enhanced command-line completion
set completeopt+=menuone  " Always show menu on tab
set completeopt+=preview  " Preview additional information

" History and search
set history=100
set hlsearch      " Highlight search results
set ignorecase    " Make search case-insensitive
set smartcase     " ... unless the query has capital letters
set incsearch     " Incremental search
set wrapscan      " Search wraps around file
set gdefault      " Use 'g' flag by default with :s/foo/bar/
set magic         " Use 'magic' patterns (extended regex)

" Cursor line
set cursorline
highlight CursorLine term=bold cterm=bold guibg=Grey40

" No backup files
set nobackup
set nowritebackup
set noswapfile

" Indentation behaviour
set expandtab           " Insert spaces when TAB is pressed
set tabstop=2           " Render TABs using this many spaces
set shiftwidth=2        " Indentation amount for < and > commands
set softtabstop=2       " Spaces per tab
set autoindent          " Apply indentation of current line to the next
set smarttab            " Indent based on syntax
set wrap                " Wrap text
set backspace=2         " Set backspace to remove this many spaces
set list                " Show tabs as characters
set listchars=tab:!-    " Show each tab as !---

" Spell checker
set spell
set spelllang=en

" Colorscheme
set t_Co=256
silent! colorscheme gruvbox
set background=dark

" Lightline
let g:lightline = {}
let g:lightline.colorscheme = 'gruvbox'

" Use theme colors in FZF
let g:fzf_colors = {
  \ 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

" ROS
let g:ros_build_system = 'catkin-tools'

" Syntax-specific settings
let g:vim_markdown_folding_disabled = 1
autocmd Filetype python setlocal shiftwidth=4 softtabstop=4

" Remove trailing whitespaces
let ignore = ["markdown", "latex", "plaintex"]  " Ignore for these filetypes
autocmd BufWritePre * if index(ignore, &ft) < 0 | RemoveTrailingSpaces
