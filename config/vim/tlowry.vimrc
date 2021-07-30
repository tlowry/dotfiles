syntax enable

"" begin sensible vim : github.com/tpope/vim-sensible

set autoindent
set backspace=indent,eol,start
set complete-=i
set smarttab

set nrformats-=octal

if !has('nvim') && &ttimeoutlen == -1
  set ttimeout
  set ttimeoutlen=100
endif

set incsearch
" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

"" always show status
set laststatus=2
set ruler

"" always keep cursor a few blocks from edges when scrolling
if !&scrolloff
  set scrolloff=1
endif
if !&sidescrolloff
  set sidescrolloff=5
endif
set display+=lastline

if &encoding ==# 'latin1' && has('gui_running')
  set encoding=utf-8
endif

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
endif

if v:version > 703 || v:version == 703 && has("patch541")
  set formatoptions+=j " Delete comment character when joining commented lines
endif

if has('path_extra')
  setglobal tags-=./tags tags-=./tags; tags^=./tags;
endif

set autoread

if &history < 1000
  set history=1000
endif
if &tabpagemax < 50
  set tabpagemax=50
endif
if !empty(&viminfo)
  set viminfo^=!
endif
set sessionoptions-=options
set viewoptions-=options

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^Eterm'
  set t_Co=16
endif

if empty(mapcheck('<C-U>', 'i'))
  inoremap <C-U> <C-G>u<C-U>
endif
if empty(mapcheck('<C-W>', 'i'))
  inoremap <C-W> <C-G>u<C-W>
endif

"" end sensible vim

filetype plugin indent on

"" tab = 4 spaces    
set tabstop=4
set shiftwidth=4
set softtabstop=4
set expandtab

set number "" show line numbers

" Typos
cnoreabbrev E e
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev W w

set ttyfast "" Faster always better ;)
set title "" Change terminal name to file being edited

"Disable line numbers + auto indent for copypaste"
function CopyPasteMode()
    :set invpaste
    :set invnumber
endfunction
noremap <F3> :call CopyPasteMode()<CR>

nnoremap <C-h>  :wprev<CR>
nnoremap <C-l>  :wn<CR>

" Tab navigation
""nnoremap <C-t>  :tabnew<CR>
""nnoremap <C-x>  :tabclose<CR>

" execute current file
nnoremap <C-v> :!%:p<CR>

" insert current time 
nnoremap <F2> "=strftime("%a %G-%m-%d ")<CR>P

" disable ex mode
map q: <Nop>
nnoremap Q <nop>

"" Command helper
set wildmenu
set wildmode=longest:list,full

" Search
set incsearch                   " Incremental search
set hlsearch                    " Highlight matches
set ignorecase                  " Case-insensitive search...
set smartcase                   " ...unless search contains uppercase letter

set lazyredraw "" improves some macro replay speeds

if &term =~ '256color'
    "" Disable Background Color Erase (BCE) so that color schemes
    "" work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

set path+=**

"" recognize file extensions
au BufRead,BufNewFile *.vue setlocal filetype=html

execute pathogen#infect()

""colorscheme atom
""colorscheme afterglow 
colorscheme codedark
""colorscheme colors-wal
