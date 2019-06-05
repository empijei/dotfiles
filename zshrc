export PATH="$HOME/bin:$PATH" 

[[ -z $DISPLAY && $XDG_VTNR -eq 1 && -z "$TMUX" ]] && exec startx

source ~/empijei/zshproject/sourcer.sourceme
source ~/empijei/zshproject/channels.sourceme
source ~/empijei/ctfconsole/sourceme
export EXTERNAL_PACKAGES="$HOME/external_packages"

alias erica="shuf -n 1 ~/Dropbox/note/lista-nomi-femminili.txt | tr -d '\n' | tee >(xclip -selection c)"

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

alias vt='vim +term +"wincmd o"'
alias vterm='vim +term +"wincmd o"'
