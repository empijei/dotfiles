set nocompatible  "Be IMproved
syntax on
let mapleader = "\\"
scriptencoding utf-8
set encoding=utf-8

" Some useful settings
set ffs=unix,dos "fileformat for CLRF madness
set list "shows invisible characters
set wrap "Wrapping lines
set path+=** "use globstar for matching
set t_Co=256 "Extended colors for terminal
set number "line numbers
set hidden "Allow a buffer to be replaced even with unsaved changes
set mouse=a "mouse integration
set showcmd "Show partial commands
set history=10000 "command history size
set undodir=~/.vim/undo/ "tell vim where to look for undo files
set tabstop=2 "prints the tab character as 2 spaces
set hlsearch "highlights search result. use :C to clear
set wildmenu "show commands in statusline
set nomodeline "see http://vim.wikia.com/wiki/Modeline_magic
set undofile "tell vim to use an undo file
set wildmode=longest,full "Show list of completion in modeline while typing command
set omnifunc=syntaxcomplete#Complete "http://vim.wikia.com/wiki/Omni_completion
set ttymouse=xterm2 "Resize splits with mouse while inside screen
set expandtab "converts tabs to spaces
set smartcase "search insensitive if no uppercase letters appear in the search pattern
set incsearch "move while searching
set directory=~/.vim/directory/ "move swap files out of current dir
set scrolloff=7 "Always keep at least some lines of visible context around cursor
set listchars=tab:\·\  "Prints tabs as middle dot
set fillchars+=vert:\ "removes pipe marker in split
set clipboard=unnamedplus "System clipboard integration
set cursorline "underline current line
set ignorecase "default for smartcase
set foldmethod=marker "Foldings with {{{ }}} sections
set cryptmethod=blowfish2 "Crypto stronger than default
set shiftwidth=2 "column to reindent on reindent command
set timeoutlen=500
set colorcolumn=80 "Mark the 80th character
set foldlevelstart=20 "Folds are opened by default

"For Hex view
command! Hex :%!xxd
command! NoHex :%!xxd -r

"By default BOOKMARKS are highlighted
let @/="BOOKMARK"
command! C let @/="BOOKMARK"

command! LineEndings e ++ff=dos<CR>

"delete empty lines
command! Strip g/^\s*$/d
"delete trailing spaces
command! StripEnding :%s/\s\+$//e

"esc key is a serious overstretch
inoremap jk <esc>

"Copy filename and fullfilepath to clipboard
nnoremap c% :let @+=expand("%")<CR>

"Toggle between vimdiff and vim
command! Diff windo diffthis | syntax off
command! NoDiff diffoff! | syntax on

" VimDiff shortcuts
if &diff
  " Get from remote
  nnoremap dr :diffg<Space>RE<CR>
  " Get from base
  nnoremap db :diffg<Space>BA<CR>
  " Get from local
  nnoremap dl :diffg<Space>LO<CR>
  " Next diff
  nnoremap cn ]c
  " Previous diff
  nnoremap cp [c
endif

"Remapping for tab movements
"nnoremap <Leader>tn :tabnext<CR>
"nnoremap <Leader>tp :tabprev<CR>
command! TN :tabnext
command! TP :tabprev

" Disable line numbers in terminal windows
au BufWinEnter * if &buftype == 'terminal' | setlocal nonumber | endif
"Faster way to access the terminal
command! T :terminal
command! TT :tab terminal

" Status line
set laststatus=2
set ttimeoutlen=50
function! InsertStatuslineColor(mode)
  " 0 = Dark Gray
  " 1 = Red
  " 2 = Lime
  " 3 = Yellow
  " 4 = Cyan
  " 5 = Pink
  " 6 = Aquamarine
  " 7 = White
  if a:mode == 'i'
    hi StatusLine term=reverse ctermbg=16 ctermfg=7
  elseif a:mode == 'r'
    hi StatusLine term=reverse ctermbg=16 ctermfg=1
  else
    hi StatusLine term=reverse ctermbg=16 ctermfg=7
  endif
endfunction
au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertChange * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi StatusLine term=reverse ctermbg=16 ctermfg=2
hi StatusLine term=reverse ctermbg=16 ctermfg=2
set statusline=%<\ %n:%f\ %m%r%y%=%35.(line:\ %l\ of\ %L,\ col:\ %c%V\ [%P]%)

" Use ctrl-space to autocomplete
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

"move lines on Ctrl+Arrows
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi

colorscheme default
highlight ColorColumn ctermbg=black
highlight Search cterm=NONE ctermbg=yellow ctermfg=black
highlight Visual cterm=NONE ctermbg=yellow ctermfg=black
highlight SpellBad cterm=NONE ctermfg=black ctermbg=red
highlight SpellCap cterm=NONE ctermfg=white ctermbg=blue

"GVim default theme is seriously ugly
if has('gui_running')
  colorscheme torte
endif

"Toggle wrapping when needed
noremap <silent> <Leader>w :call ToggleWrap()<CR>
function! ToggleWrap()
  if &wrap
    echo "Wrap OFF"
    set nowrap
  else
    echo "Wrap ON"
    set wrap
  endif
endfunction

"Break bad habits
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>

" & is close to * on my keyboard so it makes sense to have them behave similarly
nnoremap & #

"Avoid stupid typos
command! W :w
command! Q :q
command! WQ :wq
command! Wq :wq

"Call grep from Vim. I know there is :vimgrep, but it is too slow.
command! -nargs=+ Grep execute 'silent grep! -I -r -n --exclude-dir=.git --exclude tags --exclude \*.cf . -e <args>' | copen | execute 'silent /<args>' | redraw!
nnoremap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr>

"Move through vimgrep results less awkwardly
nnoremap cn :cn<CR>
nnoremap cp :cp<CR>

highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/

" Netrw File explorer config in case NERDTree is not available
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 25
map <C-n> :Vexplore<CR>

"=PLUGINS=

" External plugins and configurations {{{
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'scrooloose/nerdtree'
Plugin 'majutsushi/tagbar'
Plugin 'fatih/vim-go'
Plugin 'leafgarland/typescript-vim'
Plugin 'empijei/empijei-vim'
Plugin 'SirVer/ultisnips'
Plugin 'Valloric/YouCompleteMe'
call vundle#end()
filetype plugin indent on

" Ultisnips
let g:UltiSnipsExpandTrigger = "<c-t>"
let g:UltiSnipsJumpForwardTrigger = "<c-t>"
let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
let g:UltiSnipsListSnippets = "<leader>l"
let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

colorscheme empijei

" Highlight current line and lenght column in a soft way
hi CursorLine cterm=NONE ctermbg=black
highlight ColorColumn ctermbg=black

"NerdTree
map <C-n> :NERDTreeToggle<CR>

"Tagbar
command! Ta :TagbarToggle
let g:tagbar_type_go = {
  \ 'ctagstype' : 'go',
  \ 'kinds'     : [
  \ 'p:package',
  \ 'i:imports:1',
  \ 'c:constants',
  \ 'v:variables',
  \ 't:types',
  \ 'n:interfaces',
  \ 'w:fields',
  \ 'e:embedded',
  \ 'm:methods',
  \ 'r:constructor',
  \ 'f:functions'
  \ ],
  \ 'sro' : '.',
  \ 'kind2scope' : {
  \ 't' : 'ctype',
  \ 'n' : 'ntype'
  \ },
  \ 'scope2kind' : {
  \ 'ctype' : 't',
  \ 'ntype' : 'n'
  \ },
  \ 'ctagsbin'  : '~/go/bin/gotags',
  \ 'ctagsargs' : '-sort -silent'
\ }

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"

" youcompleteme
let g:ycm_always_populate_location_list = 1
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 1
let g:ycm_echo_current_diagnostic = 1
let g:ycm_warning_symbol = '>'
let g:ycm_show_diagnostics_ui = 1

augroup golang
  autocmd!
  set colorcolumn=100
  let g:go_autodetect_gopath=0
  "Show a list of interfaces which is implemented by the type under your cursor with \s
  autocmd FileType go nmap <Leader>s <Plug>(go-implements)
  autocmd FileType go nmap gr :GoReferrers<CR>
  autocmd FileType go nmap <Leader>r <Plug>(go-rename)
  autocmd FileType go nmap <Leader>e :GoMetaLinter<CR>
  autocmd FileType go nmap <F5> <Plug>(go-run)
  autocmd FileType go nmap <leader>t :GoCoverageToggle<CR>
  "autocmd FileType go nmap <leader>t <Plug>(go-test)
  autocmd FileType go nmap <leader>a :GoAlternate<CR>
  autocmd FileType go nmap gd <Plug>(go-def)
  let g:go_highlight_methods = 1
  let g:go_highlight_structs = 1
  let g:go_highlight_operators = 1
  let g:go_highlight_functions = 1
  let g:go_highlight_interfaces = 1
  let g:go_list_type = "quickfix"
  let g:go_fmt_command = "goimports"
  "let g:go_metalinter_enabled = ['goimports']
  "let g:go_metalinter_autosave = 1
  "let g:go_metalinter_autosave_enabled = ['vet', 'golint']
  autocmd FileType go nnoremap <leader>d yiwO//<Space><Esc>pa<Space>
  autocmd FileType go iabbrev iin := range
  autocmd FileType go iabbrev !! if err != nil {
augroup END

"}}} External plugins and configurations

" Fix for https://github.com/vim/vim/issues/2008
set t_SH=
