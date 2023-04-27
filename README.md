# Homebrew Bash Tools

### Official HomeBrew Uninstall
This file includes the command to uninstall homebrew from /opt/homebrew or /usr/local.

### sudoLessUninstall.sh
This file is as the name describes. This will attempt to remove files without sudo. 

### uninstallRAW.sh
This file is exact copy of uninstall.sh from homebrew, with NONINTERACTIVE=1 hard coded.

### uninstallBrew.sh
This file will remove instances of both default directory and custom directory of homebrew.
If it is default directory, it calls uninstallRAW.sh.
If it is custom directory, it calles sudoLessUninstall.sh
