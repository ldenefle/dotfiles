[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xbindkeys
xset r rate 300 40
exec dwm
