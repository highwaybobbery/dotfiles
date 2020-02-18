set nocompatible              " be iMproved
filetype off                  " required!
let mapleader = "t"


autocmd! bufwritepost .vimrc source %

" noremap <leader>d dd
noremap <leader>p :set paste<CR>
noremap <leader><space> :noh<return><esc>
noremap , /
map <leader>cd :cd %:p:h<CR>
map <leader>a :tabprevious<CR>
map <leader>; :tabnext<CR>
map <leader>b :NERDTreeToggle<CR>

nnoremap <silent> <C-l> <c-w>l
nnoremap <silent> <C-h> <c-w>h
nnoremap <silent> <C-k> <c-w>k
nnoremap <silent> <C-j> <c-w>j

" folding
set foldmethod=syntax
set nofoldenable
" noremap <C-Space> <C-x><C-o>
" noremap <C-@> <C-Space>
" noremap <SPACE> za
" noremap <C-SPACE> zO

" Allow project specific vimrc
set exrc

" Softtabs, 2 spaces
set backspace=2
set tabstop=2
set shiftwidth=2
set expandtab
set colorcolumn=80
set nowrap

" Open new split panes to right and bottom
set splitbelow
set splitright

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Numbers
set number
set numberwidth=4

set noswapfile
set nobackup
set nowb

set hlsearch
set incsearch
set ignorecase
set smartcase

set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ \ [POS=%04l,%04v][%p%%]\ [LEN=%L] 

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VungleVim/Vundle.vim'
" My bundles here:
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-surround'
Plugin 'rking/ag.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/nerdcommenter'
Plugin 'altercation/vim-colors-solarized'
Plugin 'thoughtbot/vim-rspec'
"Plugin 'jgdavey/tslime.vim'
"Plugin 'jgdavey/vim-turbux'
Plugin 'pangloss/vim-javascript'
Plugin 'kchmck/vim-coffee-script'
Plugin 'ap/vim-css-color'
Plugin 'tpope/vim-haml'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-rake'
Plugin 'rodjek/vim-puppet'
Plugin 'christoomey/vim-tmux-navigator'

let g:rspec_command = "!bundle exec rspec --drb {spec}"

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

call vundle#end()
filetype plugin indent on     " required for vundle

" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'

  " ag is fast enough that CtrlP doesn't need to cache
  let g:ctrlp_use_caching = 0
endif

" Color scheme
let g:solarized_termcolors=256
set background=light
colorscheme solarized

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

" auto source vimrc on save
autocmd! bufwritepost .vimrc source %
set secure
