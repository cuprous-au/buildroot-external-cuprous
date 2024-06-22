buildroot-external-cuprous
===

This repo contains buildroot configuration for Cuprous boards built with buildroot. It is intended to be used as an external
repo alongside others, including Microchip's.

To get started with support alongside Microchip:

* follow the instructions to setup buildroot and the `buildroot-external-microchip` repo at https://github.com/linux4sam/buildroot-external-microchip
* check out this repo, `cd` into the buildroot repo and then: `make BR2_EXTERNAL=../buildroot-external-microchip:../buildroot-external-cuprous menuconfig`
* exit and save the menuconfig then, for example, `make microchip_sama5d27_wlsom1_cuprous_gw_defconfig` to create a default configuration for a board (`make list-defconfigs` can also be used to display the available configurations)
* finally, build: `make -j$(nproc)`
