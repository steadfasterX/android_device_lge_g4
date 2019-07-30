#!/sbin/sh

LOG=/tmp/recovery.log
TAG=PREPDEC

F_LOG(){
   MSG="$1"
   echo -e "I:$TAG: $(date +%F_%T) - $MSG" >> $LOG
}
F_ELOG(){
   MSG="$1"
   echo -e "E:$TAG: $(date +%F_%T) - $MSG" >> $LOG
}
F_LOG "Started $0"

relink()
{
	fname=$(basename "$1")
	target="/sbin/$fname"
	sed 's|/system/bin/linker64|///////sbin/linker64|' "$1" > "$target"
	chmod 755 $target
}

cp() {
    /sbin/cp $1 $2
    chown system $2
    chmod 777 $2
}

# the dev path can be different so we need to identify it
syspathsoc="/dev/block/platform/soc.0/f9824900.sdhci/by-name/system"
syspathnosoc="/dev/block/platform/f9824900.sdhci/by-name/system"
syspath=undefined
while [ ! -e "$syspath" ];do
    [ -e "$syspathnosoc" ] && syspath="$syspathnosoc"
    [ -e "$syspathsoc" ] && syspath="$syspathsoc"
    F_LOG "syspath: $syspath"
    [ "$syspath" == "undefined" ] && F_LOG "sleeping a bit as syspath is not there yet.." && sleep 1
done

# prepare and mount
mkdir /s >> $LOG 2>&1 
mount -t ext4 -o ro "$syspath" /s  >> $LOG 2>&1 || F_ELOG "mounting /s to $syspath failed"

# directories
F_LOG "$(echo "Preparing directories:"; \
mkdir /vendor 2>&1 ; \ 
mkdir -p /system/etc 2>&1 ; \
mkdir -p /vendor/lib/hw/ 2>&1 ; \
mkdir -p /vendor/lib64/hw/ 2>&1 ; \
mkdir /persist-lg 2>&1 ; \ 
mkdir /firmware 2>&1)"

# ensure qseecomd can read the libs
chown system -R /vendor/
chown o+rx -R /vendor/
chmod o+rx /sbin

# this relinks (linker64) AND copies qseecomd to /sbin
if [ -f /s/vendor/bin/qseecomd ];then
    relink /s/vendor/bin/qseecomd  >> $LOG 2>&1
    [ $? -ne 0 ] && F_ELOG "relinking qseecomd failed (vendor)"
else
    relink /s/bin/qseecomd >> $LOG 2>&1 || F_ELOG "relinking qseecomd failed"
    [ $? -ne 0 ] && F_ELOG "relinking qseecomd failed (system)"
fi

F_LOG "preparing libraries..."

# copy the hws stuff
#cp /s/bin/hwservicemanager /sbin/ >> $LOG 2>&1 
/sbin/cp /s/lib64/libandroid_runtime.so /sbin/ >> $LOG 2>&1 
/sbin/cp /s/lib64/libhidltransport.so /sbin/ >> $LOG 2>&1 
/sbin/cp /s/lib64/libhidlbase.so /sbin/ >> $LOG 2>&1 

# copy the decrypt stuff
cp /s/lib64/libsoftkeymaster.so /sbin/libsoftkeymaster.so >> $LOG 2>&1 
cp /s/vendor/lib64/libdiag.so /sbin/libdiag.so >> $LOG 2>&1 
cp /s/vendor/lib64/libdrmfs.so /sbin/libdrmfs.so >> $LOG 2>&1 
cp /s/vendor/lib64/libdrmtime.so /sbin/libdrmtime.so >> $LOG 2>&1 
cp /s/vendor/lib64/librpmb.so /sbin/librpmb.so >> $LOG 2>&1 
cp /s/vendor/lib64/libssd.so /sbin/libssd.so >> $LOG 2>&1 
cp /s/vendor/lib64/libtime_genoff.so /sbin/libtime_genoff.so >> $LOG 2>&1 
cp /s/vendor/lib64/libdrmtime.so /vendor/lib64/libdrmtime.so >> $LOG 2>&1 
cp /s/vendor/lib/libdrmtime.so /vendor/lib/libdrmtime.so >> $LOG 2>&1 

#cp /s/vendor/lib64/libsecureui.so /sbin/libsecureui.so >> $LOG 2>&1
#cp /s/vendor/lib64/lib-sec-disp.so /sbin/lib-sec-disp.so >> $LOG 2>&1

cp /s/vendor/lib64/libqmi_cci.so /sbin/libqmi_cci.so >> $LOG 2>&1 
cp /s/vendor/lib64/libqmiservices.so /sbin/libqmiservices.so >> $LOG 2>&1 
cp /s/vendor/lib64/libidl.so /sbin/libidl.so >> $LOG 2>&1 
cp /s/vendor/lib64/libqmi_client_qmux.so /sbin/libqmi_client_qmux.so >> $LOG 2>&1 
cp /s/vendor/lib64/libsmemlog.so /sbin/libsmemlog.so >> $LOG 2>&1 
cp /s/vendor/lib64/libdsutils.so /sbin/libdsutils.so >> $LOG 2>&1 
cp /s/vendor/lib64/libmdtp.so /sbin/libmdtp.so >> $LOG 2>&1 
cp /s/vendor/lib64/libqmi_encdec.so /sbin/libqmi_encdec.so >> $LOG 2>&1 
cp /s/vendor/lib64/libmdmdetect.so /sbin/libmdmdetect.so >> $LOG 2>&1 

cp /s/vendor/lib64/hw/keystore.default.so  /vendor/lib64/hw/keystore.default.so >> $LOG 2>&1
cp /s/vendor/lib/hw/keystore.default.so  /vendor/lib/hw/keystore.default.so >> $LOG 2>&1
cp /s/vendor/lib64/hw/gatekeeper.msm8992.so /vendor/lib64/hw/gatekeeper.msm8992.so >> $LOG 2>&1 

cp /s/vendor/lib64/libQSEEComAPI.so /sbin/libQSEEComAPI.so >> $LOG 2>&1 
cp /s/vendor/lib64/libQSEEComAPI.so /vendor/lib64/libQSEEComAPI.so >> $LOG 2>&1 
cp /s/vendor/lib/libQSEEComAPI.so /vendor/lib/libQSEEComAPI.so >> $LOG 2>&1 

cp /s/vendor/lib64/libqmi_common_so.so /vendor/lib64/libqmi_common_so.so >> $LOG 2>&1 
cp /s/vendor/lib64/libdiag.so /vendor/lib64/libdiag.so >> $LOG 2>&1 

F_LOG "preparing libraries finished"

umount /s >> $LOG 2>&1 || F_ELOG "unmounting /s failed"

# inform init to start qseecomd
mount -t vfat /dev/block/bootdevice/by-name /firmware >> $LOG 2>&1  || F_ELOG "mounting /firmware failed"
setprop crypto.ready 1  >> $LOG 2>&1 
F_LOG "crypto.ready: $(getprop crypto.ready)"

F_LOG "current mounts: \n$(mount)"

F_LOG "$0 ended"
exit 0
