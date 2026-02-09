# symlink
if [[ $(uname) == "Darwin" ]]; then
    # ghostty
    ln -sf "$(pwd)/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    ln -sf "$(pwd)/ghostty/macos.config" "$HOME/Library/Application Support/com.mitchellh.ghostty/macos.config"

    # git
    ln -sf "$(pwd)/git/.gitconfig" "$HOME/.gitconfig"
fi