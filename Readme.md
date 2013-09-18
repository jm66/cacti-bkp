Cacti-Backup script

Will backup the following Cacti files/dirs:
	/etc/cron.d/cacti
	/etc/httpd/conf.d/cacti.ssl.conf
	/var/www/cacti/html
	/var/www/cacti/cacti-0.8.8a

Instructions

1. Create a softlink to /usr/local/bin/runCactiBackup.sh from wherever the script is installed.
2. Add /etc/cron.d/cactibackup with crotab file content.
3. Be sure that the following directories exist:
	/var/log/cacti
	/var/backup/cacti
4. Enjoy