#!/bin/bash

echo -e "\n**** Generating an OpenSSH public & private key pair inside of Vagrant VM for use by Git/SSH/SCP/etc ****\n"

if ! [[ -d ~/.ssh ]]; then
    mkdir ~/.ssh
    echo -e "\n\n\n" | ssh-keygen -t rsa
fi


echo -e "\n**** Done downlading GCC ARM Embedded Toolkit ****\n"

echo -e "\n**** Grabbing Eclipse 4.5 Mars with CDT built in ****\n"
curl -sLo ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz http://ftp.heanet.ie/pub/eclipse//technology/epp/downloads/release/mars/2/eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz >/dev/null

if [[ -f ~/eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz ]]; then
    echo -e "\n******  eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz has been downloaded  ******\n"
fi

tar xzf ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz -C ~/
rm ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz


echo -e "\n**** Adjusting Bash PATH Environment Variable to include Eclipse tooling ****\n"
cat >> ~/.bashrc <<'EOL'
export PATH=$PATH:"$OPENOCD_PATH"

alias ll='ls -la'

if [[ -d ~/eclipse ]]; then
    export PATH=$PATH:$HOME/eclipse
fi

EOL

source ~/.bashrc

echo -e "\n**** Installing GNU Eclipse ARM Plugin ****\n"
~/eclipse/eclipse -nosplash -followReferences \
    -application org.eclipse.equinox.p2.director \
    -repository http://gnuarmeclipse.sourceforge.net/updates/ \
    -repository http://download.eclipse.org/releases/mars \
    -destination /home/vagrant/eclipse \
    -installIUs ilg.gnuarmeclipse.codered.feature.group,ilg.gnuarmeclipse.managedbuild.cross.feature.group,ilg.gnuarmeclipse.doc.user.feature.group,ilg.gnuarmeclipse.templates.cortexm.feature.group,ilg.gnuarmeclipse.debug.gdbjtag.jlink.feature.group,ilg.gnuarmeclipse.debug.gdbjtag.openocd.feature.group,ilg.gnuarmeclipse.packs.feature.group,ilg.gnuarmeclipse.templates.stm.feature.group


echo -e "\n**** Installing ST Link command line Tools ****\n"
git clone https://github.com/texane/stlink.git ~/stlink
cd ~/stlink
./autogen.sh
./configure
make
sudo make install
rm -rf ~/stlink

touch "/home/vagrant/Desktop/Eclipse 4_4.desktop"
cat <<EOL >> "/home/vagrant/Desktop/Eclipse 4_4.desktop"
[Desktop Entry]
Version=1.0
Type=Application
Name=Eclipse 4.4
Comment=Integrated Development Environment
Exec=/home/vagrant/eclipse/eclipse
Icon=/home/vagrant/eclipse/icon.xpm
Path=
Terminal=false
StartupNotify=false
EOL


echo -e "\n**** \n**** Installation is done!!\n**** \n"

