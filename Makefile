
defconfig:
	make -C busybox defconfig

build:
	make -C busybox install -j 16

rootfs.img:
	dd if=/dev/zero of=rootfs.img bs=1024 count=$(shell echo "64 * 1024" | bc -l)
	mkfs.ext4 rootfs.img
	mkdir -p mnt
	sudo mount rootfs.img ./mnt
	sudo cp -r busybox/_install/* mnt
	sudo umount ./mnt

qemu-system-x86_64:
	cd qemu && ./configure --target-list=x86_64-softmmu
	cd qemu && git am < ../patches/0001-hw-misc-add-qemu-pci-endpoint-controller-device.patch
	cd qemu && git am < ../patches/0002-hw-misc-Introduce-a-epf-bridge-device.patch
	make -C qemu -j 32

clean:
	$(RM) rootfs.img mnt
