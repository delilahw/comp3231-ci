#!/usr/bin/env bash
set -e

Blue=$(tput setaf 4)
Red=$(tput setaf 1)
Green=$(tput setaf 2)
Reset=$(tput sgr0)

# shellcheck disable=SC2088
LOCAL_BUNDLE_PATH="$1".bundle
UPLOAD_DIR='~/cs3231/bundles'

if [ -z "$1" ] || [ "$1" = "--help" ] || [ "$1" = "-h" ]; then
  echo "$Blue"CS3231/CS3821 Bundle Helper by @hellodavie"$Reset"
  printf "Usage:\n  run-bundle <assignment-code>\n  run-bundle asst1\n"
  exit 1
fi

echo Bundling assignment "$1" for give...
git bundle create "$LOCAL_BUNDLE_PATH" --all

echo "$Green"Uploading bundle to CSE $UPLOAD_DIR folder"$Reset"
scp "$LOCAL_BUNDLE_PATH" "cse.unsw.edu.au:$UPLOAD_DIR"

echo "$Green"'Starting login shell via SSH to CSE'"$Reset"
ssh -t cse.unsw.edu.au "cd $UPLOAD_DIR; zsh --login"

echo "Bundle Helper Exiting..."
