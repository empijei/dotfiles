xcalib -d :0 ICM_PROFILES/X1_Carbon_EyeOne.icc &
bash -c 'xinput disable $(xinput | grep -oP "TM3072-003[^i]+id=\K[0-9]+")' &
chromium --no-startup-window &
#dropbox-cli start &
nm-applet &
clipit &
wmname LG3D &
xscreensaver -no-splash &
caffeine &
zeal &
#imwheel &
#exec awesome 

dbus-update-activation-environment --systemd DISPLAY
eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK

exec awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr

setxkbmap us && xmodmap ~/.Xmodmap-lite
