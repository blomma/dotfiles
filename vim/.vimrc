set nocompatible	  " Use vim, no vi defaults

if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Themes
Plug 'nanotech/jellybeans.vim'
Plug 'blomma/Zenburn'

" MS
Plug 'kmnk/vim-csharp'

" Javascript
Plug 'pangloss/vim-javascript'

" Fish
Plug 'dag/vim-fish'

" Json
Plug 'elzr/vim-json'

" Swift
Plug 'Keithbsmiley/swift.vim'

" Markdown
Plug 'plasticboy/vim-markdown'

" Tmux
Plug 'keith/tmux.vim'
Plug 'christoomey/vim-tmux-navigator'

" Airline provides a stylish appearance for the styleline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Provides Sublime-Text like smart completion of braces, parens and such
Plug 'Raimondi/delimitMate'

" Git
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-git'

" Provides easy shortcuts for commenting out lines
Plug 'tpope/vim-commentary'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'tpope/vim-vinegar'
Plug 'Lokaltog/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ervandew/supertab'
Plug 'ekoeppen/taskpaper.vim'
Plug 'jeetsukumaran/vim-buffergator'

Plug 'reedes/vim-pencil'
Plug 'reedes/vim-lexical'
Plug 'reedes/vim-litecorrect'
Plug 'kana/vim-textobj-user'
Plug 'reedes/vim-textobj-quote'
Plug 'mhinz/vim-grepper'
Plug 'ekalinin/Dockerfile.vim'

Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
Plug 'godoctor/godoctor.vim'

if has("win32") || has("win16") || has("win32unix")
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'lion19/ctrlp-modified.vim'
else
	Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
	Plug 'junegunn/fzf.vim'
endif

call plug#end()

" -------------------------------------------------------------------
" Appearance
" -------------------------------------------------------------------
syntax on
syntax enable
set noshowmode	" Let airline handle the mode display
set ttyfast

if &term =~ '256color'
	" Disable Background Color Erase (BCE) so that color schemes
	" work properly when Vim is used inside tmux and GNU screen.
	set t_ut=
endif

" -------------------------------------------------------------------
" Basic Setup
" -------------------------------------------------------------------
set ruler			  " Show line and column number
set encoding=utf-8	  " Set default encoding to UTF-8
set termencoding=utf-8
let mapleader=","
set history=1000				" Store lots of :cmdline history
set showcmd						" Show incomplete cmds down the bottom
set gcr=a:blinkon0				" Disable cursor blink
set laststatus=2				" Always show status line
set hidden						" Buffers can exist in the background
set splitright					" Opens vertical split right of current window
set splitbelow					" Opens horizontal split below current window
set shortmess=filnxtToOI		" see :help shortmess
set backspace=indent,eol,start	  " backspace through everything in insert mode
set nrformats-=octal
set autowrite

if has("win32") || has("win16") || has("win32unix")
	set fileformats=unix,dos
	set fileformat=unix
	" autocmd Filetype gitcommit setlocal fileformat=dos
else
	set fileformats+=mac
endif

" dont save .netrwhist history
let g:netrw_dirhistmax=0

" Time out on key codes but not mappings.
" Basically this makes terminal Vim work sanely.
set notimeout
set ttimeout
set ttimeoutlen=10

" -------------------------------------------------------------------
" Mouse
" -------------------------------------------------------------------
set mouse=a

" -------------------------------------------------------------------
" Indentation and Display
" -------------------------------------------------------------------
set autoindent
set smartindent
set smarttab
set shiftwidth=4
set softtabstop=4
set tabstop=4
set showmatch

set formatoptions+=j " Delete comment character when joining commented lines

" -------------------------------------------------------------------
" Folds
" -------------------------------------------------------------------
set foldmethod=indent	" Fold based on indent
set foldnestmax=3		" Deepest fold is 3 levels
set nofoldenable		" Don't fold by default

" -------------------------------------------------------------------
" Searching
" -------------------------------------------------------------------
set hlsearch	" highlight matches
set incsearch	" incremental searching
set ignorecase	" searches are case insensitive...
set smartcase	" ... unless they contain at least one capital letter

" remove search highlighting with /
nnoremap <silent> <leader>/ :nohlsearch<CR>

" -------------------------------------------------------------------
" Wild settings
" -------------------------------------------------------------------
set wildmenu					" Enable ctrl-n and ctrl-p to scroll thru matches
set wildmode=list:full

" Version control
set wildignore+=.hg,.git,.svn

" MacOS
set wildignore+=*.DS_Store

" Disable output
set wildignore+=*.o,*.out,*.obj,*.rbc,*.rbo,*.class,*.gem

" Disable archive files
set wildignore+=*.zip,*.tar.gz,*.tar.bz2,*.rar,*.tar.xz

" Disable temp and backup files
set wildignore+=*.swp,*~,._*

" Merge resolution files
set wildignore+=*.orig

" -------------------------------------------------------------------
" Scrolling
" -------------------------------------------------------------------
set scrolloff=10
set sidescrolloff=15
set sidescroll=1

" -------------------------------------------------------------------
" Turn Off Swap Files
" -------------------------------------------------------------------
set noswapfile
set nobackup
set nowritebackup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp

" -------------------------------------------------------------------
" Custom Commands
" -------------------------------------------------------------------

" ,rr => refresh vimrc
map <leader>rr :source ~/.vimrc<CR>

" ,q rewrap pargrahp textmate style
nnoremap <leader>q gqip

" ,ev open .vimrc in a vertical split
nnoremap <leader>ev <C-w><C-s><C-l>:e $MYVIMRC<cr>

map <F7> mzgg=G`z

" Fast saving
nmap <leader>w :w!<cr>

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>

" -------------------------------------------------------------------
" Go
" -------------------------------------------------------------------
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"
let g:go_highlight_types = 0
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 0
let g:go_highlight_extra_types = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_generate_tags = 1
let g:go_auto_sameids = 1

au FileType go nmap <leader>gd <Plug>(go-doc)
au FileType go nmap <leader>gv <Plug>(go-doc-vertical)
au FileType go nmap <leader>gb <Plug>(go-doc-browser)
au FileType go nmap <leader>e <Plug>(go-rename)

" -------------------------------------------------------------------
" Better whitespace
" -------------------------------------------------------------------
let g:better_whitespace_filetypes_blacklist = ['git', 'diff', 'gitcommit', 'mail']

" -------------------------------------------------------------------
" Ctrlp
" -------------------------------------------------------------------
let g:ctrlp_custom_ignore = {
	\ 'dir': '\v[\/](\.git|\.hg|\.svn|node_modules|\.sass-cache|bower_components|build)$',
	\ 'file': '\v\.(exe|so|dll)$',
	\ }

" -------------------------------------------------------------------
" Pencil
" -------------------------------------------------------------------
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
augroup pencil
	autocmd!
	autocmd FileType markdown,mkd,md
				\ call pencil#init({'wrap': 'hard', 'textwidth': 72, 'autoformat': 0})
				\ | call lexical#init()
				\ | call litecorrect#init()
				\ | call textobj#quote#init()
	autocmd FileType text
				\ call pencil#init()
				\ | call lexical#init()
				\ | call litecorrect#init()
				\ | call textobj#quote#init()
	autocmd Filetype *commit*,*COMMIT*
				\ call pencil#init({'wrap': 'hard', 'textwidth': 72, 'autoformat': 0})
				\ | call litecorrect#init()
augroup END

nnoremap <silent> Q gqap
xnoremap <silent> Q gq
nnoremap <silent> <leader>Q vapJgqap

" -------------------------------------------------------------------
" Complete
" -------------------------------------------------------------------
set complete=.,w,b,u,t

" Complete options (disable preview scratch window)
set completeopt=menuone,longest

" Limit popup menu height
set pumheight=15

" SuperTab option for context aware completion
let g:SuperTabDefaultCompletionType = "context"

" -------------------------------------------------------------------
" Wrap
" -------------------------------------------------------------------
set wrap linebreak nolist
set breakindent
set breakindentopt=shift:5

autocmd InsertEnter * set nowrap
autocmd InsertLeave * set wrap linebreak nolist

" -------------------------------------------------------------------
" Buffergator
" -------------------------------------------------------------------
let g:buffergator_suppress_keymaps = 1
nnoremap <silent> <Leader>b :BuffergatorOpen<CR>
nnoremap <silent> <Leader>B :BuffergatorClose<CR>

" -------------------------------------------------------------------
" Delimitmate
" -------------------------------------------------------------------
let g:delimitMate_expand_cr = 1
let g:delimitMate_expand_space = 1
let g:delimitMate_smart_quotes = 1
let g:delimitMate_expand_inside_quotes = 0
let g:delimitMate_smart_matchpairs = '^\%(\w\|\$\)'

" -------------------------------------------------------------------
" Whitespace
" -------------------------------------------------------------------
autocmd BufWritePre * StripWhitespace

" -------------------------------------------------------------------
" Fish
" -------------------------------------------------------------------
autocmd FileType fish compiler fish
autocmd FileType fish setlocal textwidth=79
autocmd FileType fish setlocal foldmethod=expr

" -------------------------------------------------------------------
" Airline
" -------------------------------------------------------------------
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

let g:airline#extensions#wordcount#enabled = 0

" -------------------------------------------------------------------
" Goyo
" -------------------------------------------------------------------
nnoremap <Leader><Space> :Goyo<CR>

let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2

function! GoyoBefore()
	if exists('$TMUX')
		silent !tmux set status off
	endif

	set showmode
	set noshowcmd
	set scrolloff=999
endfunction

function! GoyoAfter()
	if exists('$TMUX')
		silent !tmux set status on
	endif

	set noshowmode
	set showcmd
	set scrolloff=5
endfunction

let g:goyo_callbacks = [function('GoyoBefore'), function('GoyoAfter')]

" -------------------------------------------------------------------
" Limelight
" -------------------------------------------------------------------
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

autocmd! User GoyoEnter Limelight
autocmd! User GoyoLeave Limelight!

" -------------------------------------------------------------------
" Easymotion
" -------------------------------------------------------------------
nmap s <Plug>(easymotion-s2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)

" These `n` & `N` mappings are options. You do not have to map `n` & `N` to
" EasyMotion.
" Without these mappings, `n` & `N` works fine. (These mappings just provide
" different highlight method and have some other features )
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)

map <Leader>l <Plug>(easymotion-lineforward)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
map <Leader>h <Plug>(easymotion-linebackward)

let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion

" -------------------------------------------------------------------
" Theme
" -------------------------------------------------------------------
let g:jellybeans_overrides = {
	\    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
	\}
colorscheme zenburn

" -------------------------------------------------------------------
" Markdown
" -------------------------------------------------------------------
let g:vim_markdown_frontmatter = 1

