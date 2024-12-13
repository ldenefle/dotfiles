[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xbindkeys
xset r rate 300 40

# Pause whatever music is playing
mpc pause

# Set black background
hsetroot -solid '#000000'

# Gets rid of mouse when not using it
/usr/bin/unclutter &

# Notification service
dunst -config ~/.config/dunst/dunstrc &

# Activate dwm-bar
.local/bin/dwm-bar &

# List dhcp leases
dhcp-list-leases --daemon &

# Start picom
picom --daemon --config ~/.config/picom/picom.conf

# Makes sure to be on the right monitor
autorandr -c
exec dwm
