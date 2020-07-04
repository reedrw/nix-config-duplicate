#! /usr/bin/env nix-shell
#! nix-shell -i bash -p ncurses

# This script will update all of the sources.json files generated by niv

green="$(tput setaf 2)"
white="$(tput setaf 7)"
bold="$(tput bold)"
reset="$(tput sgr 0)"
hide="$(tput civis)"
norm="$(tput cnorm)"
chars="/-\|"
dir=$PWD

echo -en "$hide"

find . -type f -name "update-sources.sh" -exec readlink -f {} \; | while read -r updatescript; do
  (
    cd "$(dirname -- "$updatescript")" || exit
    (

      TEMP=$(mktemp)
      $updatescript > "$TEMP" &

      while [[ -d /proc/$! ]]; do
        for (( i=0; i<${#chars}; i++ )); do
          sleep 0.075
          echo -en "[$green${chars:$i:1}$reset]$white Running $bold$green$(realpath --relative-to="$dir" "$updatescript")$reset..." "\r"
        done
      done

      echo -e "\n\n$(<"$TEMP")\n"
      rm "$TEMP"
    )
  )
done

echo -en "$norm"

