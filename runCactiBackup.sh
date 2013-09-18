#!/bin/bash
# Cacti Backup script
# Configuration env Vars
# APP env Vars
APPVERSION="v1.0"
APPFULLNAME="Cacti-Backup"
MAILSUBJECT="${APPFULLNAME} - Activity"
MAILADDRESSES="me@jose-manuel.me"

LOGDIR="/var/log/cacti"
LOGFILE="${LOGDIR}/runCactiBackup-log.`date +%Y%m%d-%H-%M-%S`.txt"
TARLOGFILE="${LOGDIR}/runCactiBackup-tar-log.`date +%Y%m%d-%H-%M-%S`.txt"

# Set the backup filename and directory
DATE=`date +%Y%m%d` # e.g 20101025
BACKUPDIR="/var/backup/cacti";
TGZFILENAME="$BACKUPDIR/cacti_files_$DATE.tgz"

# Cacti Backup files
C_CRON="/etc/cron.d/cacti"
C_WSCF="/etc/httpd/conf.d/cacti.ssl.conf"
C_WSFSL="/var/www/cacti/html"
C_WSF="/var/www/cacti/cacti-0.8.8x"

# Start of program functions
# Logging function
do_log() {
        MESSAGE=$1
        LOG_LEVEL="INFO"
        case "$2" in
                W)
                        LOG_LEVEL="WARN"
                                        echo "[`date +%Y%m%d_%H.%M.%S`] - [${LOG_LEVEL}] ${MESSAGE} " | tee -a ${LOGFILE}
                ;;
                E)
                    LOG_LEVEL="ERROR"
                         echo "[`date +%Y%m%d_%H.%M.%S`] - [${LOG_LEVEL}] ${MESSAGE} " | tee -a ${LOGFILE}
                ;;
                *)
                    LOG_LEVEL="INFO"
                        echo "[`date +%Y%m%d_%H.%M.%S`] - [${LOG_LEVEL}] ${MESSAGE} " | tee -a ${LOGFILE}
                ;;
        esac
}
send_logs(){
        MAILSUBJECTF="${MAILSUBJECT} [LOG]"
        cat ${LOGFILE} | mailx -s "${MAILSUBJECTF}" ${MAILADDRESSES}
        }

do_log "Starting Cacti Backup for $DATE"
do_log "Backup files will be stored in $BACKUPDIR"
do_log " as $TGZFILENAME"
do_log "Logs will be stored in $LOGDIR"
do_log "as $LOGFILE and $TARLOGFILE "
# Change to the root directory
cd /

do_log "Deleting old backups +3 days "
# Delete old backups older than 3 days
find $BACKUPDIR/cacti_*gz -mtime +3 -exec rm {} \;

do_log "Executing Backup... this may take a while..."
tar -czvPf $TGZFILENAME $C_CRON $C_WSCF $C_WSF $C_WSFSL > $TARLOGFILE 2> $TARLOGFILE.err

do_log "Done. Logs will be sent to $MAILADDRESSES"
send_logs