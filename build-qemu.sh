#!/bin/sh

# SPDX-License-Identifier: Apache-2.0
# Copyright (C) 2025, Advanced Micro Devices, Inc.
#

# Apply patches in patches/qemu/ to the qemu source tree before compilation

source_path=$(cd "$(dirname -- "$0")"; pwd)
qemu_dir="$source_path/qemu"

export CFLAGS="-I/opt/xilinx/xrt/include"
export LDFLAGS="-L/opt/xilinx/xrt/lib"
export PKG_CONFIG_PATH="/opt/xilinx/xrt/lib/pkgconfig:$PKG_CONFIG_PATH"
cd $qemu_dir
./configure --enable-drm-accel --enable-kvm --target-list=x86_64-softmmu
make -j$(nproc)
