## TWRP for LG G4 (ANY model)

**Decryption** and working **time** requires an *Android version specific* branch of this device tree:

* **Pie** CM/LOS/AOSP based ROMs -> branch: **android-9.0**
* **Oreo** CM/LOS/AOSP based ROMs -> branch: **android-8.1**
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

Android branch to use: https://github.com/omnirom/android/tree/android-8.1

### TWRP kernel

Create `.repo/local_manifests/g4_kernel.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
  <project name="Suicide-Squirrel/Titan-Kernel-LG-G4" path="kernel/lge/g4" remote="github" revision="refs/heads/android-8.1" />
</manifest>
```
Then run `repo sync -jX kernel/lge/g4` to check it out.

The kernel will be build automatically together with TWRP.

### Build

```sh
source build/envsetup.sh
launch omni_g4-eng
mka recoveryimage
```
(the launch command may install additional ressources)


