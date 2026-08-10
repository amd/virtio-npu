# virtio-npu

## Build instructions
- Follow README from https://github.com/amd/xdna-driver/tree/main to build xdna staging driver, shim and vxdna libraries and install:
  - shim library: `libxrt_driver_xdna.so`
  - vxdna library: `libvxdna.so`
- Commpile QEMU with virtio npu backend patches:
  - Get upstream QEMU source code from https://gitlab.com/qemu-project/qemu.git
  - apply the patches in `patches/qemu/` to the QEMU source code
  - compile qemu, reference build script: `build-qemu.sh`

## Start VM with NPU
- you will need to have Linux kernel and rootfs images for VM
- launch VM with QEMU:
  - specify npu device: `-device virtio-accel-pci,accel-node=accel0`
  - make usre to use shared memory backend:
    ```
     -object memory-backend-memfd,id=mem0,size=16G,share=on \
     -machine q35,memory-backend=mem0,accel=kvm
    ```
    here is an example:
    ```
qemu-system-x86_64 \
-machine q35,accel=kvm \
-object memory-backend-memfd,id=mem0,size=16G,share=on \
-machine q35,memory-backend=mem0,accel=kvm \
-enable-kvm \
-kernel /boot/vmlinuz-$(uname -r) \
-initrd /boot/initrd.img-$(uname -r) \
-append "root=/dev/vda rootfstype=ext4 console=ttyS0 rw rootwait noresume" \
-drive file=ubuntu-24.04.img,format=raw,if=virtio,id=hd0 \
-device virtio-accel-pci,accel-node=accel0 \
-nographic \
-display none \
-d guest_errors \
-D qemu-boot.log \
-trace "virtio_accel*" \
-trace "virtio_gpu_*"
    ```

## Test
run `xrt-smi` on VM
```
xrt-smi examine
xrt-smi validate
```
