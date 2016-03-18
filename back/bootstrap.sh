mkdir downloads

apt-get update
apt-get install -y build-essential git vim
apt-get install -y usbutils

#ARM toolchains
#dependecies
apt-get -y install lib32z1 lib32ncurses5 lib32bz2-1.0
apt-get -y install lib32ncurses5

#download latest toolchain and add to PATH
wget -q -P downloads https://launchpad.net/gcc-arm-embedded/5.0/5-2015-q4-major/+download/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2
tar -xjf downloads/gcc-arm-none-eabi-5_2-2015q4-20151219-linux.tar.bz2
mv gcc-arm-none-eabi-5_2-2015q4 /opt/
ln -s /opt/gcc-arm-none-eabi-5_2-2015q4/ /opt/gcc-arm-none-eabi
echo "export PATH=$PATH:/opt/gcc-arm-none-eabi/bin" >> /home/vagrant/.bashrc

#Download GNU ARM Eclipse OpenOCD 
wget -q -P downloads https://github.com/gnuarmeclipse/openocd/releases/download/gae-0.10.0-20160110/gnuarmeclipse-openocd-debian64-0.10.0-201601101000-dev.tgz
tar -xvf downloads/gnuarmeclipse-openocd-debian64-0.10.0-201601101000-dev.tgz
mkdir /opt/gnuarmeclipse
mv openocd /opt/gnuarmeclipse
usermod -a -G plugdev vagrant
cp /opt/gnuarmeclipse/openocd/0.10.0-201601101000-dev/contrib/99-openocd.rules /etc/udev/rules.d/
udevadm control --reload-rules

