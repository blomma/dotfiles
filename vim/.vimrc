set encoding=utf-8
scriptencoding utf-8

augroup vimrc
    autocmd!
augroup END

if has('nvim')
    if empty(glob('~/.config/nvim/autoload/plug.vim'))
        silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd vimrc VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    if empty(glob('~/.config/nvim/plugged'))
        autocmd vimrc VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('~/.config/nvim/plugged')
else
    if empty(glob('~/.vim/autoload/plug.vim'))
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
        autocmd vimrc VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    if empty(glob('~/.vim/plugged'))
        autocmd vimrc VimEnter * PlugInstall --sync | source $MYVIMRC
    endif
    call plug#begin('~/.vim/plugged')
endif

" Themes
Plug 'nanotech/jellybeans.vim'
Plug 'blomma/Zenburn'
Plug 'mhinz/vim-janah'
Plug 'arcticicestudio/nord-vim'
Plug 'AlessandroYorba/Despacio'
Plug 'AlessandroYorba/Sierra'

" Languages
Plug 'kmnk/vim-csharp'
Plug 'dag/vim-fish'
Plug 'Keithbsmiley/swift.vim'
Plug 'plasticboy/vim-markdown'
Plug 'neomutt/neomutt.vim'
Plug 'hrother/offlineimaprc.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ekalinin/Dockerfile.vim'
Plug 'irrationalistic/vim-tasks'
Plug 'neoclide/jsonc.vim'

" Tmux
Plug 'christoomey/vim-tmux-navigator'

" Airline provides a stylish appearance for the styleline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Provides Sublime-Text like smart completion of braces, parens and such
Plug 'Raimondi/delimitMate'

" Git
Plug 'tpope/vim-git'

" Provides easy shortcuts for commenting out lines
Plug 'tpope/vim-commentary'

Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
Plug 'scrooloose/nerdtree'
Plug 'Lokaltog/vim-easymotion'
Plug 'ntpeters/vim-better-whitespace'
Plug 'ervandew/supertab'
Plug 'jeetsukumaran/vim-buffergator'

Plug 'reedes/vim-pencil'
Plug 'reedes/vim-litecorrect'
Plug 'kana/vim-textobj-user'
Plug 'reedes/vim-textobj-quote'
Plug 'rhysd/vim-grammarous'

Plug 'mhinz/vim-startify'

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
Plug 'junegunn/fzf.vim'
Plug 'farmergreg/vim-lastplace'

Plug 'zchee/deoplete-go', { 'do': 'make'}

if has('nvim')
    Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
else
    Plug 'Shougo/deoplete.nvim'
    Plug 'roxma/nvim-yarp'
    Plug 'roxma/vim-hug-neovim-rpc'
endif

" Lint
" Plug 'w0rp/ale'

call plug#end()

" -------------------------------------------------------------------
" Appearance
" -------------------------------------------------------------------
syntax on
syntax enable
set noshowmode	" Let airline handle the mode display
set ttyfast
set termguicolors

if &term =~? '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

if &term =~? 'xterm-kitty'
    set t_ut=
endif
" -------------------------------------------------------------------
" Basic Setup
" -------------------------------------------------------------------
set ruler			  " Show line and column number
set termencoding=utf-8
let mapleader=','
set history=1000				" Store lots of :cmdline history
set showcmd						" Show incomplete cmds down the bottom
set guicursor=a:blinkon0		" Disable cursor blink
set laststatus=2				" Always show status line
set hidden						" Buffers can exist in the background
set splitright					" Opens vertical split right of current window
set splitbelow					" Opens horizontal split below current window
set shortmess=atToOI		" see :help shortmess
set backspace=indent,eol,start	  " backspace through everything in insert mode
set nrformats-=octal
set autowrite
set diffopt+=iwhite
set whichwrap+=<,>,l,h,[,]

if has('win32') || has('win16') || has('win32unix')
    set fileformats=unix,dos
    set fileformat=unix
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

if exists(':tnoremap')
    tnoremap <Esc> <C-\><C-n>
endif
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
set expandtab
set formatoptions+=j " Delete comment character when joining commented lines

" -------------------------------------------------------------------
" Copy/Paste
" -------------------------------------------------------------------
" " Copy to clipboard
vnoremap  <leader>y  "+y
nnoremap  <leader>Y  "+yg_
nnoremap  <leader>y  "+y
nnoremap  <leader>yy  "+yy

" " Paste from clipboard
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

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
nnoremap <leader>ev <C-w><C-s><C-l>:e ~/.vimrc<cr>

map <F7> mzgg=G`z

" Fast saving
nmap <leader>w :w!<cr>

map <C-n> :cnext<CR>
map <C-m> :cprevious<CR>
nnoremap <leader>a :cclose<CR>
autocmd vimrc BufReadPost quickfix nnoremap <buffer> <CR> <CR>

" Quickly open a buffer for scribble
map <leader>t :tabnew<cr>

" Toggle paste mode on and off
map <leader>pp :setlocal paste!<cr>

map <C-a> <esc>ggVG<CR>

" -------------------------------------------------------------------
" Deoplete
" -------------------------------------------------------------------
let g:deoplete#enable_at_startup = 0
augroup deoplete
    autocmd!
    autocmd FileType markdown,mkd,md,*gitcommit*,*GITCOMMIT*
                \ call deoplete#custom#buffer_option('auto_complete', v:false)
    autocmd FileType go,vim
                \ call deoplete#enable()
augroup END

" -------------------------------------------------------------------
" FZF
" -------------------------------------------------------------------
let g:fzf_layout = { 'left': '~40%' }
augroup fzf
    autocmd! FileType fzf
    autocmd  FileType fzf set laststatus=0 noshowmode noruler
                \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

" -------------------------------------------------------------------
" Tasks
" -------------------------------------------------------------------
let g:TasksMarkerBase = '-'
let g:TasksMarkerDone = '+'
let g:TasksMarkerCancelled = 'x'

" -------------------------------------------------------------------
" Go
" -------------------------------------------------------------------
let g:go_list_type = 'quickfix'
let g:go_fmt_command = 'goimports'

let g:go_highlight_build_constraints = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_generate_tags = 1
let g:go_highlight_methods = 1
let g:go_highlight_operators = 1
let g:go_highlight_structs = 1
let g:go_highlight_types = 1
let g:go_auto_sameids = 1
let g:go_auto_type_info = 1

augroup go
    autocmd!
    autocmd FileType go set noexpandtab
    autocmd FileType go nmap <leader>gd <Plug>(go-doc)
    autocmd FileType go nmap <leader>gv <Plug>(go-doc-vertical)
    autocmd FileType go nmap <leader>gb <Plug>(go-doc-browser)
    autocmd FileType go nmap <leader>e <Plug>(go-rename)
    autocmd FileType go nmap <leader>gt :GoDeclsDir<cr>
    autocmd FileType go nmap <F12> <Plug>(go-def)
    autocmd FileType go nmap <F8> <Plug>(go-metalinter)
augroup END

let g:go_metalinter_deadline = '5s'
" let g:go_metalinter_enabled = [
"             \ 'deadcode',
"             \ 'errcheck',
"             \ 'gas',
"             \ 'goconst',
"             \ 'gocyclo',
"             \ 'golint',
"             \ 'gosimple',
"             \ 'ineffassign',
"             \ 'vet',
"             \ 'vetshadow'
"             \]

" -------------------------------------------------------------------
" Better whitespace
" -------------------------------------------------------------------
let g:better_whitespace_filetypes_blacklist = ['git', 'diff', 'gitcommit', 'Mail']

" -------------------------------------------------------------------
" Pencil
" -------------------------------------------------------------------
let g:pencil#wrapModeDefault = 'soft'   " default is 'hard'
augroup pencil
    autocmd!
    autocmd FileType markdown,mkd,md
                \ call pencil#init({'wrap': 'soft', 'textwidth': 72, 'autoformat': 0})
                \ | call litecorrect#init()
                \ | call textobj#quote#init()
    autocmd FileType text
                \ call pencil#init()
                \ | call litecorrect#init()
                \ | call textobj#quote#init()
    autocmd Filetype *gitcommit*,*GITCOMMIT*
                \ call pencil#init({'wrap': 'hard', 'textwidth': 72, 'autoformat': 0})
                \ | call litecorrect#init()
    autocmd Filetype tasks
                \ call pencil#init({'wrap': 'soft', 'textwidth': 72, 'autoformat': 0})
augroup END

nnoremap <silent> Q gqap
xnoremap <silent> Q gq
nnoremap <silent> <leader>Q vapJgqap

" -------------------------------------------------------------------
" Grammarous
" -------------------------------------------------------------------
let g:grammarous#default_comments_only_filetypes = {
            \ '*' : 1, 'help' : 0, 'markdown' : 0,
            \ }

" -------------------------------------------------------------------
" Mail
" -------------------------------------------------------------------
function! IsReply()
    if line('$') > 1
        :1
        :put! =\"\n\"
        :1
    endif
    :startinsert
endfunction

augroup mail
    autocmd!
    autocmd FileType Mail
                \ setlocal fo+=cqlaw
                \ tw=72
                \ colorcolumn=+1
                \ expandtab
                \ nosmartindent
                \ noautoindent
                \ linebreak
                \ comments+=n:>
                \ nobackup
                \ noswapfile
                \ nowritebackup
    autocmd FileType Mail :call IsReply()
augroup END

" -------------------------------------------------------------------
" Complete
" -------------------------------------------------------------------
set complete=.,w,b,u,t

" Complete options (disable preview scratch window)
set completeopt=menuone,longest

" Limit popup menu height
set pumheight=15

" SuperTab option for context aware completion
let g:SuperTabDefaultCompletionType = 'context'

" -------------------------------------------------------------------
" Wrap
" -------------------------------------------------------------------
set wrap linebreak nolist
set breakindent
set breakindentopt=shift:5

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
augroup whitespace
    autocmd!
    autocmd BufWritePre * StripWhitespace
augroup END

" -------------------------------------------------------------------
" Fish
" -------------------------------------------------------------------
augroup fish
    autocmd!
    autocmd FileType fish compiler fish
    autocmd FileType fish setlocal textwidth=79
    autocmd FileType fish setlocal foldmethod=expr
augroup END

" -------------------------------------------------------------------
" Airline
" -------------------------------------------------------------------
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = '☰'
let g:airline_symbols.maxlinenr = ''

" unicode symbols
let g:airline_symbols.crypt = '🔒'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.spell = 'Ꞩ'
let g:airline_symbols.notexists = '∄'
let g:airline_symbols.whitespace = 'Ξ'

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
" Ale
" -------------------------------------------------------------------
let g:ale_lint_delay = 1000
let g:ale_sign_warning = '──'
let g:ale_sign_error = '══'

let g:airline#extensions#ale#enabled = 1

" -------------------------------------------------------------------
" Goyo
" -------------------------------------------------------------------
nnoremap <Leader><Space> :Goyo<CR>

let g:goyo_margin_top = 2
let g:goyo_margin_bottom = 2

function! s:goyo_enter()
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    set noshowcmd
    set scrolloff=999
    Limelight
endfunction

function! s:goyo_leave()
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    set showcmd
    set scrolloff=5
    Limelight!
endfunction

augroup Goyo
    autocmd! User GoyoEnter nested call <SID>goyo_enter()
    autocmd! User GoyoLeave nested call <SID>goyo_leave()
augroup END

" -------------------------------------------------------------------
" Limelight
" -------------------------------------------------------------------
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240
let g:limelight_paragraph_span = 0
let g:limelight_priority = -1

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
colorscheme sierra
let g:airline_theme='nord'

" -------------------------------------------------------------------
" Markdown
" -------------------------------------------------------------------
let g:vim_markdown_frontmatter = 1

