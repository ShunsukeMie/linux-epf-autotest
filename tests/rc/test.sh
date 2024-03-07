#!/bin/sh

cd $(dirname $0) && ./pcitest -r
cd $(dirname $0) && ./pcitest -w
cd $(dirname $0) && ./pcitest -c
