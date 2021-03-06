#!/bin/bash

# Check if already running

SCRIPT=`basename $0`
if [ `ps -ef | grep $SCRIPT | grep -v grep | wc -l` -gt 3 ]; then
	echo "already running"
	exit 1
fi

## Variables

##############################
##Checking PMON DB processes##
##############################


LOGDES="pmon__________status"
DEFPATH=/4csysmon/1_unix
DBDEFPATH=/4csysmon/2_db/2_pmon_check
LOG=$DBDEFPATH/pmon_check.log
RUNNING_PROC=`ps -ef | grep -v grep |grep -c asm_pmon_\+ASM`
MSG="ASM PMON process not running"

. $DEFPATH/6_misc/global_parameters.list

## If pmon process count is equal to 0 notify us

if [ $RUNNING_PROC -eq 0 ]; then
printf "  $ACC
  $SITE
  $MODE
  $REQ
  $REQTYPE
  $GRP
  $OPP
  @@TECHNICIAN=4C Support - Oracle Standby Technician@@ 
  @@CATEGORY=DBA SLA - `printf $SITE|awk -F'[=|@@]' '{print $4}'`@@ 
  @@SUBCATEGORY=Database Administration@@
  $ITEM
  @@PRIORITY=P1@@
  @@URGENCY=0 - Urgent@@\n
$MSG" | mailx -r "$SYSMONMAIL" -s "@4CSD@$HOST P1: $MSG" $SERVICEDESKMAIL $ORASUPPMAIL $OSCARMAIL

  #echo "$MSG" | mailx -s "$HOST P1: $MSG" $ORASUPPMAIL $SERVICEDESK $OSCARMAIL
 # $SMS $ORASUPPSMS "$HOST: $MSG"
 # $SMS $OSCARSMS "$HOST: $MSG"

# Log alerts to log file

 echo $DATE $HOSTLOGNAME P1 $LOGDES $MSG >> $LOG
 echo $DATE $HOSTLOGNAME P1 $LOGDES $MSG >> $MASTERLOG

 else echo $DATE stamp >> $LOG

fi
