" Owen Littlejohns, edited from Kristin Rutkowski
" 20181011
" .vimrc
" adapted from: 
"   vim.wikia.com/wiki/Example_vimrc
"   https://github.com/Areustle/dotfiles/blob/master/vim/.vimrc

set nocompatible

" ----------------------------------------
" ---- editor display ---- 

" Attempt to determine the type of a file based on its name and possibly its
" contents. Use this to allow intelligent auto-indenting for each filetype,
" and for plugins that are filetype specific.
filetype indent plugin on

" display syntax highlighting
syntax on

" Enable use of the mouse for all modes
set mouse=a

" display line numbers on the left
set number

" Set colorscheme
set t_Co=256
set background=dark
colorscheme desert
" colorscheme rested
" colorscheme solarized

" 

" highlight current line
set cursorline
"hi CursorLine cterm=NONE ctermbg=darkgray guibg=darkgray

" highlight current column
set cursorcolumn
highlight cursorcolumn ctermbg=darkgray guibg=darkgray

" highlight column 80 dark gray instead of pink
set colorcolumn=80
highlight ColorColumn ctermbg=246 guibg=darkgray

" ----------------------------------------
" ---- status line ---- 

" Show partial commands in the last line of the screen
set showcmd

" Display the cursor position in the status line
set ruler

" Always display the status line, even if only one window is displayed
set laststatus=2

" Set the command window height to 2 lines, to avoid many cases of having to
" "press <Enter> to continue"
set cmdheight=2


" ----------------------------------------
" ---- searching ---- 

" sets incremental search, to highlight words as you type into search
set incsearch

" highlights all occurrences of string
set hlsearch

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" always keep some lines of context around the cursor 
" - helpful when search puts the cursor at the top of the window and I'm
"   not sure where I am in the code
set scrolloff=2

" turn off search highlight: mapped to ,<space>.
"nnoremap <Leader><space> :noh<CR>

" turn off highlighting after a search
"map ,, :nohl

" press return to temporarily get out of the highlighted search.
"nnoremap <CR> :nohlsearch<CR><CR>

" Press Space to turn off highlighting and clear any message already displayed.
nnoremap <silent> <Space> :nohlsearch<Bar>:echo<CR>


" ----------------------------------------
" ---- misc ---- 

" instead of failing a command because of unsaved changes, instead
" raise a dialog asking if you wish to save changed files
set confirm

" allow backspace to delete work when editing
set backspace=indent,eol,start

" Enable use of the mouse for all modes
"set mouse=a

" Use <F11> to toggle between 'paste' and 'nopaste'
set pastetoggle=<F11>



" ----------------------------------------
" ---- tabs ---- 

" set tab size when looking in vi
set tabstop=4

" expand tabs to spaces
"set expandtab

" an indent will correspond to a single tab
set shiftwidth=4

" tab key will go to next level of indentation
set smarttab

" When opening a new line and no filetype-specific indenting is enabled, keep
" the same indent as the line you're currently on.
set autoindent

" if using actual tab character in source code, probably also want: 
" - these are actually the defaults, but may want to set them defensively 
"   set softtabstop=0 noexpandtab

" Uncomment the following to have Vim jump to the last position when                          
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Set indent to two spaces for pug and Javascript files:
autocmd FileType pug setlocal shiftwidth=2 tabstop=2 smarttab
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType python setlocal shiftwidth=4 softtabstop=4 expandtab

" Disable bell:
set visualbell
set t_vb=
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" Shorthand notation; fetches
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install',
  \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue'] }

" Initialize plug system
call plug#end()

execute pathogen#infect()
syntax on
filetype plugin indent on

" Support 256-terminal colours:
let &t_Co=256

" vim-ale settings:
let g:ale_sign_column_always = 1
let g:ale_linters={
  \ 'java': [],
  \ 'javascript': ['eslint']}
let g:ale_fixers = {
  \ 'javascript': ['eslint', 'prettier'],
  \ 'css': ['prettier'],
  \ 'typescript': ['prettier']}
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_use_local_config = 1
let g:ale_typescript_prettier_use_local_config = 1
