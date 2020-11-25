# Statusbar loop
while xsetroot -name "`date` `uptime | sed 's/.*,//'`"
do
	sleep 1
done &

[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xbindkeys
xset r rate 300 40

# Gets rid of mouse when not using it
/usr/bin/unclutter &
# Notification service
/usr/bin/dunst &

exec dwm
