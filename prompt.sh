#!/bin/bash

set -e pipefail


dot_files_dir="$HOME/.config/zsh"
plugins_dir="/usr/share/zsh/plugins"

mkdir -p "$dot_files_dir/cache"

# Arch linux  packages

packages=(zsh starship fortune-mod)
plugins=(zsh-autosuggestions zsh-syntax-highlighting)

if ! command -v pacman &> /dev/null
then
    echo "Warning: Pacman does not exists.  unknown environment"
    plugins_dir="$dot_files_dir/plugins"
    echo "Please install $packages packages manually manually. Installing plugins from github."
    echo "To update plugins run this command 'cd $dot_files_dir && bash ./update_plugins.sh'"
    cat > "$dot_files_dir/update_plugins.sh" << EOL
#!/bin/bash
mkdir -p "./plugins"
cd "plugins"
plugins=( ${plugins[@]} )
for plu in "\${plugins[@]}"
do
    plug_url="https://github.com.com/zsh-users/\${plu}.git"
    echo "downloading \$plu from \$plug_url"
    git clone "\$plug_url" --depth=1
done
EOL
    echo $(cd $dot_files_dir && bash ./update_plugins.sh)
else
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

chsh -s zsh

echo "Login again to see the changes"
