set nocompatible  "Be IMproved
syntax on
let mapleader = "\\"


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
command! NoL set spell spelllang=
"Autocorrect with first autocorrect entry
nnoremap zz [sz=i1<CR><CR>e
nnoremap Z [sz=i1<CR><CR>A

command! LineEndings e ++ff=dos<CR>

"Reload .vimrc
command! Reconf source $HOME/.vimrc

"delete empty lines
command! Strip g/^\s*$/d

"for extra impact
nnoremap H :r ! figlet 

"reformat document
nnoremap <c-f> gg=G``
inoremap <c-f> <Esc>gg=G``i

"Surround word with " ' _ * -
nnoremap <leader>" bi"<esc>ea"
nnoremap <leader>' bi'<esc>ea'
nnoremap <leader>_ bi_<esc>ea_
nnoremap <leader>* bi*<esc>ea*
nnoremap <leader>- bi__<esc>ea__
autocmd FileType markdown inoremap <C-b> __
autocmd FileType markdown inoremap <C-i> _

"esc key is a serious overstretch
inoremap jk <esc>

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
set number "line numbers
set mouse=a "mouse integration
set hlsearch "highlights search result. use :C to clear
set modeline "see http://vim.wikia.com/wiki/Modeline_magic
set smartcase "search insensitive if no uppercase letters appear in the search pattern
set incsearch "move while searching
set tabstop=3 "prints the tab character as spaces
set ignorecase "default for smartcase
set shiftwidth=3 "colum to reindent on reindent command
set colorcolumn=80 "Mark the 80th character
set listchars=tab:\│· "Prints tabs as │···
set fillchars+=vert:\ "removes pipe marker in split
set clipboard=unnamedplus "System clipboard integration
set omnifunc=syntaxcomplete#Complete "http://vim.wikia.com/wiki/Omni_completion
"Set the mark at 80th character to be blue instead of eyekilling red
"}}}

"Spellcheck for latex
autocmd FileType tex set spell spelllang=it_it
autocmd FileType tex set colorcolumn=0
let g:tex_flavor = "latex"

"Yes, I indent HTML
autocmd FileType html set tabstop=1
autocmd FileType html set nolist

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

"TODO
"autocmd FileType javascript nnoremap <buffer> <leader>c I//<esc>
"autocmd FileType python     nnoremap <buffer> <leader>c I#<esc>
"autocmd FileType python     :iabbrev <buffer> iff if:<left>
"autocmd FileType javascript :iabbrev <buffer> iff if ()<left>
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

"Syntax highlight correction for nmap script engine
autocmd BufRead,BufNewFile *.nse set filetype=lua

"Functions to insert time of the day {{{
nnoremap <F7> "=strftime("%c")<CR>P
inoremap <F7> <C-R>=strftime("%c")<CR>
nnoremap <F6> "=strftime("%d/%m/%Y")<CR>P
inoremap <F6> <C-R>"=strftime("%d/%m/%Y")<CR>
"}}}

autocmd FileType java nnoremap gd <C-]>

"Ctrl-s to save {{{
"WARNING: you have to put 
"stty -ixon
"in your bashrc file or this will not work
inoremap <c-s> <esc>:w<CR>a
"}}}

"move lines on Ctrl+Arrows{{{
nnoremap <c-Down> :m .+1<CR>==
nnoremap <c-Up> :m .-2<CR>==
inoremap <c-Down> <Esc>:m .+1<CR>==gi
inoremap <c-Up> <Esc>:m .-2<CR>==gi
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi
"}}}

colorscheme default
highlight ColorColumn ctermbg=blue
highlight Search cterm=NONE ctermbg=yellow ctermfg=black
highlight Visual cterm=NONE ctermbg=yellow ctermfg=black
highlight SpellBad cterm=NONE ctermfg=black ctermbg=red 
highlight SpellCap cterm=NONE ctermfg=white ctermbg=blue 
"
"GVim default theme is seriously ugly{{{
if has('gui_running')
	colorscheme torte
endif "}}}

" Vimscript {{{
augroup filetype_vim
	autocmd!
	"this allows folding in vimscript
	autocmd FileType vim setlocal foldmethod=marker
augroup END
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
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

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

"PLUGINS {{{
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'fatih/vim-go'
Plugin 'scrooloose/nerdtree'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'shime/vim-livedown'
Plugin 'Valloric/YouCompleteMe'
Plugin 'ervandew/supertab'
Plugin 'maksimr/vim-jsbeautify'
Plugin 'KabbAmine/zeavim.vim'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'OmniSharp/omnisharp-vim'
Plugin 'tpope/vim-dispatch'
Plugin 'majutsushi/tagbar'
Plugin 'scrooloose/nerdcommenter'
Plugin 'keith/swift.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'davidhalter/jedi-vim'
Plugin 'vim-scripts/Nmap-syntax-highlight'
Plugin 'kchmck/vim-coffee-script'
call vundle#end()
filetype plugin indent on

"Tagbar
nnoremap T :TagbarToggle<CR>

"vim-markdown
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_folding_disabled = 1
autocmd FileType markdown nnoremap T :Toc<CR>

"NerdTree
map <C-n> :NERDTreeToggle<CR>

"SuperTab
let g:SuperTabDefaultCompletionType = "<c-n>"

"Zeavim
nmap gzz <Plug>Zeavim
" <leader>z (NORMAL mode)
vmap gzz <Plug>ZVVisSelection   
" <leader>z (VISUAL mode)
nmap gz <Plug>ZVMotion         
" gz{motion} (NORMAL mode)
nmap gZ <Plug>ZVKeyDocset      
" <leader><leader>z

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

augroup golang
	autocmd!
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
	"Yes, i am this level of lazy
	"FIXME	autocmd FileType go :iabbrev <buffer> { {<CR><CR>}<Up>
augroup END
"}}}
""Syntastic
"	let g:syntastic_go_checkers = ['']
"	let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
"	set statusline+=%#warningmsg#
"	set statusline+=%{SyntasticStatuslineFlag()}
"	set statusline+=%*
"	let g:syntastic_always_populate_loc_list = 1
"	let g:syntastic_auto_loc_list = 1
"	let g:syntastic_check_on_open = 1
"	let g:syntastic_check_on_wq = 0
"	nnoremap :S :SyntasticToggleMode

let g:OmniSharp_timeout = 1
" this setting controls how long to wait (in ms) before fetching type / symbol information.
set updatetime=500
" Remove 'Press Enter to continue' message when type information is longer than one line.
augroup omnisharp_commands
    autocmd!

    "Set autocomplete function to OmniSharp (if not using YouCompleteMe completion plugin)
    autocmd FileType cs setlocal omnifunc=OmniSharp#Complete

    "show type information automatically when the cursor stops moving
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()

    "The following commands are contextual, based on the current cursor position.
    autocmd FileType cs nnoremap gd :OmniSharpGotoDefinition<cr>
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

autocmd FileType cs nnoremap gd <C-]>

autocmd FileType markdown set colorcolumn=
autocmd FileType tex inoremap <c-a> <Esc>[sz=i1<CR><CR>A
autocmd FileType markdown inoremap <c-a> <Esc>[sz=i1<CR><CR>A
autocmd BufRead,BufNewFile *.nmap set filetype=nmap

autocmd FileType c,cpp,objc,objcpp,javascript,python nnoremap gd :YcmCompleter GoTo<CR>
autocmd FileType python,typescript,javascript nnoremap gr :YcmCompleter GoToReferences<CR>

