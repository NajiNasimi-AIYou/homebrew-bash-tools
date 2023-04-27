#!/bin/bash

# Get the path of the installed Homebrew executable
brew_path=$(brew --prefix)

function remainingFiles() {
    # Check if the installation directory still exists after uninstalling Homebrew
    if [ -d "$brew_path" ]; then
        echo 'Removing remaining Homebrew installation directory'
        # Remove the remaining Homebrew installation directory
        rm -rf $brew_path
    else
        echo 'Homebrew installation directory successfully removed'
    fi
}

function shellCleanUp() {
    # Check if the user has BASH or ZSH
    if [[ "$SHELL" == *"bash"* ]]; then
        echo 'BASH shell detected'
        # Loop through .bash_profile and .bashrc files
        for file in ~/.bash_profile ~/.bashrc; do
            # Check if the file exists
            if [ -f $file ]; then
                echo "Cleaning up Homebrew-related lines in $file"
                # Remove the lines containing HOMEBREW_CASK_OPTS and homebrew PATH from the file
                # and create a backup of the original file with a .bak extension
                sed -i.bak 's/eval "\$\(\/opt\/homebrew\/bin\/brew shellenv\)"//g' $file
                sed -i.bak '/HOMEBREW_CASK_OPTS/d' $file
                sed -i.bak '/PATH.*homebrew/d' $file
            fi
        done
    elif [[ "$SHELL" == *"zsh"* ]]; then
        echo 'ZSH shell detected'
        # Loop through .zshrc and .zprofile files
        for file in ~/.zshrc ~/.zprofile; do
            # Check if the file exists
            if [ -f $file ]; then
                echo "Cleaning up Homebrew-related lines in $file"
                # Remove the lines containing HOMEBREW_CASK_OPTS and homebrew PATH from the file
                # and create a backup of the original file with a .bak extension
                sed -i.bak 's/eval "\$\(\/opt\/homebrew\/bin\/brew shellenv\)"//g' $file
                sed -i.bak '/HOMEBREW_CASK_OPTS/d' $file
                sed -i.bak '/PATH.*homebrew/d' $file
            fi
        done
    else
        # Inform the user that neither BASH nor ZSH shell is used
        # and manual cleanup may be required
        echo "Neither BASH nor ZSH shell is used. Manual cleanup may be required."
    fi
}

function main() {
    # Check if Homebrew is installed
    if [ -z "$brew_path" ]; then
        echo 'Homebrew is not installed'
    else
        echo 'Homebrew is installed'
        echo 'Removing Homebrew at this path' $brew_path
        # Check if the brew_path is either "/opt/homebrew" or "/usr/local"
        if [[ "$brew_path" == "/opt/homebrew" ]] || [[ "$brew_path" == "/usr/local" ]]; then
            echo 'Using the official Homebrew uninstall script'
            # Run the official Homebrew uninstall script
            jamf policy -event uninstallBrewOfficial
            shellCleanUp
        else
            echo 'Using the custom Homebrew uninstall script'
            # Download and run the custom Homebrew uninstall script for other installation paths
            curl -o /private/tmp/uninstall.sh https://raw.githubusercontent.com/NajiNasimi-AIYou/sudoLessUninstall.sh/main/uninstall.sh
            NONINTERACTIVE=1 /bin/bash /private/tmp/uninstall.sh --path=$(brew --prefix) --quiet
            remainingFiles
            shellCleanUp
        fi
    fi
}

main
exit 0