#! /usr/bin/env nix-shell
#! nix-shell -i bash -p xorg.xmodmap xorg.xset xdotool

set -x

while true; do
  xset r rate 250 50
  # set page up and page down to forward and back
  xmodmap -e 'keycode 117 = XF86Forward'
  xmodmap -e 'keycode 112 = XF86Back'
  # set shift+esc to tilde
  xmodmap -e 'keycode 9 = Escape asciitilde Escape'
  # unset caps lock
  xmodmap -e 'clear Lock'
  xmodmap -e 'keycode 66 = Control_L'
  # make sure caps lock is off
  if [ "$(xset q | grep Caps | awk '{print $4}')" = "on" ]; then
    xdotool key Caps_Lock
  fi
  sleep 20
done
