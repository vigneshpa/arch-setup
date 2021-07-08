#!/bin/sh -x

set -eo pipefail


dot_files_dir="$HOME/.config/zsh"
mkdir -p $dot_files_dir/cache

# Arch linux  packages

packages=( zsh starship fortune-mod )
plugins=( zsh-autosuggestions zsh-syntax-highlighting )

pacman -V
if [ $? -eq 0 ]
then
    packages="${depackages[@]} ${plugins[@]}"
    sudo pacman -S $packages --noconfirm
else
    echo "Please install $packages packages manually manually. Installing plugins from github. To update plugins run this command 'sh $dot_files_dir/update_plugins'"
    cat > "$dot_files_dir/update_plugins.sh" << EOL
#!/bin/sh
for plu in "${plugins[@]}"
do
    plug_dir="/usr/share/zsh/plugins/\$plu"
    sudo mkdir -p \$plug_dir
    sudo curl --proto '=https' --tlsv1.2 -sSf "https://raw.githubusercontent.com/zsh-users/\$plu/master/\$plu.zsh" -o "\$plugin_dir/\$plu.zsh"
done
EOL
    sh "$dot_files_dir/update_plugins"
fi

echo "export ZDOTDIR=~/.config/zsh" >> ~/.zshenv

curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/.zshrc -o "$dot_files_dir/.zshrc"
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/starship.toml -o "$dot_files_dir/../starship.toml"

sudo usermod -s /bin/zsh $(whoami)
