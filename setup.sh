# symlink
if [[ $(uname) == "Darwin" ]]; then
    ln -sf "$(pwd)/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"
    ln -sf "$(pwd)/ghostty/macos.config" "$HOME/Library/Application Support/com.mitchellh.ghostty/macos.config"
fi