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

# Making .config and Moving config files and background to Pictures
cd "$builddir" || exit
mkdir -p "/home/$username/.config"
mkdir -p "/home/$username/.fonts"
mkdir -p "/home/$username/Pictures"
mkdir -p /usr/share/sddm/themes
cp .Xresources "/home/$username"
cp .Xnord "/home/$username"
cp -R dotconfig/* "/home/$username/.config/"
cp bg.jpg "/home/$username/Pictures/"
chown -R "$username:$username" "/home/$username"

sudo apt install git build-essential manpages-dev

# Installing sugar-candy dependencies
nala install libqt5svg5 qml-module-qtquick-controls qml-module-qtquick-controls2 -y
# Installing Essential Programs 
nala install feh bspwm sxhkd kitty rofi polybar picom thunar nitrogen lxpolkit x11-xserver-utils unzip yad wget pulseaudio pavucontrol -y
# Installing Other less important Programs
nala install neofetch flameshot psmisc mangohud vim lxappearance papirus-icon-theme fonts-noto-color-emoji sddm variety jq dunst -y

sudo apt install curl git kitty telegram-desktop bspwm sxhkd feh polybar xbacklight light pamix picom dunst rofi flameshot network-manager network-manager-gnome xfce4-power-manager xfce4-settings zsh zsh-autosuggestions zsh-syntax-highlighting -y
sudo systemctl enable NetworkManager.service
sudo snap install ksuperkey

# Installing fonts
cd "$builddir" || exit
nala install fonts-font-awesome -y
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/FiraCode.zip
unzip FiraCode.zip -d "/home/$username/.fonts"
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.1.0/Meslo.zip
unzip Meslo.zip -d "/home/$username/.fonts"
mv dotfonts/fontawesome/otfs/*.otf "/home/$username/.fonts/"
chown "$username:$username" "/home/$username/.fonts/*"
# Reloading Font
fc-cache -vf
# Removing zip Files
rm ./FiraCode.zip ./Meslo.zip


#Betterlockscreen
wget https://github.com/betterlockscreen/betterlockscreen/archive/refs/heads/main.zip
unzip main.zip
cd betterlockscreen-main/
chmod u+x betterlockscreen
cp betterlockscreen /usr/local/bin/
cp system/betterlockscreen@.service /usr/lib/systemd/system/
betterlockscreen -u ~/.config/bspwm/backgrounds/evening-sky.png
sudo systemctl enable betterlockscreen@$USER.service

# Install Nordzy cursor
git clone https://github.com/alvatip/Nordzy-cursors
cd Nordzy-cursors || exit
./install.sh
cd "$builddir" || exit
rm -rf Nordzy-cursors

# Install brave-browser
sudo nala install apt-transport-https curl -y
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo nala update
sudo nala install brave-browser -y

# Enable graphical login and change target from CLI to GUI
tar -xzvf slice.tar.gz --strip 1 --one-top-level=/usr/share/sddm/themes/slice
cp -f "$builddir/sddm.conf" /etc/
systemctl enable sddm
systemctl set-default graphical.target


git clone https://github.com/frendeveloper/bspwm-dotfiles --depth 1
cd bspwm-dotfiles
cp -R .config/* ~/.config/
chmod -R +x ~/.config/bspwm
cp .zshrc ~
cp .zshrc-personal ~
mkdir ~/.local/bin
cp -R .local/bin/* ~/.local/bin
chmod -R +x ~/.local/bin
