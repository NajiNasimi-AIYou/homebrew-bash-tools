#!/bin/bash

# Get the path of the installed Homebrew executable
brew_path=$(brew --prefix)

# Get the path of the script
dir="/private/var/spe/homebrew/scripts"

if [ -z "$brew_path" ]; then
        echo 'Homebrew is not installed'
else
    echo 'Homebrew is installed'
    echo 'Grabbing Bundle dump'
    if ! brew bundle dump --describe --force --all --debug --file="$dir/Brewfile"; then
        echo "Brew bundle dump failed" >&2
        exit 1
    fi
fi

exit 0
