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
F_LOG "timeadjust before setprop: >$(getprop persist.sys.timeadjust)<"

# identify ROM type
getprop ro.build.flavor|egrep -i '(aosp|aicp|lineage|cyanogenmod|^cm_|^omni_)' >> /dev/null
if [ $? -eq 0 ];then ROMTYPE=custom; else ROMTYPE=stock; fi

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
	F_LOG "I detected a STOCK or STOCK based ROM!"
        F_LOG "if you feel this is an error you may have and unidentified custom ROM flavor installed!"
	F_LOG "Paste this line in the TWRP thread: flavor = $(getprop ro.build.flavor)"
      if [ -r /data/time/ats_2 ]||[ -r /data/system/time/ats_2 ];then
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
	[ -f /data/time/ats_2 ]&& rm /data/time/ats_2 && F_LOG "We are on a $ROMTYPE ROM so deleted unneeded STOCK ROM file: /data/time/ats_2"
	[ -f /data/system/time/ats_2 ] && rm /data/system/time/ats_2 && F_LOG "We are on a $ROMTYPE ROM so deleted unneeded STOCK ROM file: /data/system/time/ats_2"
        
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

F_LOG "$0 finished"
