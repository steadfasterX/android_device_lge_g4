#!/sbin/sh
# workaround script by steadfasterX to ensure time is correct

LOG=/tmp/recovery.log
DEBUG=0

F_LOG(){
   MSG="$1"
   echo "I:$TAG: $(date +%F_%T) - $MSG" >> $LOG
}
F_ELOG(){
   MSG="$1"
   echo "E:$TAG: $(date +%F_%T) - $MSG" >> $LOG
}

TAG="READTIME"
F_LOG "Starting $0"

if [ ! -f /sys/class/rtc/rtc0/since_epoch ];then

   F_LOG "fallback! timeadjust before setprop: >$(getprop persist.sys.timeadjust)<"
   
   # identify ROM type
   F_LOG "system mount:"
   mkdir /tempsys
   mount -t ext4 /dev/block/bootdevice/by-name/system /tempsys 2>&1 >> $LOG || mount -t f2fs /dev/block/bootdevice/by-name/system /tempsys 2>&1 >> $LOG
   F_LOG "$(mount | grep tempsys)"
   F_LOG "$(ls -la /tempsys/build.prop)"
   [ ! -r /tempsys/build.prop ] && F_ELOG "cannot determine installed OS! time will may not work properly.. falling back to STOCK.."
   [ $DEBUG -eq 1 ] && [ -r /tempsys/build.prop ] && F_LOG "your build entries in yours ROM build.prop: $(grep build /tempsys/build.prop)"
   SYSPROP=$(grep "ro.build.flavor" /tempsys/build.prop|cut -d "=" -f 2)
   echo "$SYSPROP" | egrep -i '(aoscp|aosp|aicp|lineage|cyanogenmod|^cm_|^omni_)' >> /dev/null
   if [ $? -eq 0 ];then ROMTYPE=custom; else ROMTYPE=stock; fi
   F_LOG "system umount"
   umount /tempsys 2>&1 >> $LOG
   rm -Rf /tempsys
   
   F_LOG "ROM type detected: $ROMTYPE (flavor: $SYSPROP)"
   [ -z "$ROMTYPE" ] && F_ELOG "ROM TYPE cannot be detected!!! Flavor: $SYSPROP"
   
   if [ -r /data/property/persist.sys.timeadjust ];then
       setprop persist.sys.timeadjust $(cat /data/property/persist.sys.timeadjust)
       F_LOG "setting persist.sys.timeadjust ended with $?"
       # trigger the timekeep daemon
       setprop twrp.timeadjusted 1
   else
       FSTABHERE=0
       F_LOG "checking /data"
       mount |grep -q "/data"
       MNTERR=$?
       F_LOG "No /data in fstab yet! will wait until its there.."
       while [ "$FSTABHERE" -eq 0 ];do
           sleep 2
           grep -q "/data" /etc/fstab && FSTABHERE=1
       done
       F_LOG "/data detected: >$(grep "/data" /etc/fstab)<"
   
       if [ -d /data/property ];then
           F_LOG "skipping mount /data as it is already mounted"
       else
           F_LOG "mounting /data to access time offset from ROM"
           mount /data >>$LOG 2>&1
           F_LOG "mounting /data ended with <$?>"
       fi
   
       [ $DEBUG -eq 1 ] && F_LOG "/data/time content: $(ls -la /data/time)"
       [ $DEBUG -eq 1 ] && F_LOG "/data/system/time content: $(ls -la /data/system/time)"
   
       # clean the kernel buffer to see only the time related stuff
       [ $DEBUG -eq 1 ] && dmesg -c >> /dev/null
        
       # if we are on STOCK and detect the proprietary time_daemon file ats_2 we start the qcom time_daemon
       # but when not we assume the open source timekeep daemon and starting that instead
       # OR:
       #    - /data/property/persist.sys.timeadjust (when switching from CM/AOSP/... to STOCK)
       if [ "$ROMTYPE" == "stock" ];then
      F_LOG "STOCK or STOCK based ROM!"
           F_LOG "if you feel this is an error you may have and unidentified custom ROM flavor installed!"
      F_LOG "Paste this line in the TWRP thread: flavor = $SYSPROP"
            if [ -r /data/time/ats_1 ]||[ -r /data/time/ats_2 ]||[ -r /data/system/time/ats_1 ]||[ -r /data/system/time/ats_2 ];then
          # we are on STOCK so we do not need custom ROM time file
               [ -f /data/property/persist.sys.timeadjust ] && rm /data/property/persist.sys.timeadjust && F_LOG "We are on a $ROMTYPE ROM so deleted unneeded CUSTOM ROM file: /data/property/persist.sys.timeadjust"
               F_LOG "proprietary qcom time-file detected! Will start qcom time_daemon instead of timekeep!"
          # trigger time_daemon
          setprop twrp.timedaemon 1
            else
          F_ELOG "We expected $ROMTYPE ROM but proprietary qcom time files missing! Cannot set time!"
          F_ELOG "$(ls -la /data/time/ /data/system/time/)"
            fi
       else
      # when coming from STOCK those are obsolete!
      [ -f /data/time/ats_1 ]&& rm /data/time/ats_* && F_LOG "atsa1: We are on a $ROMTYPE ROM so deleted unneeded STOCK ROM file: /data/time/ats_*"
      [ -f /data/time/ats_2 ]&& rm /data/time/ats_* && F_LOG "atsa2: We are on a $ROMTYPE ROM so deleted unneeded STOCK ROM file: /data/time/ats_*"
      [ -f /data/system/time/ats_1 ] && rm /data/system/time/ats_* && F_LOG "atsb1: We are on a $ROMTYPE ROM so deleted unneeded STOCK ROM file: /data/system/time/ats_*"
      [ -f /data/system/time/ats_2 ] && rm /data/system/time/ats_* && F_LOG "atsb2: We are on a $ROMTYPE ROM so deleted unneeded STOCK ROM file: /data/system/time/ats_*"
           
           if [ -r /data/property/persist.sys.timeadjust ];then
               setprop persist.sys.timeadjust $(cat /data/property/persist.sys.timeadjust)
               F_LOG "setting persist.sys.timeadjust ended with $?"
               # trigger timekeep daemon
               setprop twrp.timeadjusted 1
           else
               F_ELOG "/data/property/persist.sys.timeadjust not accessible! Cannot set time!"
           fi
        fi
   fi
   [ "$ROMTYPE" == "custom" ] && F_LOG "timeadjust property: >$(getprop persist.sys.timeadjust)<"
   [ $DEBUG -eq 1 ] && F_LOG "$(dmesg)"
else
   F_ELOG "Skipped custom time adjustment as TWRP will handle this!"
fi
F_LOG "$0 finished"
