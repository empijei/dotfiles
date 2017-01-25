#vared to live edit vars (es: vared PATH)
#massive file renaming: zmv '(*).txt' '$1.html'

[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && export PATH="$HOME/bin:$PATH" && exec startx

source ~/empijei/zshproject/sourcer.sourceme
source ~/empijei/ctfconsole/sourceme
