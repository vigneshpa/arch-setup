#!/bin/bash

set -e pipefail


dot_files_dir="$HOME/.config/zsh"
plugins_dir="/usr/share/zsh/plugins"

mkdir -p "$dot_files_dir/cache"

# Arch linux  packages

packages=(zsh starship fortune-mod)
plugins=(zsh-autosuggestions zsh-syntax-highlighting zsh-history-substring-search)

if ! command -v pacman &> /dev/null
then
    echo "Warning: Pacman does not exists.  unknown environment"
    plugins_dir="$dot_files_dir/plugins"
    echo "Please install $packages packages manually manually. Installing plugins from github."
    echo "To update plugins run this command 'cd $dot_files_dir && bash ./update_plugins.sh'"
    cat > "$dot_files_dir/update_plugins.sh" << EOL
#!/bin/bash
cd "$dot_files_dir/plugins"
for plu in $(ls)
do
    cd \$plu
    echo "updating \$plu"
    git pull origin --depth=1
    cd ..
done
EOL
    mkdir -p "$dot_files_dir/plugins"
    cd "$dot_files_dir/plugins"
    for plu in ${plugins[@]}
    do
        plug_url="https://github.com/zsh-users/${plu}.git"
        echo "downloading $plu from $plug_url"
        git clone $plug_url --depth=1
    done
else
    echo "Installing plugins from pacman. Plugins will be automatically updated when system is updated"
    packages="${packages[@]} ${plugins[@]}"
    sudo pacman -S $packages --noconfirm
fi

cat > "$HOME/.zshenv" << EOL
export PATH="\$PATH"            # Change this line to change path variable
export ZDOTDIR="$dot_files_dir"   # Required to load zshrc
export ZPLUGDIR_X="$plugins_dir"  # Required to load zsh plugins
EOL

curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/.zshrc -o "$dot_files_dir/.zshrc"
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/starship.toml -o "$dot_files_dir/../starship.toml"

if ! command -v pacman &> /dev/null
then
    echo "cannot find zsh change the shell manually"
else
    chsh -s $(which zsh 2>/dev/null) </dev/tty
    echo "Login again to see the changes"
fi
