#!/bin/bash
# Primeiramente baixe o novo kernel em https://www.kernel.org/
# descompacte em /usr/src 
# crie um link simbolico: ln -s linux-xxxx linux

# APLICACAO DE PATCH ANTES DA COMPILACAO
tar -xvf kernel_gcc_patch.tar.gz -C /usr/src
cd /usr/src/linux
patch -p1 < ../kernel_gcc_patch/enable_additional_cpu_optimizations_for_gcc_v10.1+_kernel_v4.19-v5.4.patch

# INSTALA DEPENDENCIAS
apt-get build-dep linux linux-image-$(uname -r)
apt install build-essential bc kmod cpio flex liblz4-tool lz4 libncurses-dev libelf-dev libssl-dev qtbase5-dev dkms git gawk bison openssl libudev-dev libpci-dev libiberty-dev autoconf pkg-config
apt-get --no-install-recommends install kernel-package

# CORRIGIR PROBLEMAS DO KERNEL-PACKAGE
mkdir Documentation/lguest
echo all: >> Documentation/lguest/Makefile
sed -i '/maintainer/d' /etc/kernel-pkg.conf
sed -i '/email/d' /etc/kernel-pkg.conf
echo "maintainer := heltongodoy" >> /etc/kernel-pkg.conf
echo "email := heltongodoy@email.com" >> /etc/kernel-pkg.conf

# COPIANDO CONFIGURACOES DO KERNEL ATUAL PARA O NOVO 
cp /boot/config-$(uname -r) .config

# ULTIMOS AJUSTES DE COMPILAR, ESCOLHA O MODELO DO PROCESSADOR

echo "ULTIMOS AJUSTES DE COMPILAR, ESCOLHA O MODELO DO PROCESSADOR"
make oldconfig

# INICIANDO A COMPILACAO
INSTALL_MOD_STRIP=1 CONCURRENCY_LEVEL=5 fakeroot make-kpkg --initrd --append-to-version=-heltongodoy --revision=1.0 kernel_image kernel_headers
