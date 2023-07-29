# download-backups.sh
This version of the shell script named `download-backups.sh` downloads file from remote server `using SCP only`. `No explicit SSH` connection is used.

# USAGE
```
Usage: download-backups.sh [ Date in yyyy-mm-dd format ]
```
# EXAMPLES

   1. To download the backup file named `2022-01-21.tar.gz` from the remote server, please execute following:   
```bash
./download-backups.sh 2022-01-21
```
![image](https://github.com/proarhant/bash-ssh/assets/2681229/8d179424-e0da-4b50-9874-4a1bcefe2fc4)

  2. `Invalid date`:
     
![image](https://github.com/proarhant/bash-ssh/assets/2681229/47cd2394-abfc-473e-bf95-5989b67ef5a6)

  3. `Invalid number of argument`:

![image](https://github.com/proarhant/bash-ssh/assets/2681229/245edc56-8034-4e31-9b58-44f668497f22)

  4. `Valid date format, but the backup does not exists`:

![image](https://github.com/proarhant/bash-ssh/assets/2681229/83ad65e4-2821-42ae-b69f-f338c8ac311f)

  5. `Content of the log file`:

![image](https://github.com/proarhant/bash-ssh/assets/2681229/9f0a2c4a-1a68-4477-9c6c-70de0dcd2f11)
