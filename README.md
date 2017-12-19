## TWRP device tree for LG G4 (any model) including decryption support*

Decryption is supported for AOSP/CM based ROMS only (so no STOCK).

This tree is a unified version which can create a build for ANY LG G4 device (even locked ones).
The detection happens automatically when TWRP boots up.

This version is made and prepared to be used in android FIsH ( https://bit.do/FISHatXDA )

Prepare the sources from here: https://github.com/omnirom/android/tree/android-5.1

Add to `.repo/local_manifests/remove.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remove-project name="android_hardware_libhardware" />
</manifest>
```

Then run `repo sync -c --force-sync` to check it out.

To build:

```sh
source build/envsetup.sh
lunch omni_g4-eng
mka recoveryimage
```
(the lunch command will download additional ressources)


### TWRP in FIsH

All details about how to cook the FIsH and complete the whole image is described here:

https://bit.do/FISHatXDA 


### TWRP included kernel

Add  to `.repo/local_manifests/g4_kernel.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote  name="bitbucket"
           fetch="https://bitbucket.org/" />
           
  <project name="steadfasterX/android_buildtools" path="vendor/sedi/prebuilt/bin" remote="github" revision="master" />
  <project name="steadfasterX/kernel_lge_llamasweet" path="kernel/lge/llama" remote="github" revision="cm-13.0" />
  <project name="UBERTC/aarch64-linux-android-4.9-kernel" path="prebuilts/gcc/linux-x86/aarch64-linux-android-4.9-kernel" remote="bitbucket" revision="master" />
  <project name="xiaolu/mkbootimg_tools" path="prebuilts/devtools/mkbootimg_tools" remote="github" revision="master" />
</manifest>
```
Then run `repo sync` to check it out.

To build the kernel run (all in 1 line):

`BUILDID=lge/g4 KCONF=cyanogenmod_h815_defconfig UARCH=x64 KDIR=kernel/lge/llama vendor/sedi/prebuilt/bin/build_sediROM.sh kernelonly`


