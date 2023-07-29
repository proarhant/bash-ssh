# download-backups.sh
The shell script named download-backups.sh downloads file from remote server using SSH &amp; SCP.

# USAGE
```
Usage: download-backups.sh [ Date in yyyy-mm-dd format ]
```

# EXAMPLES

   1. To download the backup file named `2022-01-21.tar.gz` from the remote server, please execute following:   
```bash
./download-backups.sh 2022-01-21
```
![image](https://github.com/proarhant/bash-ssh/assets/2681229/1fc70056-f386-4735-a148-28f043f67db6)

  2. `Invalid date`:
     
![image](https://github.com/proarhant/bash-ssh/assets/2681229/6934a918-391f-4e31-b57e-ab9abf318236)

  4. `Invalid number of argument`:

![image](https://github.com/proarhant/bash-ssh/assets/2681229/b34b0fca-f25a-4256-a81c-10ca168d55fa)

  5. `Valid date format, but the backup does not exists`:

![image](https://github.com/proarhant/bash-ssh/assets/2681229/6aa00524-3b54-4e6d-b3bd-28d2fb4cd9a7)

  6. `Content of the log file`:

![image](https://github.com/proarhant/bash-ssh/assets/2681229/4b6d087d-9f98-4056-b88f-2956d75e761b)
