#!/bin/bash

set -eu
set -x

linux=$1
msgid=$2

outdir="results/${msgid}"

b4 am ${msgid} -o ${outdir} 2> ${outdir}/b4_am.log 

apply_patches(){
  for patch in $@;
  do
    git am < ${patch}
  done
}

cd ${linux}
git stash -u                  
git checkout remotes/pci/main
apply_patches \
  ../patches/0001-PCI-qemu-Add-QEMU-PCIe-endpoint-controller-driver.patch \
  ../patches/0001-tools-PCI-makes-a-pcitest-binary-static.patch \
  ../patches/0001-hack-misc-pci_endpoint_test-XXX-Don-t-merge-this-com.patch \
  > ../${outdir}/pre_patches_apply.log
git am ../${outdir}/*.mbx > ../${outdir}/patch_apply.log
yes "" | make -j 32 >  ../${outdir}/build.log
