Backing up your Raspberry Pi SD Card on Linux

1. Before starting to backup up your Raspberry Pi’s SD Card on Linux we will first run the df command with the reader not plugged in.

The reason for this makes it much easier to see which device is which.

df -h
Copy

This command will return something like what is shown below.

Filesystem      Size  Used Avail Use% Mounted on
/dev/root        15G  4.0G  9.6G  29% /
devtmpfs        458M     0  458M   0% /dev
/dev/mmcblk0p1   41M   21M   21M  52% /boot

2. Now insert your SD Card reader back into your Linux computer and again rerun the following command, but this time take note of the additional entries.

df -h
Copy

This command will return something like what you got above, but with an additional entry, in our case “/dev/sda1” is that additional entry, with your entry, remove the partition number.

For instance, “/dev/sda1” will become “/dev/sda“. We need to do this as we want to write to the entire drive and not just a singular partition.

Filesystem      Size  Used Avail Use% Mounted on
/dev/root        15G  4.0G  9.6G  29% /
devtmpfs        458M     0  458M   0% /dev
/dev/mmcblk0p1   41M   21M   21M  52% /boot
/dev/sda1       3.7G   75M  3.6G   3% /media/boot

3. We can now utilize dd, the same tool we make use of on Mac OS X since it is also built on Unix.

We can utilize the following command to begin dumping the SD Cards image to our home directory.

Make sure you replace “/dev/sda” with the filesystem that you grabbed using the “df -h” command.

sudo dd if=/dev/sda of=~/PiSDBackup.img
Copy

The process of backing up your Raspberry Pi can take some serious time, so be patient and wait.

The dd tool provides no feedback, so you will have to wait until the input command returns to your terminal.

Once it reappears, you will have successfully backed up your Raspberry Pi.
Restoring your Raspberry Pi Backup on Linux

1. Now that you have made a backup of your Raspberry Pi you will want to at some stage make use of this. To do this, we will need to again go through the process of finding out the location of our filesystems.

Use the “df -h” command like we did in the first segment of this guide, though this time you might have more than one partition pop up for your SD Card such as “/dev/sda1” and “/dev/sda2“.

Take note of all new entries as you will need to unmount all of them.

2. Now that we have all our partition locations ready, we can unmount each of them by running the following command for each one.

Switch out “/dev/sda1” for the locations that you got in the previous step.

sudo unmount /dev/sda1
Copy

3. With all the partitions now unmounted let’s write our backup image to the SD Card. We can do that by running the following command. Remember swap out “/dev/sda” with your devices mount location.

sudo dd bs=4M if=~/PiSDBackup.img of=/dev/sda
Copy

Backing up your Raspberry Pi to a USB Drive

1. Before plugging in your USB device that you want to keep the backups on let’s first run the following command to find out the current filesystems that are available to us.

df -h
Copy

This command will return something like what is shown below.

Filesystem      Size  Used Avail Use% Mounted on
/dev/root        15G  4.0G  9.6G  29% /
devtmpfs        458M     0  458M   0% /dev
/dev/mmcblk0p1   41M   21M   21M  52% /boot

2. Now insert your USB Device into your Raspberry Pi and run the following command, take note of any new entries that pop up.

df -h
Copy

This command will return something like what is shown below.

Filesystem      Size  Used Avail Use% Mounted on
/dev/root        15G  4.0G  9.6G  29% /
devtmpfs        458M     0  458M   0% /dev
/dev/mmcblk0p1   41M   21M   21M  52% /boot
/dev/sda1       3.7G   75M  3.6G   3% /media/pi/MYBACKUPDRIVE

3. With our USB device showing on the list, we need to look at the “Mounted on” location. In our case, this is “/media/pi/MYBACKUPDRIVE“.

This directory will be the location that we will write our backup images. So, make a note of it for later in the tutorial.

Now with our backup location now handy we can download the backup script that we are going to use, this script was written by a user on the Raspberry Pi forums called Jinx.

Let’s clone the script to our Raspberry Pi by running the following two commands.

cd ~
git clone https://github.com/lzkelley/bkup_rpimage.git
Copy

4. With the script now saved to the Raspberry Pi, we can start to make use of it. We can do an initial backup by running the command below on our Raspberry Pi. Make sure you replace “/media/pi/MYBACKUPDRIVE” with your own mount location that you grabbed in the previous step.

sudo sh bkup_rpimage.sh start -c /media/pi/MYBACKUPDRIVE/rpi_backup.img
Copy

This script will create a dummy image then launch a rsync process to copy all the files from the system to the dummy image.

Please note that the initial backup can take up to an hour to complete.

5. Now that we have created our initial backup file and know that the script is working as intended we can move onto automating the backup. To do this, we will be making use of cron jobs.

One thing to decide on how is whether you want an incremental backup or multiple backups. An incremental backup just updates the original backup and doesn’t generate a new file.

Run the following command on your Raspberry Pi to begin editing the crontab.

sudo crontab -e
Copy

6. In the crontab editor, add one of the following lines to the bottom of the file.

This process will make a backup every day. If you want to edit the cron timings, you can use our Crontab tool work them out easily.

Incremental Backup

0 0 * * * sudo sh /home/pi/bkup_rpimage/bkup_rpimage.sh start -c /media/pi/MYBACKUPDRIVE/rpi_backup.img
Copy

Multiple Backup

0 0 * * * sudo sh /home/pi/bkup_rpimage/bkup_rpimage.sh start -c /media/pi/MYBACKUPDRIVE/rpi_$(date +%Y-%m-%d).img
Copy

Now save the file by pressing CTRL + X then pressing Y and then hitting ENTER.

7. You should now have an automated backup system up and running that will continually backup your Raspberry Pi to your USB device.

To restore these images follow our Restoring guides located in the SD Card section of this guide.
