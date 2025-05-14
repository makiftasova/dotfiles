call plug#begin('~/.local/share/nvim/plugged')

" Life saver
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/nerdtree'
Plug 'scrooloose/nerdcommenter'
Plug 'sjl/gundo.vim'
Plug 'majutsushi/tagbar'
Plug 'junegunn/gv.vim'

" Cosmetics
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'morhetz/gruvbox'
Plug 'mhinz/vim-startify'

" Text Utils
Plug 'easymotion/vim-easymotion'
Plug 'vim-scripts/MultipleSearch'

" General helper
Plug 'JamshedVesuna/vim-markdown-preview'
Plug 'wesQ3/vim-windowswap'
Plug 'will133/vim-dirdiff'

" Syntax checking
Plug 'vim-syntastic/syntastic'
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'godlygeek/tabular'
Plug 'tmhedberg/matchit'
Plug 'Raimondi/delimitMate'
Plug 'wellle/tmux-complete.vim'
Plug 'tpope/vim-surround'
Plug 'ntpeters/vim-better-whitespace'

" Web
Plug 'pangloss/vim-javascript'
Plug 'mattn/emmet-vim'

" clang-format
Plug 'rhysd/vim-clang-format'

" Python
Plug 'tell-k/vim-autopep8'

" rustlang
Plug 'rust-lang/rust.vim'

" LISP
Plug 'kovisoft/slimv'

" LaTeX
Plug 'lervag/vimtex'

" Utils
Plug 'mhinz/vim-grepper'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'itchyny/vim-cursorword'
Plug 'rhysd/committia.vim'
Plug 'chrisbra/vim-diff-enhanced'

" LRU
Plug 'xolox/vim-misc'
Plug 'vim-scripts/a.vim'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" LSP (neovim 0.5.0+)
Plug 'neovim/nvim-lspconfig'

" distant, for remote editing
Plug 'chipsenkbeil/distant.nvim', {'branch': 'v0.3'}

call plug#end()

"""""""""""""""""""""""""""""""
set nocompatible

if &t_Co > 2 || has("gui_running")
	syntax on
endif

"256 color terminal
set t_Co=256

"longer history
set history=10000

"better commandline
set wildmenu

"proper tab completion behavior in command line
set wildmode=longest:full,full

"mouse support
set mouse=a

"case sensitive search when there's a capital letter
set ignorecase smartcase

"fix set backspace, vim8.0 causing backspace problem
set backspace=indent,eol,start

"tab/space stuff, insert 4 spaces with tab
"set tabstop=4
"set shiftwidth=4
"set softtabstop=0
set smarttab

" tabstop:          Width of tab character
" " softtabstop:      Fine tunes the amount of white space to be added
" " shiftwidth        Determines the amount of whitespace to add in normal
" mode
" " expandtab:        When on uses space instead of tabs
"" set tabstop     =4
"" set softtabstop =8
"" set shiftwidth  =4
"" set expandtab

"highlight tabs as >--, and trailing whitespace with -
set list
set listchars=tab:>-,trail:-

"buffers remember their states
set hidden

"search as it's being typed
set incsearch

"highlight search matches
set hlsearch

"s/././g by default
set gdefault

"do not wrap searches at the end of the files
set nowrapscan

"relative line numbers
set number
"set relativenumber

set cc=80

set autoindent
"set smartindent

set title
set ls=2

" use buffer the system clipboard by default.
set clipboard=unnamedplus

"start scrolling at 3rd row
set scrolloff=3

"default encoding
set encoding=utf-8
set fileencoding=utf-8

"show matching brackets as they're inserted
set showmatch

"preserve undo states, backup and undo files are kept in a single dir
set undofile
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set undodir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

"make vim more responsive
set lazyredraw
set ttyfast

"reduce ESC delay
set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value

"ignore whitespace in diffs (messes up Gdiff)
set diffopt+=iwhite

filetype plugin indent on
filetype plugin on
set ofu=syntaxcomplete#Complete

"custom mappings
let mapleader=","

"swap 0 and ^ behavior
noremap ^ 0
noremap 0 ^

"copy/paste clipboard
map <leader>y "+y
map <leader>p "+p

"disable highlight
nnoremap <leader><space> :noh<cr>
"remove trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

"disable f1
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

"switch between last buffer with space
nnoremap <space> <C-^>

"c-hjkl to move between splits
nnoremap <c-h> <C-w>h
nnoremap <c-j> <C-w>j
nnoremap <c-k> <C-w>k
nnoremap <c-l> <C-w>l

"shortcut for closing other splits
noremap <leader>o <C-w>o

"better command mode behavior for c-n and c-p
cnoremap <c-n>  <down>
cnoremap <c-p>  <up>

"move visually correct when line is wrapped
noremap j gj
noremap k gk

"center after certain movements
noremap * *zz
noremap # #zz
noremap n nzz
noremap N Nzz
noremap ]] ]]zz
noremap [[ [[zz
noremap {{ {{zz
noremap }} }}zz

"jk to go to normal mode
"inoremap jk <esc>

"disable new line comments with o
autocmd FileType * setlocal formatoptions-=o

"colorscheme set
set background=dark
colorscheme gruvbox
"colorscheme solarized

"highlight current line number with a different color
highlight Highlighted ctermfg=231 ctermbg=24 cterm=NONE
highlight! link CursorLineNr Highlighted

" Maximize quickfix windows' width
function! MaxQuickfixWin()
	if &buftype ==# "quickfix"
		execute "normal! \<c-w>J"
	endif
endfunction
augroup MaxQuickfixWinGrp
	autocmd!
	autocmd BufWinEnter * call MaxQuickfixWin()
augroup END

" Append modeline after last line in buffer.
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
	let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d %set :",
				\ &tabstop, &shiftwidth, &textwidth, &expandtab ? '' : 'no')
	let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
	call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

"auto close info buffer thing after completion
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

"plugin related configs start here
nnoremap <F6> :NERDTreeToggle<CR>
nnoremap <F7> :GundoToggle<CR>
nmap <F8> :TagbarToggle<CR>

" Emmet configs just for html css files
let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall"

" Easymotion configs All motions will then be triggered with <Leader>
" <Leader>s, <Leader>gE.
let g:EasyMotion_leader_key="t"
map <Leader> <Plug>(easymotion-prefix)
" Turn on case insensitive feature
let g:EasyMotion_smartcase = 1
"
" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

"cucumbertables for tabularize
"ref:https://gist.github.com/tpope/287147
inoremap <silent> <Bar>   <Bar><Esc>:call <SID>align()<CR>a
function! s:align()
	let p = '^\s*|\s.*\s|\s*$'
	if exists(':Tabularize') && getline('.') =~# '^\s*|' && (getline(line('.')-1) =~# p || getline(line('.')+1) =~# p)
		let column = strlen(substitute(getline('.')[0:col('.')],'[^|]','','g'))
		let position = strlen(matchstr(getline('.')[0:col('.')],'.*|\s*\zs.*'))
		Tabularize/|/l1
		normal! 0
		call search(repeat('[^|]*|',column).'\s\{-\}'.repeat('.',position),'ce',line('.'))
	endif
endfunction

" You can get the information about the windows with first argument as a dictionary.
"
"   KEY              VALUE                      AVAILABILITY
"-----------------------------------------------------------------------------------
"   vcs            : vcs type (e.g. 'git')   -> all hooks
"   edit_winnr     : winnr of edit window    -> ditto
"   edit_bufnr     : bufnr of edit window    -> ditto
"   diff_winnr     : winnr of diff window    -> ditto
"   diff_bufnr     : bufnr of diff window    -> ditto
"   status_winnr   : winnr of status window  -> all hooks except for 'diff_open' hook
"   status_bufnr   : bufnr of status window  -> ditto

let g:committia_hooks = {}
function! g:committia_hooks.edit_open(info)
	" Additional settings
	setlocal spell

	" If no commit message, start with insert mode
	if a:info.vcs ==# 'git' && getline(1) ==# ''
		startinsert
	end

	" Scroll the diff window from insert mode
	" Map <C-n> and <C-p>
	imap <buffer><C-n> <Plug>(committia-scroll-diff-down-half)
	imap <buffer><C-p> <Plug>(committia-scroll-diff-up-half)

endfunction

" clang-format options
let g:clang_format#command = "clang-format"
let g:clang_format#detect_style_file = 1

" map to <Leader>cf in C++ code
autocmd FileType c,cpp,objc nnoremap <buffer><Leader>cf :<C-u>ClangFormat<CR>
autocmd FileType c,cpp,objc vnoremap <buffer><Leader>cf :ClangFormat<CR>
" if you install vim-operator-user
autocmd FileType c,cpp,objc map <buffer><Leader>x <Plug>(operator-clang-format)
" Toggle auto formatting:
nmap <Leader>C :ClangFormatAutoToggle<CR>

" enchanced diff
" started In Diff-Mode set diffexpr (plugin not loaded yet)
if &diff
	let &diffexpr='EnhancedDiff#Diff("git diff", "--diff-algorithm=patience")'
endif

"custom trigger for snippets
" Trigger configuration. Do not use <tab> if you use
" https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

"syntastic checkers
let g:syntastic_python_checkers = ['pylint']
"let g:syntastic_python_checkers = ['pyflakes']
"let g:syntastic_python_checkers = ['pyflakes']
"let g:syntastic_python_checkers = ['pep8'asytags_suppress_ctags_warning = 1
"""""
"easytags configuration
let g:easytags_async=1
let g:easytags_auto_highlight=0
let g:easytags_on_cursorhold = 0 " disabled because it causes a recursive tag generation
let g:easytags_dynamic_files = 2"

"vim-airline stuff
"uncomment for regular fonts
let g:airline_powerline_fonts = 1
let g:Powerline_symbols='unicode'

"show file name without the path
let g:airline_section_c = '%t'

"disable whitespace check
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#hunks#enabled = 0
"let g:airline#extensions#tabline#enabled = 1

"enable markdown preview for grip rendering
let vim_markdown_preview_github=1
let vim_markdown_preview_hotkey='<C-m>'

"show only column number and percentage
let g:airline_section_z = '%3p%% %3v'
let g:airline_theme = 'light'
let g:airline_mode_map = {
			\ '__' : '-',
			\ 'n'  : 'N',
			\ 'i'  : 'I',
			\ 'R'  : 'R',
			\ 'c'  : 'C',
			\ 'v'  : 'V',
			\ 'V'  : 'V',
			\ '' : 'V',
			\ 's'  : 'S',
			\ 'S'  : 'S',
			\ '' : 'S',
			\ }
"""""

"multiplesearch config
nnoremap <leader>s :exe "Search ".expand('<cword>')<CR>
let g:MultipleSearchColorSequence = "blue,green,magenta,red,yellow,cyan,gray,brown"
let g:MultipleSearchMaxColors = 8
let g:MultipleSearchTextColorSequence = "white,white,white,white,black,white,black,white"
"code complete
let g:deoplete#enable_at_startup = 1
let g:gitgutter_max_signs = 2000
"slimv
let g:slimv_swank_cmd = '! tmux new-window -d -n REPL-SBCL "sbcl --load ~/.vim/bundle/slimv/slime/start-swank.lisp"'
let g:ctrlp_map = ''
nnoremap <c-p> :FZF<cr>

let g:tex_flavor = 'latex'

" Run setup functions for lua plugins
lua << EOF
--- Enable language servers for for LSP
require'lspconfig'.clangd.setup{} -- C/C++
require'lspconfig'.rust_analyzer.setup{} -- rustlang
require'lspconfig'.texlab.setup{} -- (La)TeX

--- Run distant setup
require("distant"):setup()
EOF

source $HOME/.local/config/nvim/init.vim
