# Arch Setup
> This is my personel repo containing my setup scripts for arch linux
>
>But feel free to use them

## Shell and prompt

To install my zsh shell and starship prompt run the command below. This command uses pacman to fetch the required packages from Arch repos. To instal it on other linux distributions or any unix based systems run the command and do as it says.
### To Install ZSH and starship:
```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/prompt.sh | sh
```

## Arch proot on termux
To install arch linux on termux and to run it every time when you open it, run the following command in termux shell after installing proot-distro (``pkg install proot-distro``) and archlinux (``proot-distro install archlinux``)
### Setup arch linux on termux:
```sh
curl --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/vigneshpa/arch-setup/main/termux.sh | sh
```
>This script installs 'starship' in termux and arch and installs 'openssh' in termux. Tthe SSH Daemon (`sshd`) will be started every time when an user logs into termux

This script overwrites the .bashrc file in termux home and archlinux's root home. If you exit from the shell with 0 return code (e.g. `exit 0` or `exit`) the termux shell will also exit but if you exit with any non zero value the termux prompt will not close.