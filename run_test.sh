#!/bin/bash

set -eu
set -x

extract_msgid() {
  url=$1
  awk -F'/' '{print $5}' <<< ${url}
}

patch_url=$1
msgid=`extract_msgid $patch_url`
outdir="results/${msgid}"

build_kernel() {
  ./autopatch.sh linux $1
}

check_result() {
  if [ ! -e tests/rc/result.txt ]; then
    exit 1
  fi

  test $(cat tests/rc/result.txt) -eq 0
}

launch_test() {
  epc_sock=/tmp/qemu-epc.sock

  # launch qemu for pcie endpoint. (device side)
  ./launch_qemu.sh 1 ${outdir}/qemu.ep.log > ${outdir}/kernel.ep.log &
  pid=$!

  # wait for creating socket that is used to communicate between 2 qemus.
  cnt=0
  while ! [ -S ${epc_sock} ];
  do
    sleep 1
    cnt=$(($cnt + 1))
    if [ ${cnt} -eq 10 ]; then
      set +e
      kill ${pid}
      set -e
      exit 1
    fi
  done

  # launch qemu for pcie root complex (host side)
  ./launch_qemu.sh 0 ${outdir}/qemu.rc.log | tee ${outdir}/kernel.rc.log 

  set +e
  kill ${pid}
  rm ${epc_sock}
  set -e

  check_result
}


mkdir -p ${outdir}
echo $patch_url > ${outdir}/lore.url.txt
build_kernel ${msgid}
launch_test
