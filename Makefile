
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
	sudo cp init mnt
	sudo mkdir -p mnt/dev mnt/sys mnt/sys/kernel/config mnt/proc mnt/tests
	sudo umount -d ./mnt
	cp rootfs.img rootfs.rc.img

pcitest:
	make -C linux/tools/pci
	cp linux/tools/pci/pcitest ./tests/rc

qemu-system-x86_64:
	cd qemu && ./configure --target-list=x86_64-softmmu
	cd qemu && git am < ../patches/0001-hw-misc-add-qemu-pci-endpoint-controller-device.patch
	cd qemu && git am < ../patches/0002-hw-misc-Introduce-a-epf-bridge-device.patch
	make -C qemu -j 32

umount:
	sudo umount -d ./mnt

.PHONY: linux
linux:
	./autopatch.sh \
		linux \
		patches/0001-PCI-qemu-Add-QEMU-PCIe-endpoint-controller-driver.patch \
		"https://lore.kernel.org/linux-pci/ZeBU23Ccvv8WqFx_@fedora/T/#t"

clean:
	sudo $(RM) rootfs.img rootfs.rc.img
	sudo $(RM) -r mnt results tmp
