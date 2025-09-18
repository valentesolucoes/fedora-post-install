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

echo instalando GParted...
dnf install -y gparted

echo Instalando dnf5...
dnf install -y dnf5 dnf5-plugins

echo Firmware Updates...
fwupdmgr get-devices
fwupdmgr refresh --force
fwupdmgr get-updates
fwupdmgr update -y

echo Habilitando RPM Fusion...
dnf install -y https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm
dnf install -y https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

echo Instalando RPM Fusion não livres...
dnf upgrade --refresh -y
dnf group upgrade core -y 
dnf install -y rpmfusion-free-release-tainted
dnf install -y rpmfusion-nonfree-release-rawhide 
dnf install -y dnf-plugins-core
docker --version

echo Instalando driver da Broadcom WiFi/Bluetooth...
dnf install -y broadcom-wl

echo Suporte a SNAP...
dnf install -y snapd; ln -s /var/lib/snapd/snap /snap
# reboot now

echo Suporte a DVD...
dnf install -y libdvdcss

echo Instalando Gnome Tweaks...
dnf install -y gnome-tweak-tool gnome-extensions-app

echo Instalando Docker...
dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
systemctl enable --now docker
groupadd docker
usermod -aG docker $USER
newgrp docker


echo Instalando Google Chrome...
# dnf install wget -y
dnf install fedora-workstation-repositories
dnf config-manager setopt google-chrome.enabled=1
dnf install -y google-chrome-stable

echo Instalando Codecs de Mídia...
dnf config-manager setopt fedora-cisco-openh264.enabled=1
dnf install -y gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav mozilla-openh264 --exclude=gstreamer1-plugins-bad-free-devel
dnf install -y lame --exclude=lame-devel
# erro nessa linha dnf group upgrade --with-optional --allowerasing Multimedia -y

echo Instalando vlc...
dnf install -y vlc
dnf group install -y sound-and-video

echo Porcentagem de bateria de notebook
#gsettings set org.gnome.desktop.interface show-battery-percentage true

echo Compressores de arquivo...
dnf install -y p7zip p7zip-plugins unrar unzip gzip

echo Instalando Brave Browser...
dnf install dnf-plugins-core -y
dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
dnf install brave-browser -y

echo Instalando Code...
rpm --import https://packages.microsoft.com/keys/microsoft.asc
echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\nautorefresh=1\ntype=rpm-md\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" | sudo tee /etc/yum.repos.d/vscode.repo > /dev/null
dnf check-update
dnf install -y code

echo Abrir com code...
# Fechar code e nautilus antes
wget -qO- https://raw.githubusercontent.com/harry-cpp/code-nautilus/master/install.sh | bash

echo Instalando qbittorrent...
dnf install qbittorrent -y

echo Instalando Java...
dnf install -y java-21-openjdk

echo Habilitando flathub...
flatpak remote-modify --enable flathub
org.gimp.GIMP
echo Pacotes github
flatpak install -y flathub io.github.shiftey.Desktop
flatpak install -y flathub org.gnome.Extensions
flatpak install -y flathub com.spotify.Client
flatpak install -y flathub com.discordapp.Discord
flatpak install -y flathub com.rtosta.zapzap
flatpak install -y flathub org.telegram.desktop
flatpak install -y flathub io.gitlab.elescoute.password
flatpak install -y flathub org.keepassxc.KeePassXC
flatpak install -y flathub com.anydesk.Anydesk
flatpak install -y flathub com.rustdesk.RustDesk
flatpak install -y flathub org.libreoffice.LibreOffice
flatpak install -y flathub org.deluge_torrent.deluge
flatpak install -y flathub io.dbeaver.DBeaverCommunity
flatpak install -y flathub com.stremio.Stremio
flatpak install -y flathub org.sqlitebrowser.sqlitebrowser
flatpak install -y flathub com.vixalien.sticky
flatpak install -y flathub com.github.micahflee.torbrowser-launcher
flatpak install -y flathub net.fasterland.converseen
# flatpak install -y flathub org.cubocore.CoreRenamer // Erros com atualizações
flatpak install -y flathub org.gnome.SimpleScan
flatpak install -y flathub org.gimp.GIMP

echo Instalando Build Essentials...
dnf group install -y c-development development-tools

echo Instalando extensão GSCONNECT
dnf install -y gnome-shell-extension-gsconnect
# Depois em extenções instalar a extensão gsconnect e
# Instalar o KDE Connect no celular

#echo Instalando o Ollama (IA)
#curl -fsSL https://ollama.com/install.sh | sh
#ollama run deepseeker-coder
#ollama run deepseeker-coder-v2

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

echo Instalando Onedrive (onedrive-cli)
dnf copr enable jstaf/onedriver -y
dnf install -y onedriver

echo Instalando Nextcloud
dnf install -y nextcloud-client

echo Instalando Etcher
wget https://github.com/balena-io/etcher/releases/download/v2.1.0/balena-etcher-2.1.0-1.x86_64.rpm
dnf install -y balena-etcher-*

echo Outros Programas
dnf install -y thunderbird filezilla htop libreoffice calibre fastfetch cmatrix gnome-password-generator

echo Instalando drivers AMD
dnf install -y clinfo inxi
lspci -nn | grep -i "Radeon"
# Site Radeon baixar amdgpu RHEL
dnf install -y ./amdgpu-install-6.3.60304-1.el9.noarch.rpm
$ amdgpu-install 
$ cd /etc/yum.repos.d/
# substituir $amdgpudistro por 9.5
$ sudo nano amdgpu-proprietary.repo
$ sudo nano amdgpu.repo

# Alternativa
$ sudo dnf install -y \
mesa-vulkan-drivers \
mesa-vulkan-drivers.i686 \
mesa-libGL \
mesa-libGL.i686 \
mesa-libEGL \
mesa-libEGL.i686 \
xorg-x11-drv-amdgpu
$ sudo dnf install -y vulkan-tools
$ cd ~/Downloads/DaVinci_Resolve_19.1.3_Linux
$ sudo SKIP_PACKAGE_CHECK=1 ./DaVinci_Resolve_19.1.3_Linux.run
Remover Old libraries:
$ cd /opt/resolve/libs/
$ sudo mkdir disabled-libraries
$ sudo mv libglib* disabled-libraries/
$ sudo mv libgio* disabled-libraries/
$ sudo mv libgmodule* disabled-libraries/
$ cd /opt/resolve/bin
$ ./resolve
# se der erro a respeito da libcrypt:
$ sudo dnf install -y libxcrypt-compat

######################################
# Apps Loja Flathub
######################################
# + GitHub Desktop
# + Gerenciador Extensões 
# + spotify
# + discord
# + ZapZap (whatsapp)
# + Telegram 
# + KeepassXC
# + Anydesk 
# + Rustdesk 
# + LibreOffice
# + Plex
# PDF Editor/Merge


