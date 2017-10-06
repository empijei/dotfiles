#vared to live edit vars (es: vared PATH)
#massive file renaming: zmv '(*).txt' '$1.html'

export PATH="$HOME/bin:$PATH" 

#[[ -z $DISPLAY && $XDG_VTNR -eq 1 && -z "$TMUX" ]] && exec startx

source ~/empijei/zshproject/sourcer.sourceme
source ~/empijei/zshproject/channels.sourceme
source ~/empijei/ctfconsole/sourceme
source "$HOME/Reinstall/arch/maintenance/maintenance.sh"
export PASSWORD_STORE_DIR="$HOME/empijei/pass"
export PASSWORD_STORE_GIT="$HOME/empijei/pass"
export EXTERNAL_PACKAGES="$HOME/external_packages"

#TODO add home/bin to path if not under X

alias nessus="vboxmanage startvm PTBox1604 --type headless && sleep 15 && ssh pentester@PTBox.local"
#alias maintenance="zsh $HOME/Reinstall/arch/maintenance/maintenance.sh"
alias erica="shuf -n 1 ~/Dropbox/note/lista-nomi-femminili.txt | tr -d '\n' | tee >(xclip -selection c)"
alias alessandro="shuf -n 1 ~/Dropbox/note/lista-nomi-maschili.txt | tr -d '\n' | tee >(xclip -selection c)"
dock-msf(){
	export PATH="$HOME/external_packages/github.com/rapid7/metasploit-framework/docker/bin:$PATH"
}

# added by travis gem
[ -f /home/rob/.travis/travis.sh ] && source /home/rob/.travis/travis.sh
