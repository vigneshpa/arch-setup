#!/bin/sh -x

set -eo pipefail

# Arch linux  packages

depackages=( zsh starship zsh-syntax-highlighting zsh-autosuggestions fortune-mod )
depackages="${depackages[@]}"
if [ "$1" -eq "--no-pacman" ]
then 
  echo "Please install $depackages manually"
else
 sudo pacman -S $depackages --noconfirm
fi
sudo usermod -s /bin/zsh $(whoami)

dot_files_dir="$HOME/.config/zsh"
mkdir -p $dot_files_dir/cache

echo "export ZDOTDIR=~/.config/zsh" >> ~/.zshenv

curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/.zshrc -o "$dot_files_dir/.zshrc"
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/starship.toml -o "$dot_files_dir/../starship.toml"