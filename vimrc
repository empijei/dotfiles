"To use this .vimrc please install Vundle
"`git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim`
"then run `vim +PluginInstall +qa`
"then run `vim +GoInstallBinaries +qa`
"finally run 
"	cd ~/.vim/bundle/YouCompleteMe
"	git submodule update --init --recursive
"	python2 install.py --omnisharp-completer --gocode-completer --clang-completer
"
"	cd ~/.vim/bundle/omnisharp-vim
"	git submodule update --init --recursive
"	cd server
"	xbuild

set nocompatible  "Be IMproved
syntax on
let mapleader = "\\"
scriptencoding utf-8
set encoding=utf-8


"useful misc commands and shortcuts{{{
"For Hex view
command! Hex :%!xxd
command! NoHex :%!xxd -r

"By default TODOs are highlighted
let @/="TODO"
command! C let @/="TODO" 
"Spellcheck
command! LI set spell spelllang=it_it
command! LE set spell spelllang=en_gb
inoremap <c-a> <Esc>[sz=i1<CR><CR>A
command! NoL set spell spelllang=

command! LineEndings e ++ff=dos<CR>

"Reload .vimrc
command! Reconf source $HOME/.vimrc

"delete empty lines
command! Strip g/^\s*$/d
command! StripEnding :%s/\s\+$//e

"Toggle between vimdiff and vim
command! Diff windo diffthis | syntax off
command! NoDiff diffoff! | syntax on

"for extra impact
nnoremap H :r ! figlet 

"reformat document
nnoremap <c-f> mzgg=G`z
inoremap <c-f> <Esc>mzgg=G`zi

"esc key is a serious overstretch
inoremap jk <esc>

"stop using esc
"inoremap <esc> <nop>

"Copy filename and fullfilepath to clipboard
nnoremap c% :let @+=expand("%")<CR>
"nnoremap cl :let @+=expand("%:p")<CR>

"Move through vimgrep results less awkwardly
nnoremap cn :cn<CR>
nnoremap cp :cp<CR>
"nnoremap en :lne<CR>
"nnoremap ep :lp<CR>
"}}}

" Some useful sets {{{
set list "shows invisible characters
set wrap "Wrapping lines
"set t_te= "do not clear on vim close
set number "line numbers
set mouse=a "mouse integration
set showcmd "Show partial commands
set hlsearch "highlights search result. use :C to clear
set wildmenu "show commands in statusline
set modeline "see http://vim.wikia.com/wiki/Modeline_magic
set smartcase "search insensitive if no uppercase letters appear in the search pattern
set incsearch "move while searching
set tabstop=3 "prints the tab character as spaces
set cursorline "underline current line
set ignorecase "default for smartcase
set ffs=unix,dos "fileformat for CLRF madness
set scrolloff=7 "Always keep at least some lines of visible context around cursor
set shiftwidth=3 "colum to reindent on reindent command
set wildmode=longest,full "Show list of completion in modeline while typing command
set colorcolumn=80 "Mark the 80th character
set undofile "tell vim to use an undo file
set undodir=~/.vim/undo/ "tell vim where to look for undo files
set timeoutlen=500
"set listchars=tab:\│· "Prints tabs as │···
"set ttymouse=xterm2 "tmux compatibility
set listchars=tab:\·\  "Prints tabs as │···
set fillchars+=vert:\ "removes pipe marker in split
set clipboard=unnamedplus "System clipboard integration
set omnifunc=syntaxcomplete#Complete "http://vim.wikia.com/wiki/Omni_completion
"Set the mark at 80th character to be blue instead of eyekilling red
"}}}

"Remapping for tabs {{{
nnoremap th  :tabfirst<CR>
nnoremap tj  :tabnext<CR>
nnoremap tp  :tabprev<CR>
nnoremap tl  :tablast<CR>
nnoremap tt  :tabedit<CR>
nnoremap tn  :tabnext<CR>
nnoremap tm  :tabmove<Space>
nnoremap td  :tabclose<CR>
nnoremap ta  :tab all<CR>
"}}}

"Keep better track of cursor while not in insert mode
au InsertEnter * set nocursorline "do not underline current line in insert mode
au InsertLeave * set cursorline "underline current line in other modes

"statusline {{{
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
" statusline
" cf the default statusline: %<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
" format markers:
"   %< truncation point
"   %n buffer number
"   %f relative path to file
"   %m modified flag [+] (modified), [-] (unmodifiable) or nothing
"   %r readonly flag [RO]
"   %y filetype [ruby]
"   %= split point for left and right justification
"   %-35. width specification
"   %l current line number
"   %L number of lines in buffer
"   %c current column number
"   %V current virtual column number (-n), if different from %c
"   %P percentage through buffer
"   %) end of width specification
"}}}

" Quicker window movement
nnoremap <M-j> <C-w>j
nnoremap <M-k> <C-w>k
nnoremap <M-h> <C-w>h
nnoremap <M-l> <C-w>l

"Syntax highlight correction for nmap script engine
"autocmd BufRead,BufNewFile *.nse set filetype=lua

autocmd BufRead,BufNewFile *.hql set filetype=sql

autocmd BufRead *.png :! xdg-open '%'
autocmd BufRead *.gif :! xdg-open '%'
autocmd BufRead *.jpg :! xdg-open '%'
autocmd BufRead *.jpeg :! xdg-open '%'

"Functions to insert time of the day {{{
nnoremap <F7> "=strftime("%c")<CR>P
inoremap <F7> <C-R>=strftime("%c")<CR>
nnoremap <F6> "=strftime("%d/%m/%Y")<CR>P
inoremap <F6> <C-R>=strftime("%d/%m/%Y")<CR>
"}}}

"Ctrl-s to save {{{
"WARNING: you have to put
"stty -ixon
"in your bashrc file or this will not work
inoremap <c-s> <esc>:w<CR>a
nnoremap <c-s> :w<CR>
"}}}

"Git commits should be 50 chars long
autocmd FileType gitcommit set colorcolumn=50

"move lines on Ctrl+Arrows{{{
"nnoremap <c-Down> :m .+1<CR>==
"nnoremap <c-Up> :m .-2<CR>==
"inoremap <c-Down> <Esc>:m .+1<CR>==gi
"inoremap <c-Up> <Esc>:m .-2<CR>==gi
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi
"}}}

"Colors {{{
colorscheme default
highlight ColorColumn ctermbg=blue
highlight Search cterm=NONE ctermbg=green ctermfg=black
highlight Visual cterm=NONE ctermbg=yellow ctermfg=black
highlight SpellBad cterm=NONE ctermfg=black ctermbg=red
highlight SpellCap cterm=NONE ctermfg=white ctermbg=blue
highlight MatchParen cterm=NONE ctermbg=black ctermfg=yellow
highlight ExtraWhitespace ctermbg=red
match ExtraWhitespace /\s\+$/
"highlight MatchParen term=underline cterm=underline gui=underline
"}}}

" Vimscript {{{
"augroup filetype_vim
	"autocmd!
	"this allows folding in vimscript
	"autocmd FileType vim setlocal foldmethod=marker
"augroup END
"}}}

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
nnoremap <Left> :echoe "Use h"<CR>
nnoremap <Right> :echoe "Use l"<CR>
nnoremap <Up> :echoe "Use k"<CR>
nnoremap <Down> :echoe "Use j"<CR>

"Move on buffer in wrapping mode{{{
"noremap <silent> <Leader>w :call ToggleWrap()<CR>
"function! ToggleWrap()
"	if &wrap
"		echo "Wrap OFF"
"		call UnWrap()
"	else
"		echo "Wrap ON"
"		call Wrap()
"	endif
"endfunction
"function! UnWrap()
"	setlocal nowrap
"	set virtualedit=all
"	silent! nunnoremap <buffer> <Up>
"	silent! nunnoremap <buffer> <Down>
"	silent! nunnoremap <buffer> <Home>
"	silent! nunnoremap <buffer> <End>
"	silent! iunnoremap <buffer> <Up>
"	silent! iunnoremap <buffer> <Down>
"	silent! iunnoremap <buffer> <Home>
"	silent! iunnoremap <buffer> <End>
"endfunction
"function! Wrap()
"	setlocal wrap linebreak 
"	set virtualedit=
"	setlocal display+=lastline
"	noremap  <buffer> <silent> <Up>   gk
"	noremap  <buffer> <silent> <Down> gj
"	noremap  <buffer> <silent> <Home> g<Home>
"	noremap  <buffer> <silent> <End>  g<End>
"	inoremap <buffer> <silent> <Up>   <C-o>gk
"	inoremap <buffer> <silent> <Down> <C-o>gj
"	inoremap <buffer> <silent> <Home> <C-o>g<Home>
"	inoremap <buffer> <silent> <End>  <C-o>g<End>
"endfunction
"call Wrap()
"}}}

" When editing a file, always jump to the last known cursor position.
" Don't do it for commit messages, when the position is invalid, or when
" inside an event handler (happens when dropping a file on gvim).
autocmd BufReadPost *
\ if &ft != 'gitcommit' && line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "normal g`\"" |
\ endif

"Sorround with " or ' the current word
noremap <leader>" bi"<esc>ea"
noremap <leader>' bi'<esc>ea'

"Xml beautifier
autocmd FileType xml command! Beautify :silent %!xmllint --format --recover - <CR>

"JSON formatter
autocmd FileType json command! Beautify :silent %! jq -M -r .<CR>

"Common typos fixes for impaired people like me{{{
iabbrev epr per
iabbrev melgio meglio
iabbrev anceh anche
iabbrev acneh anche
iabbrev eprchè perché
iabbrev affinchè affinché
iabbrev finchè finché
iabbrev sè sé
iabbrev perchè perché
iabbrev cmq comunque
iabbrev btw by the way
iabbrev hce che
iabbrev android Android
iabbrev andoird Android
nnoremap W :w<cr>
nnoremap X :x<cr>
nnoremap & #
command! W :w
command! Q :q
command! WQ :wq
command! Wq :wq
"}}}

"Custom actual abbrev
iabbrev ssig -- <cr> Roberto (empijei) Clapis<cr>robclap8@gmail.com

"Custom actual abbrev
iabbrev sssig -- <cr> Empijei <cr> empijei@gmail.com

"This double bind is used in case some override fails
nnoremap gtd <C-]>

"Call grep from Vim. I know there is :vimgrep, but it is too slow.
command! -nargs=+ Grep execute 'silent grep! -I -r -n --exclude-dir=.git --exclude tags --exclude \*.cf . -e <args>' | copen | execute 'silent /<args>' | redraw!
" shift-control-* Greps for the word under the cursor
nnoremap <leader>g :Grep <c-r>=expand("<cword>")<cr><cr>

" Yank current file:line as if it was a grep -nl output
nnoremap <leader>y :let @+=expand("%") . ':' . line(".") . ':' . getline(".")<CR>

" Syntax highlight for xaml
autocmd BufRead,BufNewFile *.xaml set filetype=xml

"PLUGINS {{{
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim' "Plugin manager
Plugin 'majutsushi/tagbar' "Ctags panel integration
Plugin 'KabbAmine/zeavim.vim' "Integration with Zeal
Plugin 'bogado/file-line' "interpret file:line:column as it should 
Plugin 'jceb/vim-editqf' "Increase qf functionalities

"Nerdtree
Plugin 'scrooloose/nerdtree' "File browser left panel
Plugin 'ryanoasis/vim-devicons' "Icons for filetypes, this requires a nerdfont

Plugin 'kien/ctrlp.vim'

"Eyecandy
if has('gui_running')
	Plugin 'altercation/vim-colors-solarized' "Theme
endif

if !empty($CODE_INSPECT)
	"Code inspection
	Plugin 'maksimr/vim-jsbeautify' "JS Beautifier
	Plugin 'OmniSharp/omnisharp-vim' "Csharp
	Plugin 'keith/swift.vim' "Swift
	Plugin 'kchmck/vim-coffee-script' "Coffee Script
	Plugin 'leafgarland/typescript-vim' "TypeScript
	Plugin 'PProvost/vim-ps1' "powershell
	"Makes it easier to preview from nerdtree
	nmap S jgo
	set colorcolumn=
else
	Plugin 'tpope/vim-dispatch' "Spawn processes in background
	Plugin 'Valloric/YouCompleteMe' "Completer for most langauges
	Plugin 'ervandew/supertab' "Tab completion
	Plugin 'Xuyuanp/nerdtree-git-plugin' "Addon for nerdtree to support git tags
	"Plugin 'tiagofumo/vim-nerdtree-syntax-highlight' "colored icons for nerdtree
	Plugin 'fatih/vim-go' "Golang
	Plugin 'scrooloose/nerdcommenter' "Commenter for most langauges
	"Languages I use
	"Plugin 'davidhalter/jedi-vim' "Python
	"Plugin 'vim-scripts/Nmap-syntax-highlight' "Nse

	"JS and HTML stuff
	Plugin 'pangloss/vim-javascript' "JS syntax highlighting and improved indentation
	Plugin 'othree/html5-syntax.vim' "HTML5 syntax improvement
	Plugin 'othree/html5.vim' "HTML5 autocompletion
	Plugin 'othree/javascript-libraries-syntax.vim' "Syntax highlight for the most used JS libraries
	Plugin 'othree/csscomplete.vim' "Enhanced CSS completion
	
	"MarkDown
	Plugin 'plasticboy/vim-markdown'
	Plugin 'shime/vim-livedown'
	Plugin 'godlygeek/tabular'
endif

"My stuff
Plugin 'empijei/empijei-vim'
call vundle#end()
filetype plugin indent on

"vim-markdown
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_folding_disabled = 1

"Autopairs
"let g:AutoPairsUseInsertedCount = 1

"Gvim is seriously ugly
if has('gui_running')
	set background=light
	colorscheme solarized
	set guifont=DejaVuSansMono\ Nerd\ Font\ Book\ 11
endif 


"NerdTree
map <C-n> :NERDTreeToggle<CR>

"JsBeautify
autocmd FileType javascript command! Beautify :call JsBeautify()<CR>

"SuperTab
let g:SuperTabDefaultCompletionType = "<c-n>"

"Zeavim
nmap Z <Plug>Zeavim
vmap Z <Plug>ZVVisSelection   
nmap gz <Plug>ZVMotion         
nmap gZ <Plug>ZVKeyDocset      

let g:zv_file_types = {
			\	'cpp' : 'cpp',
			\	'cs' : 'net',
			\ }

"jceb/vim-editqf
command! -nargs=+ -complete=file QL execute 'QFLoad <args>' | execute 'let g:editqf_saveqf_filename="<args>"'| copen
command! -nargs=? -complete=file QS :call editqf#Save("!", "qf", <f-args>)

"if version >= 700
"  au InsertLeave * hi StatusLine term=reverse ctermfg=0 ctermbg=2 gui=bold,reverse
"endif

"vim-livedown
let g:livedown_autorun = 0
let g:livedown_open = 1
let g:livedown_port = 1337
let g:livedown_browser = "chromium"

"vim-go {{{
"let g:go_auto_type_info = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_functions = 1
let g:go_highlight_interfaces = 1
let g:go_fmt_command = "goimports"
let g:go_highlight_build_constraints = 1
command! GoGenDoc execute 'normal yeO// ' | execute 'normal pa ' | startinsert
"}}}

"Tagbar
command! T :TagbarToggle
nnoremap <c-t> :TagbarToggle<CR>
inoremap <c-t> <Esc>:TagbarToggle<CR>i

"youcompleteme{{{
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
"}}}

"othree{{{
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS noci
"}}}

" FileType stuff {{{

"Timeout in seconds to wait for a response from the server
let g:OmniSharp_timeout = 50
" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
"This is the default value, setting it isn't actually necessary
let g:OmniSharp_host = "http://localhost:2000"

"Use roslyn
"let g:OmniSharp_server_type = 'v1'
"let g:OmniSharp_server_type = 'roslyn'

augroup omnisharp_commands
	autocmd!

	"Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
	autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
	
	" Remove 'Press Enter to continue' message when type information is longer than one line.
	autocmd FileType cs set cmdheight=2

	"show type information automatically when the cursor stops moving
	"autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

	"The following commands are contextual, based on the current cursor position.
	autocmd FileType cs nnoremap gyd :OmniSharpGotoDefinition<cr>
	autocmd FileType cs nnoremap fi :OmniSharpFindImplementations<cr>
	autocmd FileType cs nnoremap ft :OmniSharpFindType<cr>
	autocmd FileType cs nnoremap fs :OmniSharpFindSymbol<cr>
	autocmd FileType cs nnoremap gr :OmniSharpFindUsages<cr>
	"finds members in the current buffer
	autocmd FileType cs nnoremap fm :OmniSharpFindMembers<cr>
	autocmd FileType cs nnoremap tt :OmniSharpTypeLookup<cr>
	autocmd FileType cs nnoremap K :OmniSharpDocumentation<cr>
	"navigate up by method/property/field
	autocmd FileType cs nnoremap <C-K> :OmniSharpNavigateUp<cr>
	"navigate down by method/property/field
	autocmd FileType cs nnoremap <C-J> :OmniSharpNavigateDown<cr>

augroup END

augroup markdown_stuff
	autocmd!
	autocmd FileType markdown noremap <leader>" bi"<esc>ea"
	autocmd FileType markdown noremap <leader>' bi'<esc>ea'
	autocmd FileType markdown noremap <leader>_ bi_<esc>ea_
	autocmd FileType markdown noremap <leader>* bi*<esc>ea*
	autocmd FileType markdown noremap <leader>- bi__<esc>ea__
	"autocmd FileType markdown inoremap <C-b> __
	"autocmd FileType markdown inoremap <C-i> _
	autocmd FileType markdown set colorcolumn=
	autocmd FileType markdown inoremap <c-a> <Esc>[sz=i1<CR><CR>A
	autocmd FileType markdow nnoremap zz [sz=i1<CR><CR>e
	autocmd FileType markdow nnoremap Z [sz=i1<CR><CR>A
	autocmd FileType markdown command! T :Toc
augroup END

"Spellcheck for latex
autocmd FileType tex set spell spelllang=it_it
autocmd FileType tex set colorcolumn=
autocmd FileType tex inoremap <c-a> <Esc>[sz=i1<CR><CR>A
autocmd FileType tex nnoremap zz [sz=i1<CR><CR>e
autocmd FileType tex nnoremap Z [sz=i1<CR><CR>A
let g:tex_flavor = "latex"

"Syntax for cf (quickfix) files
autocmd FileType quickfix set colorcolumn=

"Syntax for http files
autocmd BufRead,BufNewFile *.http set filetype=headers
autocmd FileType headers  set colorcolumn=

"Syntax for nmap files
autocmd BufRead,BufNewFile *.nmap set filetype=nmap

"Yes, I indent HTML
"autocmd FileType html set tabstop=1
"autocmd FileType html set nolist

autocmd FileType cpp,objc,objcpp,python nnoremap gyd :YcmCompleter GoTo<CR>
autocmd FileType python,typescript nnoremap gr :YcmCompleter GoToReferences<CR>

autocmd BufRead,BufNewFile *.ts set filetype=typescript

"An underline is too invasive, let's just change the contrast
hi CursorLine cterm=NONE ctermbg=black

augroup golang
	autocmd!
	let g:go_autodetect_gopath=0
	"Show a list of interfaces which is implemented by the type under your cursor with \s
	autocmd FileType go nmap <Leader>s <Plug>(go-implements)
	autocmd FileType go nmap <Leader>e :GoErrCheck<CR>
	autocmd FileType go nmap gr :GoReferrers<CR>
	autocmd FileType go nmap <Leader>r <Plug>(go-rename) 
	autocmd FileType go nmap <F5> <Plug>(go-run)
	autocmd FileType go nmap <leader>b <Plug>(go-build)
	"autocmd FileType go nmap <leader>t <Plug>(go-test)
	autocmd FileType go nmap <leader>t :GoCoverageToggle<CR>
	autocmd FileType go nmap <leader>a :GoAlternate<CR>
	autocmd FileType go nmap # <Plug>(go-def)
	autocmd FileType go nmap Z <Plug>Zeavim
	autocmd FileType go iabbrev iin  := range 
	autocmd FileType go iabbrev !! if err != nil { 
augroup END

"}}}
