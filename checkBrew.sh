#!/bin/bash

# Function to check if brew is installed
check_brew_installed() {
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is installed."
    brew_prefix=$(brew --prefix)
    echo "Homebrew prefix: $brew_prefix"
  else
    echo "Homebrew is not installed."
  fi
}

# Call the function to check if brew is installed
check_brew_installed
exit 0
