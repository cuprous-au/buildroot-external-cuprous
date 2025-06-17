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

* clone the main [buildroot](https://github.com/buildroot/buildroot.git) and checkout the tag for `2025.05`
* `cd` into the buildroot repo and then: `make BR2_EXTERNAL=../buildroot-external-cuprous menuconfig`
* exit and save the menuconfig then, for example, `make raspberrypi5_cuprous_gw_defconfig` to create a default configuration for the board (`make list-defconfigs` can also be used to display the available configurations)
* finally, build: `make -j$(nproc)`
