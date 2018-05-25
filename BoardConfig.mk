# BOOTLOADER
TARGET_BOOTLOADER_BOARD_NAME := MSM8992
TARGET_NO_BOOTLOADER := true

# PLATFORM
TARGET_BOARD_PLATFORM := msm8992
TARGET_BOARD_PLATFORM_GPU := qcom-adreno418
TARGET_PLATFORM_DEVICE_BASE := /devices/soc.0/

# ARCHITECTURE
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_SMP := true

TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# BOOT IMAGE
BOARD_KERNEL_CMDLINE := maxcpus console=ttyHSL0,115200,n8 androidboot.console=ttyHSL0 user_debug=31 ehci-hcd.park=3 lpm_levels.sleep_disabled=1 msm_rtb.filter=0x37 androidboot.hardware=p1 androidboot.selinux=permissive
BOARD_KERNEL_BASE := 0x00000000
BOARD_KERNEL_PAGESIZE := 4096
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x0000000 --ramdisk_offset 0x02200000 --tags_offset 0x00000100 --dt device/lge/g4/dt.img
TARGET_PREBUILT_KERNEL := device/lge/g4/Image

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

# TIME
# avoid TWRP's try to fix the time. time is handled by readtimeprop.sh
# and TWRP will reset the already fixed time when enabled
TARGET_RECOVERY_QCOM_RTC_FIX := false

# GRAPHIC FLAGS
TW_THEME := portrait_hdpi
TW_DEFAULT_BRIGHTNESS := 162
TARGET_RECOVERY_PIXEL_FORMAT := "RGBX_8888"
# when double tap is enabled this has to be set to FALSE otherwise when
# an usb cable is connected the screen is blank for several minutes
TW_SCREEN_BLANK_ON_BOOT := false
#TW_TARGET_USES_QCOM_BSP := true

# SPECIAL FLAGS
# ignore a factory reset when using the phone's factory reset screen
# or since N (at least) when using <fastboot erase userdata> which set the same
# https://gerrit.omnirom.org/#/c/20750/
# this flag requires to build TWRP in branch 7.1 or later
# DO NOT SET TO FALSE WHEN YOU DO NOT KNOW WHAT YOU'RE DOING!
TW_IGNORE_MISC_WIPE_DATA := true

# CRYPTO
TW_INCLUDE_CRYPTO := true
TW_CRYPTO_USE_SYSTEM_VOLD := qseecomd
TARGET_KEYMASTER_WAIT_FOR_QSEE := true

# TWRP debug flags
TW_CRYPTO_SYSTEM_VOLD_DEBUG := false
TARGET_RECOVERY_DEVICE_MODULES += strace debuggerd
TW_RECOVERY_ADDITIONAL_RELINK_FILES += $(TARGET_OUT_OPTIONAL_EXECUTABLES)/strace $(TARGET_OUT_EXECUTABLES)/debuggerd64

# SEPOLICY stuff
# https://android.googlesource.com/platform/external/sepolicy/+/marshmallow-release/README
BOARD_SEPOLICY_DIRS += device/lge/g4/sepolicy

# DEBUG (BOTH needed to enable logcat)
#TWRP_INCLUDE_LOGCAT := true
#TARGET_USES_LOGD := true

# Unify all g4 models
TARGET_UNIFIED_DEVICE := true
TARGET_INIT_VENDOR_LIB := libinit_g4
TARGET_RECOVERY_DEVICE_MODULES += libinit_g4
TARGET_LIBINIT_DEFINES_FILE := $(DEVICE_TREE)/init/libinit_g4.cpp
