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

function remove_eval() {
    # Define the line to remove
    line_to_remove='eval "$(/opt/homebrew/bin/brew shellenv)"'

    # Identify the current shell and set the shell config file
    current_shell=$(basename "$SHELL")
    if [[ "$current_shell" == "bash" ]]; then
        config_file=~/.bashrc
    elif [[ "$current_shell" == "zsh" ]]; then
        config_file=~/.zprofile
    else
        echo "Unsupported shell. Exiting."
        exit 1
    fi

    # Create a temporary file
    temp_file=$(mktemp)

    # Loop through the shell config file, excluding the line to remove and write the result to the temporary file
    while IFS= read -r line; do
    if [[ "$line" != "$line_to_remove" ]]; then
        echo "$line" >> "$temp_file"
    fi
    done < "$config_file"

    # Replace the original shell config file with the modified temporary file
    mv "$temp_file" "$config_file"

    # Set the file permissions
    chmod 644 "$config_file"

    # Print a message
    echo "Line removed from $config_file"
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
                sed -i.bak '/HOMEBREW_CASK_OPTS/d' $file
                sed -i.bak '/PATH.*homebrew/d' $file
                cat $file
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
                sed -i.bak '/HOMEBREW_CASK_OPTS/d' $file
                sed -i.bak '/PATH.*homebrew/d' $file
                cat $file
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
            echo "must use uninstall main policy"
            shellCleanUp
            remove_eval
            exit 0
        else
            echo 'Using the custom Homebrew uninstall script'
            # Download and run the custom Homebrew uninstall script for other installation paths
            curl -o /private/tmp/uninstall.sh https://raw.githubusercontent.com/NajiNasimi-AIYou/sudoLessUninstall.sh/main/uninstall.sh
            NONINTERACTIVE=1 /bin/bash /private/tmp/uninstall.sh --path=$(brew --prefix) --quiet
            remainingFiles
            shellCleanUp
            remove_eval
        fi
    fi
}

main
exit 0
