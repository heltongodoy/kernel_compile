#!/bin/bash

apt-get build-dep linux linux-image-$(uname -r)
apt install build-essential bc kmod cpio flex liblz4-tool lz4 libncurses-dev libelf-dev libssl-dev qtbase5-dev

