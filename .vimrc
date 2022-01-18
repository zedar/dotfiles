set nocompatible                                             " be iMproved, required
syntax enable
filetype off                                                 " required
set autoindent
set autoread                                                 " reload files when changed on disk, i.e. via `git checkout`
set backspace=2                                              " Fix broken backspace in some setups
set backupcopy=yes                                           " see :help crontab
set clipboard=unnamedplus                                    " yank and paste with the system clipboard
set directory-=.                                             " don't store swapfiles in the current directory
set encoding=utf-8
set ignorecase                                               " case-insensitive search
set incsearch                                                " search as you type
set laststatus=2                                             " always show statusline
set listchars=tab:▸\ ,trail:▫
set number                                                   " show line numbers
set ruler                                                    " show where you are
set scrolloff=3                                              " show context above/below cursorline
set showcmd
set smartcase                                                " case-sensitive search if any caps
set tabstop=4                                                " with of a TAB is set to 4. It is still \t, but vim interprets it with a width 4
set shiftwidth=4                                             " Indents will have a width of 4
set softtabstop=4                                            " Sets the number of columns for a TAB
set expandtab                                                " Expand TAB to spaces
set wildignore=build/**,log/**,target/**,tmp/**
set wildmenu                                                 " show a navigable menu for tab completion
set wildmode=longest,list,full
set nowrap
set textwidth=0 wrapmargin=0                                 " turn off physical line wrapping

"
" Plugin manager: vim-plug
"
call plug#begin('~/.vim/plugged')
    Plug 'morhetz/gruvbox' " colorscheme
    Plug 'scrooloose/nerdtree' " file tree on the left
    Plug 'ctrlpvim/ctrlp.vim' " Full path fuzzy file, buffer, ...
    Plug 'jiangmiao/auto-pairs'
    Plug 'sheerun/vim-polyglot'
    Plug 'rhysd/vim-clang-format'
    Plug 'airblade/vim-gitgutter' " Show git diff in the sign column
    Plug 'scrooloose/nerdcommenter' " Comment multiple lines
    Plug 'wincent/terminus' " Enhences integration with the terminal
    Plug 'tpope/vim-vinegar' " enheces default netrw folder browser
    Plug 'christoomey/vim-tmux-navigator' " navigate seamlessly between vim and tmux

    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'neoclide/coc.nvim', {'branch': 'release'}

    Plug 'tyru/open-browser.vim' " required by plantuml-previewer
    Plug 'aklt/plantuml-syntax' " required by plantuml-previewer
    Plug 'weirongxu/plantuml-previewer.vim' " plantuml-previewer

call plug#end()

"
" Color scheme: Gruvbox
"
set background=dark " setting dark mode
let g:gruvbox_contrast_dark = 'soft'
let g:gruvbox_italic=0
colorscheme gruvbox

"
" Fix cursor when in TMUX
"
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\e[5 q\<Esc>\\"
    let &t_SR = "\<Esc>Ptmux;\<Esc>\e[3 q\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\e[2 q\<Esc>\\"
else
    let &t_SI = "\e[5 q"  " blinking I-beam in insert mode
    let &t_SR = "\e[3 q"  " blinking underline in replace mode
    let &t_EI = "\e[ q"  " default cursor (usually blinking block) otherwise
endif

"
" Keyboard shortcuts 
"
let mapleader = ','
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l
" In insert or command mode, move normally by using Ctrl
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"
inoremap <C-h> <Left>
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-l> <Right>
cnoremap <C-h> <Left>
cnoremap <C-j> <Down>
cnoremap <C-k> <Up>
cnoremap <C-l> <Right>

noremap <leader>l :Align
nnoremap <leader>a :Ag<space>
nnoremap <leader>b :CtrlPBuffer<CR>
nnoremap <leader>d :NERDTreeToggle<CR>
nnoremap <leader>v :NERDTreeFind<CR>
nnoremap <leader>t :CtrlP<CR>
nnoremap <leader>T :CtrlPClearCache<CR>:CtrlP<CR>
nnoremap <leader>] :TagbarToggle<CR>
nnoremap <leader><space> :call whitespace#strip_trailing()<CR>
nnoremap <leader>g :GitGutterToggle<CR>
noremap <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exei ":echo 'vimrc reloaded'"<CR>p
autocmd FileType c,cpp,h,hpp nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,h,hpp vnoremap <buffer><Leader>cf :ClangFormat<CR>
" HELP:
" Commenter shortcuts <leader>cc commend code block, <leader>cu uncomment
" visual block
" navigate within editor: ctrl-f full screen forware, ctrl-b full screen back,
" ctrl-d scroll a half screen forward, ctrl-u - scroll a half screen back.
"
"" plugin settings
let g:ctrlp_match_window = 'order:ttb,max:20'

let g:NERDSpaceDelims=1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeDirArrows = 1

let g:gitgutter_enabled = 0
let g:syntastic_cpp_checkers = ['clang_check', 'gcc']
autocmd FileType c,cpp,h,hpp ClangFormatAutoEnable

" Quickfix winow configuration
noremap <F4> :copen<CR>
noremap <F5> :cclose<CR>

" md is markdown
autocmd BufRead,BufNewFile *.md set filetype=markdown
autocmd BufRead,BufNewFile *.md set spell

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" Don't copy the contents of an overwritten selection.
vnoremap p "_dP

" Search down the subfolders
" Provides tab-completion for all the file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" replace in visual mode, p - paste after the cursor, P - paste before the
" cursor
vnoremap p "_dp
vnoremap P "_dP

" Remap quick latest buffer switching
nnoremap <leader>w <C-^>

" Add new line without entering the insert mode
nmap OO o<ESC>j
noremap <leader>s :update<CR>

" Jump to end or beginning of line while in insert mode
inoremap <C-e> <C-o>$ 
inoremap <C-a> <C-o>^

" Copy and paste with clipboard
vmap <C-c> "+y
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

"
" Tmux: vim-navigator
"
" Disable tmux navigator when zooming the Vim pane
let g:tmux_navigator_disable_when_zoomed = 1

"
" Go: go-vim configuration
"
" disable all linters as that is taken care of by coc.nvim
let g:go_diagnostics_enabled = 0
let g:go_metalinter_enabled = []

" don't jump to errors after metalinter is invoked
let g:go_jump_to_error = 0

" run go imports on file save
let g:go_fmt_command = "goimports"

" automatically highlight variable your cursor is on
let g:go_auto_sameids = 0

" for syntax highlighting
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_operators = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1

"
" CoC: config
"
source $HOME/.vim/plug-config/coc.vim
