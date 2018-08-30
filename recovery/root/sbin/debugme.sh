#!/sbin/sh
###########################################################################
# when using this in TWRP the first line should be:     "#!/sbin/sh"
# when using this in Android the first line should be:  "#!/system/bin/sh"
#
# IMPORTANT: Do not forget to mark this script executable!
# e.g.:      chmod +x debugme.sh
###########################################################################
#
# steadfasterX <steadfasterX -at- gmail -dot- com>
# 2015-2018, All rights reserved :)
######################################################################

# the mount point which is expected to be mounted
# will be mounted by this script if not
MNTPNT=/cache

LOG=$MNTPNT/debugme.log
DLOG=$MNTPNT/dmesg.log
LLOG=$MNTPNT/logcat.log

date > $LOG
echo "current mounts: $(mount)" >> $LOG

mount | grep -q "$MNTPNT"
MNTCACHE=$?
while [ $MNTCACHE -ne 0 ];do
	echo "$MNTPNT not mounted (yet)" >> $LOG
        echo "current mounts: $(mount)" >> $LOG
	sleep 1
	[ -d $MNTPNT ] && mount -t ext4 /dev/block/platform/soc.0/f9824900.sdhci/by-name${MNTPNT} $MNTPNT && echo "$MNTPNT mounted manually" >> $LOG
	mount | grep -q "$MNTPNT"
	MNTCACHE=$?
done

echo "$MNTPNT is mounted" >> $LOG

while [ 1 -eq 1 ];do
	echo "starting logger" >> $LOG

        # output of kernel ring buffer and auto-delete written lines
	dmesg -c >> $DLOG
        
        # output of logcat and clear after written
        logcat -b all -d >> $LLOG
        logcat -c -b all

        # custom cmds goes here
        # e.g. getprop, mount, whatever you can think of

        
        # ensure the script do not go wild
         sleep 1
done

