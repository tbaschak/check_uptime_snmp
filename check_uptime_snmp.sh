#!/bin/bash

## 2013-07-02, Theo Baschak (based on the work of Ingo Lantschner and
## Fredrik Wanglund)
## This plugin warns CRITICAL when uptime is less than threshold, and
## WARNING when less than second threshold.

## 2006-10-23, Ingo Lantschner (based on the work of Fredrik Wanglund)
## This Plugin gets the uptime from any host (*nix/Windows) by SNMP

PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

PROGNAME=`basename $0`
REVISION=`echo 'Revision: 0.3t ' `
NAGIOSPLUGSDIR=/usr/lib/nagios/plugins
WARN=$3
CRIT=$4

print_usage() {
	echo "Usage: $PROGNAME <host> <community> <warning> <critical>"
}

print_revision() {
	echo $PROGNAME  - $REVISION
}
print_help() {
	print_revision 
	echo ""
	print_usage
	echo ""
	echo "This plugin checks the Uptime through SNMP"
	echo "The treshholds (warning, critical) are in days"
	echo ""
	exit 0
}

case "$1" in
	--help)
		print_help
		exit 0
		;;
	-h)
		print_help
		exit 0
		;;
	--version)
	   	print_revision $PROGNAME $REVISION
		exit 0
		;;
	-V)
		print_revision $PROGNAME $REVISION
		exit 0
		;;
	*)

## Einige Plausibilitaetstest

if [ $# -lt 4 ]; then
   print_usage
   exit 3
   fi

if [ $WARN -lt $CRIT ]; then
   echo warning-level must be above the critical!
   exit 3
   fi


## Now we start checking ...

UPT=$(snmpget -Oqvt -v1 -c $2 $1 .1.3.6.1.2.1.1.3.0)
RES=$?

UPTMIN=$(expr $(echo $UPT ) / 6000 )

if  [ $RES = 0 ]; then
   UPTDAY=$(expr $UPTMIN / 60 / 24 )
      if [ $UPTDAY -lt $CRIT ]; then  
         echo CRITICAL: System uptime $UPTMIN min.
         exit 2
         fi

      if [ $UPTDAY -lt $WARN ]; then  
         echo WARNING: System uptime $UPTMIN min.
         exit 1
         fi

      if [ $UPTDAY -ge $WARN ]; then  
         echo OK: System uptime $UPTDAY Days
         exit 0
         fi

   fi

echo $UPT
exit 3

esac
