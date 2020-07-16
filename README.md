# rdiff-backup-auto
Automate backups for multiple hosts using [rdiff-backup](https://github.com/rdiff-backup/rdiff-backup) and cron.

rdiff-backup is a command line backup tool which efficiently copies a directory structure from local and remote hosts and keeps incremental revisions of changes to the files and folders stored to a local filesystem.

rdiff-backup-auto is a bash script and set of simple configuration files which can be called by cron to backup a set of hosts via ssh. Backups are stored locally as a simple mirrored folder, meaning recovery of files is simple. New hosts can be configured to be backed up by adding a single confguration file.

It has been tested with 20+ Linux hosts on local and remote networks and can potentially be used to securely backup hundreds of remote hosts potentially running a variety of operating systems (Linux, Windows, MacOS - see [rdiff-backup](https://github.com/rdiff-backup/rdiff-backup)). In many situations, a simple filesystem copy  is more effective than other enterprise mechinisims such as [snapshots](https://en.wikipedia.org/wiki/Snapshot_(computer_storage)) and less expensive than commercial alternatives such as [Veeam](https://www.veeam.com/).

# Installation

This has been tested on Ububtu, though the procedure should be similar for other operating systems

## Server

The server should have sufficient storage to hold all host filesystems (uncompressed) and incremental changes.

1. Install rdiff-backup

        sudo apt-get install rdiff-backup
1. Download rdiff-backup-auto files (use git clone, or simply copy/paste file contents into a text editor into the target location)

        git clone https://github.com/wilsonwaters/rdiff-backup-auto.git     
1. Install rdiff-backup-auto files

        sudo cp rdiff-backup-auto/rdiff-backup-auto /etc/cron.d/
        sudo mkdir -p /etc/backup/hosts
        sudo cp rdiff-backup-auto/backup.conf /etc/backup/
        sudo cp rdiff-backup-auto/backup.host.example.com /etc/backup/hosts/
1. Configure rdiff-backup-auto (see configure section below)

        sudo vim /etc/backup/backup.conf
        sudo vim /etc/backup/backup.host.example.com
        sudo mv /etc/backup/backup.host.example.com /etc/backup/backup.myservername
1. Configure cron (example, run at 3:30am every day).

        sudo echo "30 3 * * *      root    /etc/cron.d/backup" >> /etc/crontab
1. Configure SSH for unattended key-based login. See https://www.redhat.com/sysadmin/passwordless-ssh for details

        sudo ssh-keygen
        # press enter when prompted for password
        sudo cat ~/.ssh/id_rsa.pub
## Host

The hosts to be backed up should have a similar version of rdiff-backup installed (though different versions don't seem to cause a problem).

1. Install rdiff-backup

        sudo apt-get install rdiff-backup
1. Enable unattended SSH access for the backup user. I configure this for root, but you can configure any other user who has full access to the remote host if you are concerned about security.

        

# Configuration

# Usage
