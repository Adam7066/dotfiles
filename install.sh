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

verify_checksum() {
    local expected_hash="$1"
    local filename="$2"
    echo "${expected_hash}  ${filename}" | shasum -a 256 -c -
    if [[ $? -ne 0 ]]; then
        echo "Checksum verification failed for ${filename}. Please check the file and try again."
        exit 1
    fi
}

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

        # feishin
        if [[ ! -d "~/Applications/Feishin.app" ]]; then
            curl -LO https://github.com/jeffvli/feishin/releases/download/v1.4.2/Feishin-1.4.2-mac-arm64.dmg
            verify_checksum "89a1384c572ed7dc4064c80cefcf9bb0a6c6f56e86f53f706e488b535dbb68af" "Feishin-1.4.2-mac-arm64.dmg"
            hdiutil attach Feishin-1.4.2-mac-arm64.dmg
            cp -R "/Volumes/Feishin 1.4.2-arm64/Feishin.app" ~/Applications/
            hdiutil detach "/Volumes/Feishin 1.4.2-arm64"
        else
            echo "Feishin is already installed."
        fi
    fi
fi

# symlink
if [[ $run_symlink == true ]]; then
    if [[ $(uname) == "Darwin" ]]; then
        # ghostty
        ln -sf "$(pwd)/ghostty/config" "~/Library/Application Support/com.mitchellh.ghostty/config"
        ln -sf "$(pwd)/ghostty/macos.config" "~/Library/Application Support/com.mitchellh.ghostty/macos.config"

        # git
        ln -sf "$(pwd)/git/.gitconfig" "~/.gitconfig"

        # vscode
        ln -sf "$(pwd)/vscode/settings.json" "~/Library/Application Support/Code/User/settings.json"
    fi
fi