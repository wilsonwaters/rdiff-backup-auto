# rdiff-backup-auto
Automatic centralised backups for multiple hosts using [rdiff-backup](https://github.com/rdiff-backup/rdiff-backup) and [cron](https://en.wikipedia.org/wiki/Cron).

rdiff-backup is a command line backup tool which efficiently copies a directory structure and keeps incremental revisions of changes. Backups are stored locally as a simple mirrored folder for quick restoration of files. Historical versions of files can be restored by the rdiff-backup tool.

rdiff-backup-auto is a bash script and simple configuration files which can be called by cron to backup a set of hosts via ssh. New hosts can be configured by adding a single configuration file. The configuration file provides a simple flexible mechanism to exclude/include files and folders (such as system folders) with sensible defaults.

rdiff-backup-auto has been tested with 20+ Linux hosts on local and remote networks and can potentially be used to securely backup hundreds of remote hosts running a variety of operating systems (Linux, Windows, MacOS - see [rdiff-backup](https://github.com/rdiff-backup/rdiff-backup)). In many situations, a simple filesystem copy is more effective than other enterprise mechanisms such as [snapshots](https://en.wikipedia.org/wiki/Snapshot_(computer_storage)) and less expensive than commercial alternatives such as [Veeam](https://www.veeam.com/).

# Installation

Tested on Ubuntu, though the procedure should be similar for other operating systems

## Server

The server should have sufficient storage to hold all host filesystems (uncompressed) and incremental changes.

1. Install rdiff-backup

        sudo apt-get install rdiff-backup
1. Download rdiff-backup-auto files (use git clone, or simply copy/paste file contents into a text editor into the target location)

        git clone https://github.com/wilsonwaters/rdiff-backup-auto.git     
1. Install rdiff-backup-auto files

        sudo cp rdiff-backup-auto/rdiff-backup-auto /etc/cron.d/
        sudo chmod 755 /etc/cron.d/rdiff-backup-auto
        sudo mkdir -p /etc/backup/hosts
        sudo cp rdiff-backup-auto/backup.conf /etc/backup/
        sudo cp rdiff-backup-auto/backup.hostname.example.com /etc/backup/
1. Configure rdiff-backup-auto (see configuration section below)

        sudo vim /etc/backup/backup.conf
1. Configure cron (example, run at 3:30am every day).

        sudo echo "30 3 * * *      root    /etc/cron.d/backup" >> /etc/crontab
1. Configure SSH key for unattended key-based login. See https://www.redhat.com/sysadmin/passwordless-ssh for details

        sudo ssh-keygen
        # press enter when prompted for password
        sudo cat ~/.ssh/id_rsa.pub
## Host

The hosts to be backed up should have a similar version of rdiff-backup installed (though different versions don't seem to cause a problem). Some systems, such as Windows, may need an SSH serice installed.

1. Install rdiff-backup on host to be backed up

        # Run this on the host to be backed up
        sudo apt-get install rdiff-backup
1. Enable unattended SSH access for the backup user. I configure this for root, but you can configure any other user who has full access to the remote host filesystem if you are concerned about security.

        # Run on the server.
        sudo ssh-copy-id root@hostname  # hostname refers to the DNS name or IP address of the host to be backed up
        sudo ssh root@hostname # Test. This should log you in without password prompt
1. Configure host. See configuration section below for details

        # Run on the server
        sudo cp /etc/backup/backup.hostname.example.com /etc/backup/hosts/backup.hostname # hostname refers to the DNS name or IP address of the host to be backed up
        sudo vim /etc/backup/hosts/backup.hostname
# Configuration

Defaults in configuration files should be suitable for most situations. The configuration files simplify the rdiff-backup options. Configuring a new host to be backed up is as simple as making a copy of the example host config on the server.

## Server

```
# local directory to store backups
BACKUP_DIR=/usr/data/backups

# location of remote host specific back up details
HOST_CONFIGS_DIR=/etc/backup/hosts

# Number of days to keep backups for. If unset backups will be kept forever
KEEP_BACKUP_DAYS=365

# parameters to pass to rdiff-backup. See man rdiff-backup for more
RDIFF_BACKUP_PARAMETERS=""

# set to 1 for debugging information to be output to stdout (cron will email this)
DEBUG=0

# If COPY_FILE is set, tar up the entire backup dir and copy it to this location
#COPY_FILE=

```

## Host

```
# The user to login as
#SSH_USER="testuser"

# The directory to start the backup at.
START_DIR="/"

# Exclude everything by default. Only backup specifically included directories
#EXCLUDE_BY_DEFAULT=1

# Directories to indlude/exclude. Use a space to separate. 
# Standard shell patterns can be used (*, $, [])
# INCLUDE_DIRS will have preference.
# ie. if we include /usr/data/testuser but exclude /usr/data everything under
# /usr/data/testuser will be backed up, but /usr/data/otheruser won't be.
#INCLUDE_DIRS="/home/testuser"
EXCLUDE_DIRS="/proc /tmp /mnt /media /dev /tmp /sys /lost+found /usr/data*"
```

# Usage

The backup is run automatically by cron. Ensure cron is configured to email failed tasks to an administrator. You can test this by setting DEBUG=1 in the configuration.

Restoring files is as simple as copying them directly from the backup folder (use scp if you need to copy them back to the remote host). You can also use the standard rdiff-backup commands (see man rdiff-backup or [rdiff-backup webpage](https://rdiff-backup.net/)).
