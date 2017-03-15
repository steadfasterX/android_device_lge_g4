#!/sbin/sh
########################################################################################
# Brought to you by steadfasterX
########################################################################################

LOG=/tmp/recovery.log
TAG=TUNESD
RHSIZE=1024

F_LOG(){
   MSG="$1"
   echo "I:$TAG: $(date +%F_%T) - $MSG" >> $LOG
}
F_ELOG(){
   MSG="$1"
   echo "E:$TAG: $(date +%F_%T) - $MSG" >> $LOG
}
F_LOG "Started $0"

# find all readahead files (should be 1 only but to be sure using for loop) for the external sd
for rh in $(find /sys/devices/soc.0/f98a4900.sdhci/mmc_host/mmc1/ -name read_ahead_kb);do
	echo $RHSIZE >> $rh
	if [ $? -ne 0 ];then
		F_ELOG "an error occured while setting read_ahead_kb for <$rh>"
	else
		F_LOG "tuned $rh"
		F_LOG "Value now: <$(cat $rh)>"
	fi
done

