#!/bin/bash

# Function to check if brew is installed
check_brew_installed() {
  echo "PATH: $PATH"
  if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is installed."
  else
    echo "Homebrew is not installed."
  fi
}

# Call the function to check if brew is installed
check_brew_installed
exit 0
