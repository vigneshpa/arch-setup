#!/bin/sh

set -e pipefail

dot_files_dir="$HOME/.config/zsh"
plugins_dir="/usr/share/zsh/plugins"

mkdir -p "$dot_files_dir/cache"

packages="zsh starship fortune-mod"
plugins="zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search"


# Installing packages
command -v pacman >/dev/null 2>&1 && {
    echo "Installing packages from pacman. Plugins will be automatically updated when system is updated"
    packages="$packages $plugins"
    sudo pacman -S $packages --noconfirm
} || {
    plugins_dir="$dot_files_dir/plugins"
    echo "Warning: Pacman does not exists."
    echo "Please install $packages packages manually manually. Installing zsh plugins from github."
    echo "To update plugins run this command 'cd $dot_files_dir && sh ./update_plugins.sh'"
    cat > "$dot_files_dir/update_plugins.sh" << EOL
#!/bin/sh
cd "$dot_files_dir/plugins"
for plu in \$(ls)
do
    cd \$plu
    echo "updating \$plu"
    git pull origin --depth=1
    cd ..
done
EOL
    mkdir -p "$dot_files_dir/plugins"
    cd "$dot_files_dir/plugins"
    for plu in $plugins
    do
        plug_url="https://github.com/zsh-users/${plu}.git"
        echo "downloading $plu from $plug_url"
        git clone $plug_url --depth=1
    done
}

# Writing .zprofile file
cat > "$HOME/.zprofile" << EOL
[[ -e ~/.profile ]] && emulate sh -c 'source ~/.profile' # sourcing .profile if it exists
export ZDOTDIR="$dot_files_dir"   # Required to load zshrc
export ZPLUGDIR_X="$plugins_dir"  # Required to load zsh plugins
EOL

cat >> "$HOME/.profile" << EOL
PATH=$PATH
EDITOR=nano
EOL

# Downloading  dot files
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/.zshrc -o "$dot_files_dir/.zshrc"
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/starship.toml -o "$dot_files_dir/../starship.toml"
# Changing current shell
chsh -s $(which zsh 2>/dev/null) </dev/tty && echo "Login again to see the changes" || echo "Cannot the shell. Change the shell manually."
exit 0
