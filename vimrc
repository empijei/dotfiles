set nocompatible  "Be IMproved
syntax on
let mapleader = "\\"
scriptencoding utf-8
set encoding=utf-8

"Settings {{{
set autoindent "Autoindent
set backspace=2 "Sensible backspace behavior: indent,eol,start
set balloondelay=250 "Delay to show the suggestion balloon
set clipboard=unnamedplus "System clipboard integration
set colorcolumn=80 "Mark the 80th character
set cryptmethod=blowfish2 "Crypto stronger than default
set cursorline "Underline current line
set directory=~/.vim/directory/ "Move swap files out of current dir
set expandtab "Converts tabs to spaces
set ffs=unix,dos "Fileformat for CLRF madness
set fillchars+=vert:\ "Removes pipe marker in split
set foldlevelstart=20 "Folds are opened by default
set foldmethod=marker "Foldings with {{{ }}} sections
set hidden "Allow a buffer to be replaced even with unsaved changes
set history=10000 "Command history size
set hlsearch "Highlights search result. use :C to clear
set ignorecase "Default for smartcase
set incsearch "Move while searching
set laststatus=2 "Always set statusline
set list "Shows invisible characters
set listchars=tab:\·\  "Prints tabs as middle dot
set mouse=a "Mouse integration
set nomodeline "Disable modeline for security, see http://vim.wikia.com/wiki/Modeline_magic
set number "Line numbers
set omnifunc=syntaxcomplete#Complete "Http://vim.wikia.com/wiki/Omni_completion
set path+=** "Use globstar for matching
set scrolloff=7 "Always keep at least some lines of visible context around cursor
set shiftwidth=2 "Column to reindent on reindent command
set showcmd "Show partial commands
"set signcolumn=number "see error marks on lines in the numbers column (modern vim v8.1.1564+)
set smartcase "Search insensitive if no uppercase letters appear in the search pattern
set smartindent "Smart auto indenting
set t_Co=256 "Extended colors for terminal
set tabstop=2 "Prints the tab character as 2 spaces
set timeoutlen=500 "Milliseconds waited for a key code or mapped key sequence to complete
set ttimeoutlen=50 "Milliseconds waited for a key code to complete
set ttymouse=urxvt "Makes mouse work correctly in qterminal
set undodir=~/.vim/undo/ "Tell vim where to look for undo files
set undofile "Tell vim to use an undo file
set updatetime=500 "Responsive updates while coding
set wildmenu "Show available options in statusline
set wildmode=longest,full "Show list of completion in statusline, longest first
set wrap "Wrapping lines
"Disable line numbers in terminal windows
autocmd BufEnter * if &buftype == 'Terminal' || &buftype == 'terminal' | setlocal nonumber | endif
"}}}

"Mappings {{{
"Esc key is a serious overstretch
inoremap jk <esc>

"Remapping for tab movements
nnoremap <Leader>tn :tabnext<CR>
nnoremap <Leader>tp :tabprev<CR>

"Copy filename and fullfilepath to clipboard
nnoremap c% :let @+=expand("%")<CR>

"Display buffers menu and prompt for switch
nnoremap <leader><tab> :buffers<CR>:buffer<Space>

"Use ctrl-space to autocomplete
inoremap <C-Space> <C-x><C-o>
inoremap <C-@> <C-Space>

"Move and indent lines on Ctrl+j and Ctrl+k
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi

"Break bad habits
nnoremap <Up> <NOP>
nnoremap <Down> <NOP>
nnoremap <Left> <NOP>
nnoremap <Right> <NOP>

"& is close to * on my keyboard so it makes sense to have them behave similarly
nnoremap & #
"Move through vimgrep results less awkwardly
nnoremap cn :cn<CR>
nnoremap cp :cp<CR>

"VimDiff shortcuts
if &diff
  "Get from remote
  nnoremap dr :diffg<Space>RE<CR>
  "Get from base
  nnoremap db :diffg<Space>BA<CR>
  "Get from local
  nnoremap dl :diffg<Space>LO<CR>
  "Next diff
  nnoremap cn ]c
  "Previous diff
  nnoremap cp [c
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
"}}}

"Commands {{{
"Switch to Hex view
command! Hex :%!xxd
"Switch from Hex to normal view
command! NoHex :%!xxd -r

"By default BOOKMARKs are highlighted and searched for
let @/="BOOKMARK"
":C resets search keyword to BOOKMARK
command! C let @/="BOOKMARK"

"Fix line endings when dos mode
command! LineEndings e ++ff=dos<CR>

"Delete empty lines
command! Strip g/^\s*$/d
"Delete trailing spaces
command! StripEnding :%s/\s\+$//e

"Switch to diff mode
command! Diff windo diffthis | syntax off
"Switch back from diff to normal mode
command! NoDiff diffoff! | syntax on

"Tabs switch
command! TN :tabnext
command! TP :tabprev

"Faster way to access the terminal
command! T :terminal
command! TT :tab terminal

"Avoid stupid typos
command! W :w
command! Q :q
command! WQ :wq
command! Wq :wq

"Call grep from Vim. I know there is :vimgrep, but it is too slow.
command! -nargs=+ Grep execute 'silent grep! -I -r -n --exclude-dir=.git --exclude tags --exclude \*.cf . -e <args>' | copen | execute 'silent /<args>' | redraw!
"Call Grep with \g
nnoremap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr>

"Browse the web from vim with elinks
command! -nargs=+ Google :term elinks "https://www.google.com/search?q=<args>"
command! -nargs=+ Browse :term elinks "https://<args>"
"}}}

"Move through vimgrep results less awkwardly
nnoremap cn :cn<CR>
nnoremap cp :cp<CR>

"Status line {{{
function! InsertStatuslineColor(mode)
  "0 = Dark Gray
  "1 = Red
  "2 = Lime
  "3 = Yellow
  "4 = Cyan
  "5 = Pink
  "6 = Aquamarine
  "7 = White
  if a:mode == 'i'
    highlight StatusLine term=reverse ctermbg=16 ctermfg=7
  elseif a:mode == 'r'
    highlight StatusLine term=reverse ctermbg=16 ctermfg=1
  else
    highlight StatusLine term=reverse ctermbg=16 ctermfg=7
  endif
endfunction
autocmd InsertEnter * call InsertStatuslineColor(v:insertmode)
autocmd InsertChange * call InsertStatuslineColor(v:insertmode)
autocmd InsertLeave * highlight StatusLine term=reverse ctermbg=16 ctermfg=2
highlight StatusLine term=reverse ctermbg=16 ctermfg=2
set statusline=%<\ %n:%f\ %m%r%y%=%35.(line:\ %l\ of\ %L,\ col:\ %c%V\ [%P]%)
"}}}

" Styles {{{
"GVim default theme is seriously ugly
if has('gui_running')
  colorscheme zellner
else
  colorscheme desert
endif
highlight ColorColumn ctermbg=black
highlight Search cterm=NONE ctermfg=black ctermbg=green
highlight Visual cterm=NONE ctermfg=black ctermbg=yellow
highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/
"}}}

"Netrw File explorer config in case NERDTree is not available
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 2
let g:netrw_altv = 1
let g:netrw_winsize = 25
noremap <C-n> :Vexplore<CR>

if $VIM_PLUGINS == "1"
  "=PLUGINS=
  set runtimepath^=~/.vim/bundle/YouCompleteMeGoogle

  "External plugins and configurations {{{
  set nocompatible
  filetype off
  set rtp+=~/.vim/bundle/Vundle.vim
  call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'scrooloose/nerdcommenter'
  "Plugin 'scrooloose/nerdtree'
  Plugin 'majutsushi/tagbar'
  "Plugin 'myitcv/govim'
  Plugin 'fatih/vim-go'
  "Plugin 'leafgarland/typescript-vim'
  Plugin 'empijei/empijei-vim'
  Plugin 'SirVer/ultisnips'
  "Plugin 'Valloric/YouCompleteMe'
  call vundle#end()
  filetype plugin indent on

  "Ultisnips
  let g:UltiSnipsExpandTrigger = "<c-t>"
  let g:UltiSnipsJumpForwardTrigger = "<c-t>"
  let g:UltiSnipsJumpBackwardTrigger = "<c-b>"
  let g:UltiSnipsListSnippets = "<leader>l"
  let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']
  let g:UltiSnipsEditSplit="vertical"

  colorscheme empijei

  "NerdTree
  noremap <C-n> :NERDTreeToggle<CR>

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

  "YouCompleteMe
  let g:ycm_always_populate_location_list = 1
  let g:ycm_enable_diagnostic_signs = 1
  let g:ycm_enable_diagnostic_highlighting = 1
  let g:ycm_echo_current_diagnostic = 1
  let g:ycm_warning_symbol = '>'
  let g:ycm_show_diagnostics_ui = 1

  "Go
  augroup golang
    autocmd!
    let g:go_autodetect_gopath=0
    "Show a list of interfaces which is implemented by the type under your cursor with \s
    autocmd FileType go nmap <Leader>s <Plug>(go-implements)
    autocmd FileType go nmap gr :GoReferrers<CR>
    autocmd FileType go nmap <Leader>r <Plug>(go-rename)
    autocmd FileType go nmap <Leader>e :GoMetaLinter<CR>
    autocmd FileType go nmap <Leader>b :GoBuild<CR>
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
    "see error marks on lines in the numbers column (modern vim v8.1.1564+)
    "autocmd BufEnter,BufNewFile *.go set signcolumn=number
    "autocmd BufLeave *.go set signcolumn=
    autocmd BufEnter,BufNewFile *.go set colorcolumn=100
    autocmd BufLeave *.go set colorcolumn=80
    "\d automatically adds a godoc stub for the current identifier
    autocmd FileType go nnoremap <leader>d yiwO//<Space><Esc>pa<Space>
    autocmd FileType go iabbrev iin := range
  augroup END
  "}}}
  endif

  "Fix for https://github.com/vim/vim/issues/2008
set t_SH=
