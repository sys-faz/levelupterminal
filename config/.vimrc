" enable syntax highlighting "
syntax on

" enable line numbers "
set number
set relativenumber

" change linenumbers color  "
:highlight LineNr ctermfg=44 guifg=#00c4db
:highlight CursorLineNr cterm=bold ctermfg=44 guifg=#00c4db
" enable mouse "
set mouse=a

" highlight cursorline  "
set cursorline
:highlight cursorline cterm=bold ctermbg=236 guibg=#303030

" enable highlighted search pattern  "
set hlsearch

" enable smart search  "
set ignorecase
set smartcase

" indentation configuration  "
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

" enable show matching braces pairs  "
set showmatch

" enable rich color "
if !has('gui_running')
    set t_Co=256
endif
set termguicolors

