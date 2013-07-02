check_uptime_snmp
=================
This is a simple check script for Nagios (or probably Icinga or Shrinken too) to check the system uptime, and warn if it is less than the specified threshold. 

To Use
----------
`bash check_uptime_snmp.sh 192.168.x.x public 2 1`

OK: System uptime 81 Days


Compatibility
----------
This script relies on the existence of 1.3.6.1.2.1.1.3.0 which *most* SNMP devices provide. 
