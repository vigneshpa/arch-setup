#!/bin/sh -x

set -eo pipefail

# Arch linux  packages

depackages=( starship openssh )
depackages="${depackages[@]}"
apt-get -y install depackages

cat > "~/.bashrc" <<- EOM
sshd
clear
echo "Entering Arch proot ..."
proot-distro login archlinux
if [ $? -eq 0 ]
then
  echo "Arch proot exited with 0"
  exit 0
else
  echo "Arch linux exited with code $?"
  echo "Entering termux shell ..."
  eval "$(starship init bash)"
fi
EOM
