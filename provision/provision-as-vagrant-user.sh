#!/bin/bash

echo -e "\n**** Generating an OpenSSH public & private key pair inside of Vagrant VM for use by Git/SSH/SCP/etc ****\n"

if ! [[ -d ~/.ssh ]]; then
    mkdir ~/.ssh
    echo -e "\n\n\n" | ssh-keygen -t rsa
fi


echo -e "\n**** Grabbing the GCC ARM Embedded Toolkit for GCC 5.2 ****\n"
curl -sLo ~/gcc-arm-none-eabi-5_2-2015q4.tar.bz2 https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2 >/dev/null

if [[ -f ~/gcc-arm-none-eabi-5_2-2015q4.tar.bz2 ]]; then
    echo -e "\n******  gcc-arm-none-eabi-4_9-2015q2-20150609-linux.tar.bz2 has been downloaded  ******\n"
fi

tar xjf ~/gcc-arm-none-eabi-5_2-2015q4.tar.bz2 -C ~/
rm ~/gcc-arm-none-eabi-5_2-2015q4.tar.bz2

echo -e "\n**** Grabbing Eclipse 4.5 Mars with CDT built in ****\n"
curl -sLo ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz http://ftp.heanet.ie/pub/eclipse//technology/epp/downloads/release/mars/2/eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz >/dev/null

if [[ -f ~/eclipse-cpp-mars-2-linux-gtk-x86_64.tar.gz ]]; then
    echo -e "\n******  eclipse-cpp-luna-SR2-linux-gtk-x86_64.tar.gz has been downloaded  ******\n"
fi

tar xzf ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz -C ~/
rm ~/eclipse-cpp-luna-linux-gtk-x86_64.tar.gz

# Install OpenOCD from GNU ARM Eclipse project
echo -e "\n**** Installing OpenOCD 0.10.0 from built tar ****\n"
curl -sLo ~/openocd-0.10.0.tar.gz 'https://github.com/gnuarmeclipse/openocd/releases/download/gae-0.10.0-20160110/gnuarmeclipse-openocd-debian64-0.10.0-201601101000-dev.tgz' > /dev/null

if [[ -f ~/openocd-0.10.0.tar.gz ]]; then
    echo -e "\n******  openocd-0.9.0.tar.gz has been downloaded  ******\n"
fi

tar xzf ~/openocd-0.10.0.tar.gz
rm openocd-0.10.0.tar.gz

echo -e "\n**** Adjusting Bash PATH Environment Variable to include newly installed tooling ****\n"
cat >> ~/.bashrc <<'EOL'

OPENOCD_PATH=$(find ~/openocd/0.10.0-*/bin -print | head -n 1)
ARM_TOOLS_PATH=$(find ~/gcc-arm-none-eabi-*/bin -print | head -n 1)

export PATH=$PATH:"$ARM_TOOLS_PATH"
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

mkdir ~/Desktop
touch ~/Desktop/Eclipse\ 4_5.desktop
cat <<EOL >> ~/Desktop/Eclipse\ 4_5.desktop
[Desktop Entry]
Version=1.0
Type=Application
Name=Eclipse 4.5
Comment=Integrated Development Environment
Exec=/home/vagrant/eclipse/eclipse
Icon=/home/vagrant/eclipse/icon.xpm
Path=
Terminal=false
StartupNotify=false
EOL


echo -e "\n**** \n**** Installation is done!!\n**** \n"

