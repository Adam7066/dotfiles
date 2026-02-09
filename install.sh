#!/bin/bash
run_package=false
run_symlink=false

if [[ $# -eq 0 ]]; then
    run_package=true
    run_symlink=true
else
    for arg in "$@"; do
        case $arg in
            --package)
                run_package=true
                ;;
            --symlink)
                run_symlink=true
                ;;
            *)
                echo "Unknown argument: $arg"
                echo "Usage: $0 [--package] [--symlink]"
                exit 1
                ;;
        esac
    done
fi

# package
if [[ $run_package == true ]]; then
    if [[ $(uname) == "Darwin" ]]; then
        # homebrew
        if ! command -v brew &> /dev/null; then
            echo "Homebrew not found. Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            if ! command -v brew &> /dev/null; then
                echo "Failed to install Homebrew. Please check the installation script and try again."
                exit 1
            fi
        fi
        brew bundle cleanup --file="$(pwd)/Brewfile"
        brew bundle install --file="$(pwd)/Brewfile"
    fi
fi

# symlink
if [[ $run_symlink == true ]]; then
    if [[ $(uname) == "Darwin" ]]; then
        # ghostty
        ln -sf "$(pwd)/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
        ln -sf "$(pwd)/ghostty/macos.config" "$HOME/Library/Application Support/com.mitchellh.ghostty/macos.config"

        # git
        ln -sf "$(pwd)/git/.gitconfig" "$HOME/.gitconfig"

        # vscode
        ln -sf "$(pwd)/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
    fi
fi