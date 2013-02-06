execute pathogen#infect()

syn on
set number
set ts=4
set sts=4
set expandtab
set sw=4
set hls
set ignorecase
set smartcase
set incsearch
set ai
set spell
set mouse=a
set backspace=2
set ruler
set laststatus=2
set showcmd
set wildmenu
nnoremap Y y$

set list

if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  endif
endif

" Color scheme
colo elflord
if has('gui_running')
    colo evening
endif

" Font
set guifont=Inconsolata\ Medium\ 12
if has('gui_macvim')
    set guifont=Menlo:h11
endif

" ConqueTerm
function! OpenBash()
    " If the buffer is not empty, split the window
    if line('$') != 1 || getline(1) != ''
        split
    end
    ConqueTerm bash
endfunction

if has('gui_macvim')
    map tt :call OpenBash()<CR>
endif

