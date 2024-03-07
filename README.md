Autotest tools(scripts) for Linux PCI Endpoint Framework
---

### How to use
```
./run_test.sh "https://lore.kernel.org/linux-pci/ZeBU23Ccvv8WqFx_@fedora/T/#t"
```

### file and directries
```
.
├── autopatch.sh
├── busybox # For rootfs
├── init # A shell script that run as init process.
├── launch_qemu.sh # A shell script that launchs qemu.
├── linux # Linux kernel
├── main.py # obtain rss feed from lore and extract patches to test
├── Makefile
├── patches # Patches to apply qemu and linux and are not upstreamd yet.
├── qemu # QEMU
├── README.md # This file.
├── run_test.sh
└── tests

5 directories, 7 files
```

### Memo

- busybox<br>
enable `Build static binary`

- linux<br>
enable `PCI_EPF`, `PCI_EPF_CONFIGFS`, `PCI_EPF_TEST`, `PCI_ENDPOINT_TEST`, `QEMU_EPC`
