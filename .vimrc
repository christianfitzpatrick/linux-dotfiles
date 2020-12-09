runtime! debian.vim

" for when I accidentally do :W instead of :w
command W w

" Colors
set background=dark
syntax on
set t_Co=256
set termguicolors
let g:gruvbox_guisp_fallback = "bg"
colorscheme gruvbox

set cursorline
highlight CursorLine cterm=NONE ctermbg=NONE ctermfg=NONE guibg=NONE guifg=NONE

" Resume editing at last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" Jump to start and end of line using the home row keys
map H ^
map L $

filetype plugin indent on

" Disable automatic commenting on newline
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Delete trailing whitespace and empty lines at end of file
autocmd BufWritePre * %s/\s\+$//e
autocmd BufWritepre * %s/\n\+\%$//e

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

" Autocompletion
set wildmode=longest,list,full

" Double press <esc> to clear search highlights
nnoremap <silent> <Esc><Esc> <Esc>:nohlsearch<CR><Esc>

" Toggle relative line number with <leader>l
nmap <leader>l :set invrelativenumber<CR>

" Better indentation of selected blocks
vnoremap < <gv
vnoremap > >gv

" Automatically closing braces
inoremap {<CR> {<CR>}<Esc>ko
inoremap [<CR> [<CR>]<Esc>ko
inoremap (<CR> (<CR>)<Esc>ko

" Better way to move between windows
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Plugins
	call plug#begin('~/.vim/autoload')
    Plug 'itchyny/lightline.vim'
    Plug 'shinchu/lightline-gruvbox.vim'
	Plug 'scrooloose/nerdtree'
	Plug 'junegunn/goyo.vim'
	Plug 'neovimhaskell/haskell-vim'
	Plug 'tpope/vim-markdown'
	Plug 'preservim/nerdcommenter'
	Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
	Plug 'ryanoasis/vim-devicons'
    Plug 'bfrg/vim-cpp-modern'
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'wlangstroth/vim-racket'
    Plug 'vim-syntastic/syntastic'
    " Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    " Plug 'junegunn/fzf.vim'
	call plug#end()


let g:lightline = {}


" function! MyFiletype()
" return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype . ' ' . WebDevIconsGetFileTypeSymbol() : 'no ft') : ''
" endfunction

" function! MyFileformat()
" return winwidth(0) > 70 ? (&fileformat . ' ' . WebDevIconsGetFileFormatSymbol()) : ''
" endfunction

function! MyLineinfo()
  return line('.') . '/' . line('$')
endfunction

" let g:lightline = {
    " \ 'component_function': {
    " \   'filetype': 'MyFiletype',
    " \   'fileformat': 'MyFileformat',
    " \   'lineinfo': 'MyLineinfo',
    " \ }
    " \ }

let g:lightline = {
    \ 'component_function': {
    \   'lineinfo': 'MyLineinfo',
    \ }
    \ }
let g:lightline.active = {
    \ 'left': [ [ 'mode'],
    \           [ 'readonly', 'filename', 'modified' ] ],
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

    " Enable trimming of trailing whitespace when uncommenting
    let g:NERDTrimTrailingWhitespace = 1

" NerdTree plugin settings
	" Toggle NerdTree with <F6>
	nnoremap <silent> <expr> <F6> g:NERDTree.IsOpen() ? "\:NERDTreeClose<CR>" : bufexists(expand('%')) ? "\:NERDTreeFind<CR>" : "\:NERDTree<CR>"

	" Start NerdTree automatically
    " autocmd VimEnter * NERDTree

	" Start Vim in the editor, not the file explorer
    autocmd VimEnter * wincmd p
    autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

    " Fixes issues with file icons in NerdTree
	if exists("g:loaded_webdevicons")
		call webdevicons#refresh()
	endif

	" Hide certain files in the NerdTree view
	set wildignore+=*.pyc,*.o,*.obj,*.svn,*.swp,*.class,*.hg,*.DS_Store,*.min.*
	let NERDTreeRespectWildIgnore=1

	" NERDTree syntax highlighting settings
    let g:WebDevIconsDisableDefaultFolderSymbolColorFromNERDTreeDir = 1
	let g:WebDevIconsDisableDefaultFileSymbolColorFromNERDTreeFile = 1
	let g:NERDTreeLimitedSyntax = 1

	" NerdTree visual customizations
	let NERDTreeMinimalUI = 1
	let NERDTreeDirArrows = 1


" -------------------------------------------
" ---------------- Statusline ---------------
" -------------------------------------------
" Default for status line
" hi statusline ctermfg=green ctermbg=white

" Status line custom
" let g:currentmode={
    " \ 'n'  : 'Normal',
    " \ 'no' : 'Normal·Operator Pending',
    " \ 'v'  : 'Visual',
    " \ 'V'  : 'V·Line',
    " \ '^V' : 'V·Block',
    " \ 's'  : 'Select',
    " \ 'S'  : 'S·Line',
    " \ '^S' : 'S·Block',
    " \ 'i'  : 'Insert',
    " \ 'R'  : 'Replace',
    " \ 'Rv' : 'V·Replace',
    " \ 'c'  : 'Command',
    " \ 'cv' : 'Vim Ex',
    " \ 'ce' : 'Ex',
    " \ 'r'  : 'Prompt',
    " \ 'rm' : 'More',
    " \ 'r?' : 'Confirm',
    " \ '!'  : 'Shell',
    " \ 't'  : 'Terminal'
    " \}

set laststatus=2
set noshowmode
" set statusline=
" set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode
" set statusline+=%1*\ %<%f%m%r%h%w\                       " File path, modified, readonly, helpfile, preview
" set statusline+=%3*│                                     " Separator
" set statusline+=%2*\ %Y\                                 " FileType
" set statusline+=%3*│                                     " Separator
" set statusline+=%=                                       " Right Side
" set statusline+=%2*\ col:\ %02v\                         " Colomn number
" set statusline+=%1*\ ln:\ %l/%L\                         " Line number / total lines, percentage of document
" set statusline+=%0*\ %{toupper(g:currentmode[mode()])}\  " The current mode

" hi User1 ctermfg=007 ctermbg=239 guibg=#4e4e4e guifg=#adadad
" hi User2 ctermfg=007 ctermbg=236 guibg=#303030 guifg=#adadad
" hi User3 ctermfg=236 ctermbg=236 guibg=#303030 guifg=#303030
" hi User4 ctermfg=239 ctermbg=239 guibg=#4e4e4e guifg=#4e4e4e
" ----------------------------------------------
" ---------------- End Statusline --------------
" ----------------------------------------------



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
    function! Check_readme()
        if !(@% ==? 'readme.md')
            silent! execute "!pandoc -o %:r.pdf % >/dev/null 2>&1" | redraw!
        endif
    endfunction

    autocmd BufWritePost *.md :call Check_readme()
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

" ------ coc settings -------

" Allow copy to the system clipboard
map <C-c> "+y

" Copy all text to clipboard
nnoremap <F5> :%y+<CR>

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








autocmd BufEnter * :syntax sync fromstart


let g:syntastic_cpp_checkers = ['cpplint']
let g:syntastic_c_checkers = ['cpplint']
let g:syntastic_cpp_cpplint_exec = 'cpplint'
" let g:syntastic_cpp_cpplint_exec = 'cpplint --filter=-whitespace,-legal/copyright'


let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0



function! ToggleSyntastic()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            lclose
            return
        endif
    endfor
    SyntasticCheck
endfunction

nnoremap <F8> :call ToggleSyntastic()<CR>
