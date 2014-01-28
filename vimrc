set nocompatible              " be iMproved
filetype off                  " required!
let mapleader = "t"

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

autocmd! bufwritepost .vimrc source %

noremap <leader>d dd
noremap <leader>p :set paste<CR>

map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <leader>cd :cd %:p:h<CR>
map <leader>dd :call TddDatClass()<CR>

function! TddDatClass()
  let className = expand('%:t')
  let directory = expand('%:p:h')
  let root = getcwd()
  echo 'file:' . className . ' directory:' . directory . ' root:' . root
endfunction

" Softtabs, 2 spaces
set backspace=2
set tabstop=2
set shiftwidth=2
set expandtab

" Open new split panes to right and bottom
set splitbelow
set splitright

" Display extra whitespace
set list listchars=tab:»·,trail:·

" Numbers
set number
set numberwidth=3

Bundle 'gmarik/vundle'
" My bundles here:
Bundle 'kien/ctrlp.vim'
Bundle 'scrooloose/nerdtree'
Bundle 'altercation/vim-colors-solarized'
Bundle 'thoughtbot/vim-rspec'
" Bundle 'highwaybobbery/vim-tdd-dat-class'
"Bundle 'file:///Users/alex/projects/vim-tdd-dat-class/'

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if (&t_Co > 2 || has("gui_running")) && !exists("syntax_on")
  syntax on
endif

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
set background=dark
colorscheme solarized
highlight NonText guibg=#060606
highlight Folded  guibg=#0A0A0A guifg=#9090D0

" Local config
if filereadable($HOME . "/.vimrc.local")
  source ~/.vimrc.local
endif

