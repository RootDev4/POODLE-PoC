#!/bin/bash

# Recompile current OpenSSL version with SSLv3.0 support.
# @author: RootDev4 (c) 09/2020
# @url: https://github.com/RootDev4/poodle-PoC

echo "[>] Installing prerequisites"
apt-get install make libtext-template-perl xutils-dev gcc build-essential checkinstall -y > /dev/null
cd /usr/local/src
openssl_version=($(openssl version))
echo "[>] Current OpenSSL version is ${openssl_version[1]}"

echo "[>] Downloading source code of OpenSSL v${openssl_version[1]}"
wget https://www.openssl.org/source/openssl-${openssl_version[1]}.tar.gz > /dev/null 2>&1
tar -xf openssl-${openssl_version[1]}.tar.gz
cd openssl-${openssl_version[1]}/
chmod +x config

echo "[>] Configure source code with SSLv3.0 support"
./config --prefix=/usr/local/ssl --openssldir=/usr/local/ssl shared enable-ssl3 enable-ssl3-method > /dev/null 2>&1

echo "[>] Start compiling. This may take a while..."
make > /dev/null 2>&1
make install > /dev/null 2>&1

echo "[>] Compiling finished. Creating necessary files and symlinks"
cd /etc/ld.so.conf.d/
touch openssl-${openssl_version[1]}.conf
echo "/usr/local/ssl/lib" > openssl-${openssl_version[1]}.conf
sudo ldconfig -v > /dev/null
echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/local/ssl/bin\"" > /etc/environment
echo "[>] Done! ${openssl_version}"  
