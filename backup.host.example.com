# Config options for backing up remote computers
# filename must be in the format of
#   backup.hostname.domain

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
