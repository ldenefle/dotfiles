[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xbindkeys
xset r rate 300 40

hsetroot -solid '#000000'
picom --no-dnd-shadow --no-fading-openclose &

# Gets rid of mouse when not using it
/usr/bin/unclutter &
# Notification service
dunst -config ~/.config/dunst/dunstrc \
  -cb "$(xgetres color0)" \
  -lb "$(xgetres color0)" \
  -nb "$(xgetres color0)" \
  -cf "$(xgetres color7)" \
  -lf "$(xgetres color7)" \
  -nf "$(xgetres color7)" \
  -bf "$(xgetres color7)" \
  -frame_color "$(xgetres color7)" &

.local/bin/dwm-bar &

# Makes sure to be on the right monitor
autorandr -c
exec dwm
