set encoding=utf-8
scriptencoding utf-8
set fileencoding=utf-8          " The encoding written to file
set termencoding=utf-8

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
endif

" Themes
Plug 'AlessandroYorba/Sierra'
Plug 'arcticicestudio/nord-vim'
Plug 'blomma/Zenburn'
Plug 'mhinz/vim-janah'
Plug 'nanotech/jellybeans.vim'
Plug 'nightsense/snow'
Plug 'blasco/vim-corvine'
Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }

" Languages
Plug 'dag/vim-fish'
Plug 'plasticboy/vim-markdown'
Plug 'neomutt/neomutt.vim'
Plug 'hrother/offlineimaprc.vim'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
Plug 'ekalinin/Dockerfile.vim'
Plug 'irrationalistic/vim-tasks'
Plug 'neoclide/jsonc.vim'
Plug 'andmatand/vim-pico8-syntax'
Plug 'OmniSharp/omnisharp-vim'
Plug 'keith/swift.vim'

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

Plug 'farmergreg/vim-lastplace'

Plug 'camspiers/animate.vim'
Plug 'camspiers/lens.vim'
Plug 'dense-analysis/ale'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'justinmk/vim-sneak'

call plug#end()

" -------------------------------------------------------------------
" Appearance
" -------------------------------------------------------------------
syntax on
syntax enable
set noshowmode	" Let airline handle the mode display
set termguicolors

if &term =~? '256color'
    " Disable Background Color Erase (BCE) so that color schemes
    " work properly when Vim is used inside tmux and GNU screen.
    set t_ut=
endif

" -------------------------------------------------------------------
" Basic Setup
" -------------------------------------------------------------------
let mapleader=','
set autowrite
set backspace=indent,eol,start	" backspace through everything in insert mode
set cmdheight=2                 " More space for displaying messages
set diffopt+=iwhite
set guicursor=a:blinkon0		" Disable cursor blink
set hidden						" Buffers can exist in the background
set history=1000				" Store lots of :cmdline history
set iskeyword+=-                " treat dash separated words as a word text object"
set laststatus=2				" Always show status line
set nrformats-=octal
set ruler			            " Show line and column number
set shortmess=atToOI		    " see :help shortmess
set showcmd						" Show incomplete cmds down the bottom
set splitbelow					" Opens horizontal split below current window
set splitright					" Opens vertical split right of current window
set whichwrap+=<,>,l,h,[,]
set t_Co=256                    " Support 256 colors
set conceallevel=0              " So that I can see `` in markdown files

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
set clipboard=unnamedplus               " Copy paste between vim and everything else

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
" Mappings
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

" Better window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" Better tabbing
vnoremap < <gv
vnoremap > >gv

" -------------------------------------------------------------------
" Sneak
" -------------------------------------------------------------------
let g:sneak#label = 1

" -------------------------------------------------------------------
" C#
" -------------------------------------------------------------------
" Use the stdio OmniSharp-roslyn server
let g:OmniSharp_server_stdio = 1

" Set the type lookup function to use the preview window instead of echoing it
" let g:OmniSharp_typeLookupInPreview = 1

" Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 5

" Don't autoselect first omnicomplete option, show options even if there is only
" one (so the preview documentation is accessible). Remove 'preview' if you
" don't want to see any documentation whatsoever.
" set completeopt=longest,menuone,preview

" Fetch full documentation during omnicomplete requests.
" By default, only Type/Method signatures are fetched. Full documentation can
" still be fetched when you need it with the :OmniSharpDocumentation command.
"let g:omnicomplete_fetch_full_documentation = 1

" Set desired preview window height for viewing documentation.
" You might also want to look at the echodoc plugin.
set previewheight=5

" Tell ALE to use OmniSharp for linting C# files, and no other linters.
let g:ale_linters = { 'cs': ['OmniSharp'] }

" Update semantic highlighting after all text changes
let g:OmniSharp_highlight_types = 0
" Update semantic highlighting on BufEnter and InsertLeave
" let g:OmniSharp_highlight_types = 2

augroup omnisharp_commands
    autocmd!

    autocmd FileType cs set ut=500
    " Show type information automatically when the cursor stops moving.
    " Note that the type is echoed to the Vim command line, and will overwrite
    " any other messages in this space including e.g. ALE linting messages.
    autocmd CursorHold *.cs OmniSharpTypeLookup

    " The following commands are contextual, based on the cursor position.
    autocmd FileType cs nnoremap <buffer> gd :OmniSharpGotoDefinition<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fi :OmniSharpFindImplementations<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fs :OmniSharpFindSymbol<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>fu :OmniSharpFindUsages<CR>

    " Finds members in the current buffer
    autocmd FileType cs nnoremap <buffer> <Leader>fm :OmniSharpFindMembers<CR>

    autocmd FileType cs nnoremap <buffer> <Leader>fx :OmniSharpFixUsings<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>tt :OmniSharpTypeLookup<CR>
    autocmd FileType cs nnoremap <buffer> <Leader>dc :OmniSharpDocumentation<CR>
    autocmd FileType cs nnoremap <buffer> <C-\> :OmniSharpSignatureHelp<CR>
    autocmd FileType cs inoremap <buffer> <C-\> <C-o>:OmniSharpSignatureHelp<CR>

    " Navigate up and down by method/property/field
    " autocmd FileType cs nnoremap <buffer> <C-k> :OmniSharpNavigateUp<CR>
    " autocmd FileType cs nnoremap <buffer> <C-j> :OmniSharpNavigateDown<CR>

    " Find all code errors/warnings for the current solution and populate the quickfix window
    autocmd FileType cs nnoremap <buffer> <Leader>cc :OmniSharpGlobalCodeCheck<CR>
augroup END

" Contextual code actions (uses fzf, CtrlP or unite.vim when available)
nnoremap <Leader><Space> :OmniSharpGetCodeActions<CR>
" Run code actions with text selected in visual mode to extract method
xnoremap <Leader><Space> :call OmniSharp#GetCodeActions('visual')<CR>

" Rename with dialog
nnoremap <Leader>nm :OmniSharpRename<CR>
nnoremap <F2> :OmniSharpRename<CR>
" Rename without dialog - with cursor on the symbol to rename: `:Rename newname`
command! -nargs=1 Rename :call OmniSharp#RenameTo("<args>")

nnoremap <Leader>cf :OmniSharpCodeFormat<CR>

" Start the omnisharp server for the current solution
nnoremap <Leader>ss :OmniSharpStartServer<CR>
nnoremap <Leader>sp :OmniSharpStopServer<CR>

" Enable snippet completion
" let g:OmniSharp_want_snippet=1
" -------------------------------------------------------------------
" NERDTree
" -------------------------------------------------------------------
nnoremap <Leader>f :NERDTreeToggle<Enter>
noremap <silent> <Leader>v :NERDTreeFind<CR>

" Ignore some stuff
let NERDTreeIgnore = ['.git$', '^node_modules', 'undodir']

" Enable minimal ui
let g:NERDTreeMinimalUI = 1

" Enable cursorline highlighting
let g:NERDTreeHighlightCursorline = 1

" Enable folder highlighting
let g:NERDTreeHighlightFolders = 1

" Set NERDTree size
let g:NERDTreeWinSize = 30

" Set NERDTree statusline
let g:NERDTreeStatusline = -1

" Automatically close nerdtree when opening a file
let NERDTreeQuitOnOpen = 1

" Automatically delete buffer if files deleted in nerdtree
let NERDTreeAutoDeleteBuffer = 1

let NERDTreeShowHidden = 1

" -------------------------------------------------------------------
" Tasks
" -------------------------------------------------------------------
let g:TasksMarkerBase = '-'
let g:TasksMarkerDone = '-'
let g:TasksMarkerCancelled = 'x'
let g:TasksDateFormat = '%Y-%m-%d'

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
                \ call pencil#init({'wrap': 'hard', 'textwidth': 72, 'autoformat': 1})
                \ | call litecorrect#init()
    autocmd Filetype tasks
                \ call pencil#init({'wrap': 'soft', 'textwidth': 72, 'autoformat': 0})
augroup END

nnoremap <silent> Q gqap
xnoremap <silent> Q gq
nnoremap <silent> <leader>Q vapJgqap

" -------------------------------------------------------------------
" Mail
" -------------------------------------------------------------------

augroup mail
    autocmd!
    autocmd FileType Mail
                \ setl fo=jnawrtcq
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
    autocmd FileType Mail :exe 'startinsert'
augroup END

" -------------------------------------------------------------------
" Complete
" -------------------------------------------------------------------
set complete=.,w,b,u,t

" Complete options (disable preview scratch window)
" set completeopt=menuone,longest
set completeopt=longest,menuone,preview

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
let g:airline_symbols.maxlinenr = ''

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
let g:airline_theme='deus'

" -------------------------------------------------------------------
" Goyo
" -------------------------------------------------------------------
" nnoremap <Leader><Space> :Goyo<CR>

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
" Markdown
" -------------------------------------------------------------------
let g:vim_markdown_frontmatter = 1

" -------------------------------------------------------------------
" Theme
" -------------------------------------------------------------------
let g:jellybeans_overrides = {
            \    'background': { 'ctermbg': 'none', '256ctermbg': 'none' },
            \}
colorscheme challenger_deep
