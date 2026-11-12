buildroot-external-cuprous
===

This repo contains buildroot configuration for Cuprous boards built with buildroot. It is intended to be used as an external
repo alongside others, including Microchip's.

Building for the microchip gateway
---

To get started with support alongside Microchip:

* follow the instructions to setup buildroot and the `buildroot-external-microchip` repo at https://github.com/linux4sam/buildroot-external-microchip
* check out this repo, `cd` into the buildroot repo and then: `make BR2_EXTERNAL=../buildroot-external-microchip:../buildroot-external-cuprous menuconfig`
* exit and save the menuconfig then, for example, `make microchip_sama5d27_wlsom1_cuprous_gw_defconfig` to create a default configuration for the board (`make list-defconfigs` can also be used to display the available configurations)
* finally, build: `make -j$(nproc)`

Building for the Raspberrypi 5 gateway
---

* clone the main [buildroot](https://github.com/buildroot/buildroot.git) and checkout the tag for `2026.08.1`
* `cd` into the buildroot repo and then: `make BR2_EXTERNAL=../buildroot-external-cuprous menuconfig`
* exit and save the menuconfig then, for example, `make raspberrypi5_cuprous_gw_defconfig` to create a default configuration for the board (`make list-defconfigs` can also be used to display the available configurations)
* finally, build: `make -j$(nproc)`

Upgrading buildroot
---

When upgrading buildroot make sure you check out a stable tag e.g. `2026.08.1` and then update the linux kernel
source in the defconfig file(s) to correlate with any corresponding one in the mainline buildroot branch (origin).
Then do a local clean (`make distclean`) and reapply the defconfig.
