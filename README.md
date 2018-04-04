## TWRP for LG G4 (ANY model)

**Decryption** and working **time** requires an *Android version specific* branch of this device tree:

* **Oreo** CM/LOS/AOSP based ROMs -> branch: **android-8.0**
* **Nougat** CM/LOS/AOSP based ROMs -> branch: **android-7.1**
* **Nougat** STOCK based ROMs -> branch: **android-7.1**
* **Marshmallow** CM/LOS/AOSP based ROMs -> branch: **android-6.0**

This repo and all(!) its branches will build TWRP *unified* which means TWRP will work for **all** known LG G4 models!
The detection happens **automatically** when TWRP boots up.

Supported devices by this repo:

### Official unlocked
* H811
* H815 EUR

### UsU'd
_UsU'd_ means: unlocked by [UsU](https://bit.do/unlockg4)

* LS991
* F500
* H810
* H811
* H812
* H815 - any non EUR
* H815 EUR
* H819
* US991
* VS986

## Build instructions (on this branch)

### Prepare

Prepare the android sources like written in the [official TWRP guide](http://forum.xda-developers.com/showthread.php?t=1943625)

Android branch to use: https://github.com/omnirom/android/tree/android-6.0

Create `.repo/local_manifests/g4.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="android_device_qcom_sepolicy" path="device/qcom/sepolicy" remote="omnirom" revision="android-6.0" />
  <project name="CyanogenMod/android_device_qcom_common" path="device/qcom/common" remote="github" revision="cm-13.0" />
</manifest>
```

Run `repo sync -jX` to check it out.

### Build

If you want to include/build a new kernel (optional) skip to the next topic. 
If you want to use the included kernel in this device tree proceed.

```sh
source build/envsetup.sh
lunch omni_g4-eng
mka recoveryimage
```
(the lunch command may install additional ressources)

### TWRP kernel (optional)

Create `.repo/local_manifests/g4_kernel.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote  name="bitbucket"
           fetch="https://bitbucket.org/" />
           
  <project name="Suicide-Squirrel/Titan-Kernel-LG-G4" path="kernel/lge/titan" remote="github" revision="refs/heads/aosp" />         
  <project name="steadfasterX/android_buildtools" path="vendor/sedi/prebuilt/bin" remote="github" revision="master" />
  <project name="steadfasterX/kernel_lge_llamasweet" path="kernel/lge/llama" remote="github" revision="cm-13.0" />
  <project name="matthewdalex/aarch64-linux-android-4.9" path="prebuilts/gcc/linux-x86/aarch64-linux-android-4.9-kernel" remote="bitbucket" revision="master" />
  <project name="xiaolu/mkbootimg_tools" path="prebuilts/devtools/mkbootimg_tools" remote="github" revision="master" />
</manifest>
```
Then run `repo sync` to check it out.

To build the kernel run (all in 1 line):

`MAXCPU=13 JAVACBIN=undef NEEDEDJAVA=undef CONFIG_NO_ERROR_ON_MISMATCH=y BUILDID=lge/g4 KCONF=twrp_g4_defconfig UARCH=x64 KDIR=kernel/lge/titan vendor/sedi/prebuilt/bin/universalbuilder.sh kernelonly`

adjust MAXCPU to the amount of cores to use for building

The kernel and DTB will be generated and placed in device/lge/g4 with the extension "*new*" so move them accordingly:
```sh
mv device/lge/g4/Image.new device/lge/g4/Image
mv device/lge/g4/dt.img-new device/lge/g4/dt.img
```
Then follow the *Build* topic above to include that new kernel in TWRP.
