#!/bin/sh

func=/sys/kernel/config/pci_ep/functions/pci_epf_test/func1
ctrl=/sys/kernel/config/pci_ep/controllers/0000:00:04.0/

mkdir ${func}
echo 0x104c > ${func}/vendorid
echo 0xb500 > ${func}/deviceid
ln -s ${func} ${ctrl}
echo 1 > ${ctrl}/start
