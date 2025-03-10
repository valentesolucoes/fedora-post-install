#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Por favor execute o script como usuário root"
  exit
fi

echo atualizado o sistema...
dnf upgrade --refresh -y

echo Configurando mirrors...
grep -qxF "max_parallel_downloads=10" /etc/dnf/dnf.conf || echo "max_parallel_downloads=10" >> /etc/dnf/dnf.conf
grep -qxF "fastestmirror=True" /etc/dnf/dnf.conf || echo "fastestmirror=True" >> /etc/dnf/dnf.conf
grep -qxF "deltarpm=true" /etc/dnf/dnf.conf || echo "deltarpm=true" >> /etc/dnf/dnf.conf

echo Atualizando sistema...
dnf update -y && dnf upgrade -y

echo Instalando dnf5...
dnf install dnf5 dnf5-plugins -y

echo Firmware Updates...
fwupdmgr get-devices
fwupdmgr refresh --force
fwupdmgr get-updates
fwupdmgr update -y

echo Habilitando RPM Fusion...
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm -y
dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm -y

echo Instalando RPM Fusion não livres...
dnf upgrade --refresh -y
dnf -y groupupdate core 
dnf install -y rpmfusion-free-release-tainted
dnf install -y rpmfusion-nonfree-release-rawhide 
dnf install -y dnf-plugins-core

echo Suporte a SNAP...
dnf install -y snapd
ln -s /var/lib/snapd/snap /snap
reboot now

echo Suporte a DVD...
dnf install -y libdvdcss

echo Instalando Gnome Tweaks...
dnf install gnome-tweak-tool gnome-extensions-app -y

echo Instalando Google Chrome...
dnf install wget -y
wget -c -P /tmp/ https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
dnf localinstall /tmp/google-chrome-stable_current_x86_64.rpm -y

echo Instalando Codecs de Mídia...
dnf config-manager setopt fedora-isco-openh264.enabled=1
dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav mozilla-openh264 --exclude=gstreamer1-plugins-bad-free-devel - y
dnf install lame --exclude=lame-devel -y
dnf group upgrade --with-optional --allowerasing Multimedia -y

echo Instalando vlc...
dnf install vlc -y

dnf group install sound-and-video -y

echo Porcentagem de bateria de notebook
#gsettings set org.gnome.desktop.interface show-battery-percentage true


echo Compressores de arquivo...
dnf install p7zip p7zip-plugins unrar unzip gzip -y

#echo Instalando Brave Browser...
#dnf install dnf-plugins-core -y
#dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
#rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
#dnf install brave-browser -y

echo Instalando Code...
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
dnf install code -y

#echo Instalando qbittorrent...
#dnf install qbittorrent -y

echo Instalando Java...
dnf install java-21-openjdk -y

echo Habilitando flathub...
flatpak remote-modify --enable flathub

echo Instalando deluge torrent
flatpak install flathub org.deluge_torrent.deluge

echo Instalando Build Essentials...
dnf group install "C Development Tools and Libraries" "Development Tools"

echo Instalando extensão GSCONNECT
dnf install -y gnome-shell-extension-gsconnect
# Depois em extenções instalar a extensão gsconnect e
# Instalar o KDE Connect no celular

echo Instalando VirtualBox
dnf install -y @development-tools
dnf install -y kernel-devel kernel-headers dkms qt5-qtx11extras
rpm --import https://www.virtualbox.org/download/oracle_vbox.asc
wget -P /etc/yum.repos.d/ http://download.virtualbox.org/virtualbox/rpm/fedora/virtualbox.repo
dnf install -y VirtualBox-7.1
usermod -a -G vboxusers $USER
#extra Pack
wget https://download.virtualbox.org/virtualbox/7.1.0/Oracle_VM_VirtualBox_Extension_Pack-7.1.0.vbox-extpack
reboot

echo instalando MySQL Workbench
wget https://dev.mysql.com/get/mysql84-community-release-fc41-1.noarch.rpm
rpm -Uvh mysql84-community-release-*
dnf install mysql-workbench -y


echo Outros Programas
dnf install -y thunderbird
dnf install -y filezilla
dnf install -y gimp
dnf install -y speedtest-cli
dnf install -y htop
dnf install -y libreoffice
dnf install -y calibre
dnf install -y fastfetch cmatrix

######################################
# Apps Loja
######################################
# + GitHub Desktop
# + Gerenciador Extensões 
# + spotify
# + discord
# + ZapZap (whatsapp)
# + Telegram 
# + Gnome Password Generator
# + KeepassXC
# + Anydesk 
# + Rusrtdesk 
# docker
# PDF Editor/Merge
