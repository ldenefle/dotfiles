[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
kbdrate -d 2
exec dwm
