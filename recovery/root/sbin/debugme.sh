#/sbin/sh
######################################################################

echo "starting log" > /tmp/propdebug

while [ 1 -eq 1 ];do
	echo >> /tmp/propdebug
	getprop >> /tmp/propdebug
	echo "sleeping 5s" >> /tmp/propdebug
	echo >> /tmp/propdebug
	sleep 5
done
