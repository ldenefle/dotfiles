[[ -f ~/.Xresources ]] && xrdb -merge -I$HOME ~/.Xresources
xbindkeys
xset r rate 300 40

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

dwmblocks &

exec dwm
