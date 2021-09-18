runtime! debian.vim

" Check file change every 4 seconds ('CursorHold') and reload the buffer upon detecting change
set autoread
au CursorHold * silent! checktime

" For when I accidentally do :W instead of :w or :Q instead of :q
command W w
command Q q

" Some more command bandaids for my sloppy typing
" Apparently this is frowned upon but oh well
cnoreabbrev we w
cnoreabbrev qw wq
cnoreabbrev Q! q!

" Let ctrl+backspace or ctrl+h delete a work in insert mode
noremap! <C-BS> <C-w>
noremap! <C-h> <C-w>

" Persistent undo
" See: ~/.vim/undo/
set undofile                " Save undos after file closes
if has ("nvim")
    set undodir=$HOME/nvim/undo
else
    set undodir=$HOME/.vim/undo " where to save undo histories
endif
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo

" Colors, syntax highlighting, and terminal emulator things
syntax on
autocmd BufEnter * :syntax sync fromstart
set background=dark
set t_Co=256
set termguicolors


" For italic comments
augroup colorscheme_change | au!
    au ColorScheme gruvbox hi Comment gui=italic cterm=italic
augroup END

" Colorscheme specifics
let g:gruvbox_guisp_fallback = "bg"
colorscheme gruvbox

" Quickly highlight text I copy
let g:highlightedyank_highlight_duration = 275

" Cursor stuff
" TODO: do I need this?
set cursorline
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

" Resume editing at last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Delete trailing whitespace and empty lines at end of file
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

" Nicer splits
set splitbelow

" Jump to start and end of line using the home row keys
" Works with yank, replace, delete, etc actions
map H ^
map L $

" Move text relative to the cursor on searches, not vice-versa
" Nicer for cycling through search results
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zzzv

" Nice but can be annoying when not full screen
set sidescrolloff=10

filetype plugin indent on

" Basic configs and stuff that just kinda got added over time
set showmatch
set matchpairs+=<:> " STL brackets go brrr
set ignorecase
set smartcase
set incsearch
set hls
set hidden
set mouse=a
set number
set encoding=UTF-8
set fileencoding=utf-8
set numberwidth=1
set ts=4 sw=4
set expandtab
set noerrorbells
set smartindent
set noswapfile
set nowrap
highlight clear SignColumn

" Command autocompletion
set wildmode=longest,list,full

" Double press <esc> to clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Toggle relative line number with <leader>l
nmap <leader>l :set invrelativenumber<CR>

" Better indentation of selected blocks
" Literally why is this not the default behavior
vnoremap < <gv
vnoremap > >gv

" Automatically closing braces
inoremap {<CR> {<CR>}<Esc>ko
inoremap [<CR> [<CR>]<Esc>ko
inoremap (<CR> (<CR>)<Esc>ko

" Better way to move between splits
" Note: same as tmux config just without the prefix
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Same idea, but for moving a split
map <A-j> <C-W>J
map <A-k> <C-W>K
map <A-h> <C-W>H
map <A-l> <C-W>L

set fillchars=vert:│

" Plugins
	call plug#begin('~/.vim/autoload')
    Plug 'itchyny/lightline.vim'
    Plug 'shinchu/lightline-gruvbox.vim'
    Plug 'preservim/nerdtree' |
            \ Plug 'Xuyuanp/nerdtree-git-plugin' |
            \ Plug 'ryanoasis/vim-devicons'
	Plug 'tpope/vim-markdown'
	Plug 'preservim/nerdcommenter'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'dense-analysis/ale'
    Plug 'preservim/tagbar'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'coreyja/fzf.devicon.vim'
    Plug 'ap/vim-buftabline'
    Plug 'Yggdroot/indentLine'
    Plug 'rust-lang/rust.vim'
    Plug 'pangloss/vim-javascript'
    Plug 'cpiger/NeoDebug'
    Plug 'machakann/vim-highlightedyank'
    Plug 'voldikss/vim-floaterm'
    Plug 'kkoomen/vim-doge', { 'do': { -> doge#install() } }
    Plug 'fatih/vim-go'
    Plug 'unblevable/quick-scope'
    Plug 'tpope/vim-fugitive'
    Plug 'jaxbot/semantic-highlight.vim'
	call plug#end()

" Jump between .c* and .h* files with leader+h
" Note this is in ~/.vim/plugin, not through vimplug
map <leader>h :call CurtineIncSw()<CR>

" Statusline config
let g:lightline = {}

function! MyLineinfo()
  return line('.') . '/' . line('$') . ' :: ' . col('.')
  endfunction

function! MyFiletype()
  return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
endfunction

function! MyFileformat()
  return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
endfunction

function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! GitInfo()
    " Don't show git info if not in a git repo
    return fugitive#head() == '' ? '' : ' ' . FugitiveHead()
endfunction

autocmd User CocStatusChange,CocDiagnosticChange call lightline#update()

let g:lightline = {
            \ 'component_function': {
            \     'lineinfo': 'MyLineinfo',
            \     'fileformat': 'MyFileformat',
            \     'gitbranch': 'GitInfo'
            \ },
            \ 'separator': { 'left': '', 'right': '' },
            \ 'subseparator': { 'left': '', 'right': '' },
            \ 'cocstatus': 'coc#status',
            \   'currentfunction': 'CocCurrentFunction'
            \ }


let g:lightline.active = {
    \ 'left': [ [ 'mode'],
    \           [ 'cocstatus', 'currentfunction', 'readonly', 'filename', 'gitbranch', 'modified' ] ],
    \ 'right': [ [ 'lineinfo' ],
    \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }
let g:lightline.inactive = {
    \ 'left': [ [ 'filename' ] ],
    \ 'right': [ [ 'lineinfo' ]]}
let g:lightline.tabline = {
    \ 'left': [ [ 'tabs' ] ],
    \ 'right': [ [ 'close' ] ] }

let g:lightline.colorscheme = 'gruvbox'

" Nerdcommenter plugin settings
    " Add spaces after comment delimiters by default
    " (fixes issue with Haskell guards)
    let g:NERDSpaceDelims = 1
    let g:NERDCommentEmptyLines = 1
    let g:NERDDefaultAlign = 'left'

    " Enable trimming of trailing whitespace when uncommenting
    let g:NERDTrimTrailingWhitespace = 1

" NerdTree plugin settings
	" Toggle NerdTree with <F6>
	nnoremap <silent> <expr> <F6> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

	" Start Vim in the editor, not the file explorer
    autocmd VimEnter * wincmd p
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Fixes issues with file icons in NerdTree
	if exists("g:loaded_webdevicons")
		call webdevicons#refresh()
	endif

    let g:NERDTreeGitStatusUseNerdFonts = 1 " you should install nerdfonts by yourself. default: 0


	" Hide certain files in the NerdTree view
	set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
	let NERDTreeRespectWildIgnore=1

	" NERDTree syntax highlighting settings
    let g:WebDevIconsDisableDefaultFolderSymbolColorFromNERDTreeDir = 1

	" NerdTree visual customizations
	let NERDTreeMinimalUI = 1
	let NERDTreeDirArrows = 1

    let s:orange = "D4843E"
    let s:darkOrange = "F16529"
    let s:yellow = "F09F17"
    let s:git_orange = 'F54D27'

    let g:WebDevIconsDefaultFolderSymbolColor = s:darkOrange " sets the color for folders that did not match any rule
    let g:WebDevIconsDefaultFileSymbolColor = s:orange " sets the color for files that did not match any rule

set laststatus=2
set noshowmode

" Handles the delay switching modes
set timeoutlen=1000 ttimeoutlen=0

" For LaTeX and Markdown files
    " Toggle spellchecking with <leaser>s
    hi spellBad ctermfg=NONE ctermbg=Red cterm=underline
    nnoremap <leader>s :set spelllang=en_us spell! <bar> syntax spell toplevel <CR>

    " <leader>p opens the corresponding pdf in zathura as a new process
    nnoremap <leader>p : silent exec "!zathura --fork %:r.pdf" <bar> execute ':redraw!' <CR>

	" Auto compile LaTeX files to pdf on save
    autocmd BufWritePost *.tex silent! execute "!xelatex % >/dev/null 2>&1" | redraw!

	" Auto compile markdown to pdf on save
    " --- Skip this if it's a README.md file ---
    " function! Check_readme()
    "     if !(@% ==? 'readme.md' || @% ==? 'todo.md')
    "         silent! execute "!pandoc -o %:r.pdf % >/dev/null 2>&1" | redraw!
    "     endif
    " endfunction
    "
    " autocmd BufWritePost *.md :call Check_readme()
    " -----------------------------------------

	" Enable syntax highlighting within fenced code blocks in Markdown documents
	let g:markdown_fenced_languages = ['c', 'cpp', 'py=python', 'bash=sh', 'hs=haskell']

" Haskell settings -- better syntax highlighting
    " NOTE: original gruvbox.vim color scheme modified for Haskell
    let g:haskell_enable_quantification = 1   " enable highlighting of `forall`
    let g:haskell_enable_recursivedo = 1      " enable highlighting of `mdo` and `rec`
    let g:haskell_enable_arrowsyntax = 1      " enable highlighting of `proc`
    let g:haskell_enable_pattern_synonyms = 1 " enable highlighting of `pattern`
    let g:haskell_enable_typeroles = 1        " enable highlighting of type roles
    let g:haskell_enable_static_pointers = 1  " enable highlighting of `static`
    let g:haskell_backpack = 1                " enable highlighting of backpack keywords

    autocmd Filetype haskell setlocal expandtab tabstop=2 shiftwidth=2 softtabstop=2

" Clipboard things
" Allow copy to the system clipboard
map <C-c> "+y

" Copy all text to clipboard
nnoremap <F5> :%y+<CR>

" ------ coc settings -------
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif


" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nnoremap gd :call CocAction('jumpDefinition')<CR>
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocActionAsync('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠️'

nnoremap <leader>A :ALEToggleBuffer<CR>

let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'cpp': ['clangtidy'],
\}

let g:ale_linters = { 'go': ['gofmt', 'golint', 'go vet', 'gopls'] }

nnoremap <F9> :TagbarToggle<CR>
highlight TagbarSignature guifg=Yellow ctermfg=Yellow
let g:tagbar_compact = 2
let g:tagbar_autofocus = 1

nnoremap <expr> <C-t> fugitive#head() != '' ? ':GitFilesWithDevicons<CR>' : ':Files<CR>'
nnoremap <C-f> :Rg<CR>

let g:buftabline_show=1

nnoremap <C-n> :bn<CR>
nnoremap <C-b> :bp<CR>
nnoremap <leader>x :bd<CR>
nnoremap <leader>e :enew<CR>

let $BAT_THEME='gruvbox'

let g:indentLine_char = '▏'

" move text blocks
nnoremap _ :m .-2<CR>==
nnoremap + :m .+1<CR>==

vnoremap _ :m '<-2<CR>gv=gv
vnoremap + :m '>+1<CR>gv=gv


imap <F1> <C-o>:echo<CR>
nmap <F1> :FloatermNew<CR>

nnoremap <leader>r :%s/\<<C-r>=expand('<cword>')<CR>\>/

" yank everything and force quit
nmap <leader>yq gg0vG$"+y:q!<CR>

let g:coc_disable_startup_warning = 1

set iskeyword+=\-

" Disable quote concealing in JSON files
autocmd Filetype json
  \ let g:indentLine_setConceal = 0 |
  \ let g:vim_json_syntax_conceal = 0


let g:LanguageClient_serverCommands = {
\ 'rust': ['rust-analyzer'],
\ }


let g:floaterm_autoclose = 2

let g:doge_python_settings = {
\  'single_quotes': 1
\}

let g:doge_doc_standard_c = 'kernel_doc'

" coc-nvim does want this to work so I'll just override it I guess
autocmd Filetype go map <buffer> <leader>f m`:%!gofmt<cr>``


" Go syntax highlighting
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_operators = 1
let g:go_def_mapping_enabled = 0
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_autosave = 0
let g:go_fmt_command = "gofmt"

let g:buftabline_indicators=1

autocmd BufNewFile *.html 0r ~/.vim/templates/html.skel

" Trigger a highlight only when pressing f and F.
let g:qs_highlight_on_keys = ['f', 'F']

let g:cpp_member_highlight = 1



" TODO: I have this at the top but something undoes this fucnctionality
" somewhere in here, so I should probably figure that out
" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" List errors
nmap <leader>e :CocDiagnostics<CR>

let &t_ZH="\e[3m"
let &t_ZR="\e[23m"
