#! /usr/bin/env nix-shell
#! nix-shell -i bash -p coreutils ncurses

# This script will update all of the sources.json files generated by niv

green="$(tput setaf 2)"
white="$(tput setaf 7)"
bold="$(tput bold)"
reset="$(tput sgr 0)"
chars="/-\|"
dir=$PWD

find . -type f -name "update-sources.sh" -exec readlink -f {} \; | while read -r updatescript; do
  (
    cd "$(dirname -- "$updatescript")" || exit
    (
      while :; do
        for (( i=0; i<${#chars}; i++ )); do
          sleep 0.075
          echo -en "[${chars:$i:1}]" "$white Running $bold$green$(realpath --relative-to="$dir" "$updatescript")$reset..." "\r"
        done
      done &
      trap 'kill -9 $!' $(seq 0 15)

      TEMP=$(mktemp)
      $updatescript > "$TEMP"
      echo -e "\n\n$(<"$TEMP")\n"
      rm "$TEMP"
    )
  )
done
