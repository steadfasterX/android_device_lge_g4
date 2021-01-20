# BOOTLOADER
TARGET_BOOTLOADER_BOARD_NAME := MSM8992
TARGET_NO_BOOTLOADER := true

# PLATFORM
TARGET_BOARD_PLATFORM := msm8992
TARGET_BOARD_PLATFORM_GPU := qcom-adreno418
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# ARCHITECTURE
TARGET_IS_64_BIT := true
TARGET_SUPPORTS_32_BIT_APPS := true
TARGET_SUPPORTS_64_BIT_APPS := true

TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53.a57

# BOOT IMAGE
BOARD_KERNEL_CMDLINE := maxcpus console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 msm_rtb.filter=0x37 androidboot.hardware=p1 androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x0000000 --ramdisk_offset 0x02200000 --tags_offset 0x00000100

# Kernel build
BOARD_KERNEL_SEPARATED_DT := true
TARGET_CUSTOM_DTBTOOL := dtbTool_lgg4
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_KERNEL_ARCH := arm64
TARGET_KERNEL_HEADER_ARCH := arm64
TARGET_KERNEL_SOURCE := kernel/lge/g4
TARGET_KERNEL_CROSS_COMPILE_PREFIX := aarch64-linux-android-
TARGET_KERNEL_CONFIG := twrp_g4_defconfig

# EMMC / PARTITIONS
BOARD_BOOTIMAGE_PARTITION_SIZE     := 0x002800000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x002800000
BOARD_SYSTEMIMAGE_PARTITION_SIZE   := 0x040000000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0x080000000
BOARD_FLASH_BLOCK_SIZE := 131072 # (BOARD_KERNEL_PAGESIZE * 64)
BOARD_VOLD_EMMC_SHARES_DEV_MAJOR := true
BOARD_SUPPRESS_SECURE_ERASE := true

TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# MISC FLAGS
BOARD_HAS_NO_SELECT_BUTTON := true
RECOVERY_SDCARD_ON_DATA := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := "/sys/devices/soc.0/f9200000.ssusb/f9200000.dwc3/gadget/lun%d/file"
TW_NO_USB_STORAGE := true
TW_EXCLUDE_SUPERSU := true
TW_NEW_ION_HEAP := true

# NTFS (R/W access)
TW_INCLUDE_NTFS_3G := true

# TIME
# avoid TWRP's try to fix the time. time is handled by readtimeprop.sh
# and TWRP will reset the already fixed time when enabled
TARGET_RECOVERY_QCOM_RTC_FIX := false

# GRAPHIC FLAGS
TW_THEME := portrait_hdpi
TW_DEFAULT_BRIGHTNESS := 200
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
# when double tap is enabled this has to be set to FALSE otherwise when
# an usb cable is connected the screen is blank for several minutes
# TW_SCREEN_BLANK_ON_BOOT := false
TW_NO_SCREEN_TIMEOUT := true

# SPECIAL FLAGS
# ignore a factory reset when using the phone's factory reset screen
# or since N (at least) when using <fastboot erase userdata> which set the same
# https://gerrit.omnirom.org/#/c/20750/
# this flag requires to build TWRP in branch 7.1 or later
# DO NOT SET TO FALSE WHEN YOU DO NOT KNOW WHAT YOU'RE DOING!
TW_IGNORE_MISC_WIPE_DATA := true
# do not build / include TWRP app
TW_EXCLUDE_TWRPAPP := true

# CRYPTO
TW_INCLUDE_CRYPTO := true
# https://github.com/omnirom/android_bootable_recovery/commit/71c6c50d0d
TW_CRYPTO_USE_SYSTEM_VOLD := qseecomd
TARGET_KEYMASTER_WAIT_FOR_QSEE := true

# TWRP debug flags
#TW_CRYPTO_SYSTEM_VOLD_DEBUG := true
#TARGET_RECOVERY_DEVICE_MODULES += strace debuggerd
#TW_RECOVERY_ADDITIONAL_RELINK_FILES += $(TARGET_OUT_OPTIONAL_EXECUTABLES)/strace $(TARGET_OUT_EXECUTABLES)/debuggerd

# SEPOLICY stuff
# https://android.googlesource.com/platform/external/sepolicy/+/marshmallow-release/README
BOARD_SEPOLICY_DIRS += device/lge/g4/sepolicy

# Builder's *default* for including /data/media (internal storage) in TWRP backups of data partition
# outcomment for *not* including data/media by default or "true" for including it
# TW_BACKUP_INCLUDE_DATA_MEDIA := true

# DEBUG (BOTH needed to enable logcat)
TWRP_INCLUDE_LOGCAT := true
TARGET_USES_LOGD := true

# Use toybox as busybox failing to build
TW_USE_TOOLBOX := true

# Unify all g4 models
TARGET_UNIFIED_DEVICE := true
TARGET_INIT_VENDOR_LIB := libinit_g4
TARGET_RECOVERY_DEVICE_MODULES += libinit_g4
TARGET_LIBINIT_DEFINES_FILE := $(DEVICE_TREE)/init/libinit_g4.cpp
#TW_RECOVERY_ADDITIONAL_RELINK_FILES += $(OUT_DIR)/system/usr/share/zoneinfo/tzdata

############ SHRP SECTION
# NOTE - Dont use '-' or blank spaces in flag values , otherwise it will create build errors or other bugs in recovery (Excluding SHRP_PATH,SHRP_REC).
# Path of your SHRP Tree
SHRP_PATH := device/lge/g4
# Maintainer name
SHRP_MAINTAINER := steadfasterX
# SHRP state
SHRP_OFFICIAL := true
# Device codename
SHRP_DEVICE_CODE := g4
# put this 0 if device has no EDL mode
SHRP_EDL_MODE := 0
SHRP_EXTERNAL := /external_sd
SHRP_INTERNAL := /sdcard
SHRP_OTG := /usb_otg
# Put 0 to disable flashlight
SHRP_FLASH := 1
# These are led paths, find yours then put here (Optional)
SHRP_CUSTOM_FLASHLIGHT := true
SHRP_FONP_1 := /sys/class/leds/torch-light1/brightness
# Max Brightness of LED (Optional)
SHRP_FLASH_MAX_BRIGHTNESS := 200
# Check your device's recovery path, dont use blindly
SHRP_REC := /dev/block/bootdevice/by-name/recovery
# Use this flag only if your device is A/B
# SHRP_AB := true
# Recovery Type (It can be treble,normal,SAR) [Only for About Section]
SHRP_REC_TYPE := Normal
# Recovery Type (It can be A/B or A_only) [Only for About Section]
SHRP_DEVICE_TYPE := A_Only
# SHRP Padding Flag (Only for rounded corner devices.)
SHRP_STATUSBAR_RIGHT_PADDING := 40
SHRP_STATUSBAR_LEFT_PADDING := 40
# SHRP Express, enables on-the-fly theme patching
SHRP_EXPRESS := true
# SHRP Dark mode, use this flag to have dark theme set by default
SHRP_DARK := true

