set nocompatible
filetype off

" Plugins
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'            " Plugin manager
Plugin 'bling/vim-airline'            " Status/Tab line
Plugin 'ctrlpvim/ctrlp.vim'           " Full path fuzzy finder
Plugin 'tpope/vim-dispatch'           " Asynchronous build and test dispatcher
Plugin 'tpope/vim-fugitive'           " Git integration
Plugin 'airblade/vim-gitgutter'       " Git diff, stage, revert in the gutter
Plugin 'junegunn/goyo.vim'            " Distraction-free writing
Plugin 'Yggdroot/indentLine'          " Indentation level marker
Plugin 'davidhalter/jedi-vim'         " Using the jedi autocompletion library
Plugin 'junegunn/limelight.vim'       " Hyperfocus writing
Plugin 'vim-utils/vim-man'            " Display and browse manual pages
Plugin 'def-lkb/ocp-indent-vim'       " Integration of ocp-indent for OCaml
Plugin 'darfink/vim-plist'            " Edit OSX plist files
Plugin 'tpope/vim-rsi'                " Readline mappings in insert and command
Plugin 'rust-lang/rust.vim'           " Rust syntax highlighting
Plugin 'ervandew/supertab'            " Insert mode completions with Tab
Plugin 'tpope/vim-surround'           " Quoting/parenthesizing made simple
Plugin 'scrooloose/syntastic'         " Syntax checking
Plugin 'majutsushi/tagbar'            " Display tags in a window
Plugin 'jmcantrell/vim-virtualenv'    " Work with Python virtual environments
Plugin 'thinca/vim-visualstar'        " Visual selection search

" Theme
Plugin 'vim-airline/vim-airline-themes'
Plugin 'altercation/vim-colors-solarized'

call vundle#end()

filetype plugin indent on

" Editing
syntax enable
set autoread
set number
set shiftround
set ignorecase
set smartcase
set autoindent
set smartindent
set expandtab
set smarttab
set backspace=indent,eol,start
set softtabstop=4 tabstop=4 shiftwidth=4
set cursorline
set incsearch
set hlsearch
set title
set ttyfast
set laststatus=2
set noswapfile
set wildmenu
set wildmode=longest:full

" Make terminal Vim great again
set notimeout
set ttimeout
set ttimeoutlen=100

" Key bindings
let mapleader = ","
let g:mapleader = ","
let maplocalleader = "§"

" Use double-leader to jump to last file
nnoremap <leader><leader> <c-^>

" Tab sizes
nnoremap <silent> <leader>2 :set softtabstop=2 tabstop=2 shiftwidth=2<CR>
nnoremap <silent> <leader>4 :set softtabstop=4 tabstop=4 shiftwidth=4<CR>
nnoremap <silent> <leader>8 :set softtabstop=8 tabstop=8 shiftwidth=8<CR>

" Tab/Space indentation
nnoremap <silent> <leader>e :set expandtab!<CR>

" Toggle drawing of 80 chars column
function! g:ToggleColorColumn()
  if &colorcolumn != ''
    setlocal colorcolumn&
  else
    setlocal colorcolumn=80
  endif
endfunction
nnoremap <silent> <leader>l :call g:ToggleColorColumn()<CR>

" Toggle dark/light background
function! g:ToggleBackgroundColor()
  if &background != 'dark'
    setlocal background=dark
    if has('gui_gtk2')
      call system("xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT 'dark' -id " . v:windowid)
    endif
  else
    setlocal background=light
    if has('gui_gtk2')
      call system("xprop -f _GTK_THEME_VARIANT 8u -set _GTK_THEME_VARIANT 'light' -id " . v:windowid)
    endif
  endif
endfunction
nnoremap <silent> <leader>b :call g:ToggleBackgroundColor()<CR>

" Jump to current tag in Tagbar
nnoremap <silent> <leader>t :TagbarOpenAutoClose<CR>

" Search for tag in CtrlP
nnoremap <silent> <C-T> :CtrlPBufTag<CR>

" Clear search highlighting on redraw
nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" Toggle list mode
nnoremap <silent> <leader>s :set list!<CR>

" Toggle paste mode
nnoremap <silent> <leader>c :set paste!<CR>

" Toggle indentation marks
nmap <silent> <leader>i :IndentLinesToggle<CR>

" Toggle tagbar
nmap <silent> <F8> :TagbarToggle<CR>

" Toggle distraction-free mode
map <silent> <F11> :Goyo<CR>

" Use plugin to view manual pages
map K <plug>(Man)

" Extensions
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#whitespace#enabled = 1
let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_extensions = ['buffertag', 'mixed']
let g:ctrlp_mruf_exclude = '(/private)?/tmp/.*'
let g:indentLine_enabled = 0
let g:limelight_conceal_ctermfg = 241
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 2
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" User interface
if has('gui_running')
  set background=light
  set guifont=Fira\ Mono\ 10
  if has('mac')
    set guifont=Fira\ Mono:h12
  endif
  set lines=40 columns=120
  set guioptions=agirL
  let g:solarized_menu = 0
else
  set background=dark
endif
set listchars=nbsp:¬,eol:¶,trail:·,tab:→\ ",space:␣
colorscheme solarized

" Be silent in GUI mode
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

" Fullscreen in distraction-free mode
function! s:goyo_enter()
  set nocursorline
  " Quick paragraph switching and scrolling
  nnoremap <C-D> })zz
  nnoremap <C-U> {{)zz

  if has('gui_running')
    set guioptions-=mr
    "call system("wmctrl -ir " . v:windowid . " -b add,fullscreen,below")
    set guicursor+=n:blinkon0
    " Prevent any touchpad mistakes
    nnoremap <Space> })zz
    nnoremap <S-Space> {{)zz
  endif
endfunction

function! s:goyo_leave()
  set cursorline
  unmap <C-D>
  unmap <C-U>

  if has('gui_running')
    "call system("wmctrl -ir " . v:windowid . " -b remove,fullscreen,below")
    set guicursor-=n:blinkon0
    unmap <Space>
    unmap <S-Space>
  endif
endfunction

autocmd User GoyoEnter call <SID>goyo_enter()
autocmd User GoyoLeave nested call <SID>goyo_leave()

" Focus on paragraph in distraction-free mode
autocmd User GoyoEnter Limelight
autocmd User GoyoLeave Limelight!

" Make fugitive splits more readable
autocmd BufEnter *.fugitiveblame set splitbelow
autocmd BufLeave *.fugitiveblame set nosplitbelow

" Mail settings
autocmd BufRead ~/.mutt/tmp/mutt* set textwidth=72 "spell
autocmd BufNewfile,BufRead ~/.mutt/tmp/mutt*[0-9] set nobackup nowritebackup

" OCaml configuration
if executable('opam') && executable('ocamlmerlin')
  let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
  execute "set rtp+=" . g:opamshare . "/merlin/vim"
  execute "helptags " . g:opamshare . "/merlin/vim/doc"
  let g:syntastic_ocaml_checkers = ['merlin']
  au FileType ocaml call SuperTabSetDefaultCompletionType("<c-x><c-o>")
endif

" Local configuration
source ~/.local/etc/vimrc
