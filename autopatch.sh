#!/bin/bash

set -eu
set -x

linux=$1
qpatch=$2
patchurl=$3

extract_msgid() {
  url=$1
  awk -F'/' '{print $5}' <<< ${url}
}

msgid=`extract_msgid $patchurl`
echo ${msgid}

cd ${linux} && git stash -u
cd ${linux} && git checkout remotes/pci/main
cd ${linux} && git am < ${qpatch}
cd ${linux} && b4 am ${msgid} -o - | git am
cd ${linux} && yes "" | make -j 32
