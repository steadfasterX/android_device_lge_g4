## TWRP device tree for LG G4 (H815 - international) including decryption support 

The whole tree is expecting omnirom 6.0 sources and is a mix of TeamWin (base tree) + jcadduono (extended tree) + steadfasterX (even more extended - omnirom 6.0 compatible, optimized kernel, and fully working decryption).
Prepare the sources from here: https://github.com/omnirom/android/tree/android-6.0

Add to `.repo/local_manifests/h815.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="android_device_qcom_sepolicy" path="device/qcom/sepolicy" remote="omnirom" revision="android-6.0" />
  <project name="CyanogenMod/android_device_qcom_common" path="device/qcom/common" remote="github" revision="cm-13.0" />
</manifest>
```

Then run `repo sync` to check it out.

To build:

```sh
source build/envsetup.sh
lunch omni_h815-eng
mka recoveryimage
```
(the lunch command may install additional ressources)

### TWRP included kernel

Add  to `.repo/local_manifests/h815_kernel.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <remote  name="bitbucket"
           fetch="https://bitbucket.org/" />
           
  <project name="steadfasterX/android_buildtools" path="vendor/sedi/prebuilt/bin" remote="github" revision="master" />
  <project name="genesixx/LlamaSweet-msm8992" path="kernel/lge/msm8992" remote="github" revision="cm-13.0" />
  <project name="UBERTC/aarch64-linux-android-4.9-kernel" path="prebuilts/gcc/linux-x86/aarch64-linux-android-4.9-kernel" remote="bitbucket" revision="master" />
  <project name="xiaolu/mkbootimg_tools" path="prebuilts/devtools/mkbootimg_tools" remote="github" revision="master" />
</manifest>
```
Then run `repo sync` to check it out.

To build the kernel run (all 1 line):

`BUILDID=lge/h815 KCONF=cyanogenmod_h815_defconfig UARCH=x64 KDIR=kernel/lge/msm8992 vendor/sedi/prebuilt/bin/build_sediROM.sh kernelonly`


