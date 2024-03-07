#!/bin/bash

set -eu
set -x

is_ep=$1
log=$2

qemu=./qemu/build/qemu-system-x86_64

run() {
        ${qemu} \
                -m 2g \
                -kernel ./linux/arch/x86_64/boot/bzImage \
                -append 'console=ttyS0 root=/dev/sda ro init=/init panic=-1' \
                -nographic \
                -no-reboot \
                $@
}

mkdir -p tmp
if [ ${is_ep} -eq 1 ]; then
        rm -f /tmp/qemu-epc.sock*
        run \
                -device qemu-epc \
                -D $log \
                -drive file=./rootfs.img \
                -device nvme,drive=nvme0,serial=1234 \
                -drive if=none,id=nvme0,file=fat:rw:tests/ep,format=raw
else
        run \
                -device epf-bridge \
                -D $log \
                -drive file=./rootfs.rc.img \
                -device nvme,drive=nvme0,serial=1234 \
                -drive if=none,id=nvme0,file=fat:rw:tests/rc,format=raw
fi
