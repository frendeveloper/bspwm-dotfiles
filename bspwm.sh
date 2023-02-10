#!/bin/bash
# Check if Script is Run as Root
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user to run this script, please run sudo ./install.sh" 2>&1
  exit 1
fi

username=$(id -u -n 1000)
builddir=$(pwd)

# Update packages list and update system
apt update
apt upgrade -y

# Install nala
apt install nala -y

sudo apt install git build-essential manpages-dev
git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin && makepkg -si
sudo apt install wget curl git kitty telegram-desktop bspwm sxhkd feh polybar x11-xserver-utils xbacklight light pamix picom dunst rofi flameshot network-manager network-manager-gnome xfce4-power-manager xfce4-settings zsh zsh-autosuggestions zsh-syntax-highlighting papirus-icon-theme libqt5svg5 qml-module-qtquick-controls qml-module-qtquick-controls2 feh bspwm sxhkd kitty rofi polybar picom thunar nitrogen lxpolkit unzip yad wget pulseaudio pavucontrol -y
sudo systemctl enable NetworkManager.service
sudo snap install ksuperkey
git clone https://github.com/frendeveloper/bspwm-dotfiles --depth 1
cd bspwm-dotfiles
cp -R .config/* ~/.config/
chmod -R +x ~/.config/bspwm
cp .zshrc ~
cp .zshrc-personal ~
mkdir ~/.local/bin
cp -R .local/bin/* ~/.local/bin
chmod -R +x ~/.local/bin
betterlockscreen -u ~/.config/bspwm/backgrounds/evening-sky.png
sudo systemctl enable betterlockscreen@$USER.service
