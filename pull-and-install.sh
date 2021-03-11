#!/usr/bin/env nix-shell
#! nix-shell -i bash -p jq gh git curl

set -e

api="https://api.github.com"
user="reedrw"
repo="nix-config"

mainUrl="$api/repos/$user/$repo"

# Get latest reedbot PR numbers
PRs=$(curl "$mainUrl/pulls" | jq -r '.[] | select(.user.login == "reedbot[bot]") | .number')

main(){
  pushd ~/.config/nixpkgs > /dev/null || exit
  for prNumber in $PRs; do

    # Get PR ref
    prRef="$(curl "$mainUrl/pulls/$prNumber" | jq -r '.head.sha')"

    # Get GitHub Action workflow conclusion
    prConclusion="$(curl "$mainUrl/commits/$prRef/check-suites" | jq -r '.check_suites[] | select(.app.slug == "github-actions") | .conclusion')"

    if [[ $prConclusion == "success" ]]; then
      gh pr merge "$prNumber" -dm
      merged="true"
    fi

  done
  if [[ $merged == "true" ]]; then
    git pull
    ./install.sh
  else
    exit 1
  fi
  popd > /dev/null || exit
}

main "$@"
