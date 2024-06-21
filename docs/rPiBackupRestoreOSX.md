Backup up your Raspberry Pi SD Card on OS X

1. With your SD Card inserted into a card reader on your Mac, we can begin the process of making a full image backup of your Raspberry Pi.

Unlike Windows, we can easily use the terminal to do this.

To proceed with this tutorial, start off by opening the Terminal application.

2. With the Terminal application now open on your Mac device, we need to utilize the following command. This command will display all available disks on your device.

diskutil list
Copy

Within this list, look for your SD Card by looking for a disk that is about the size of your SD Card.

For instance, with a 16gb SD Card, you should be looking at a “_partition_scheme” of about 16gb. You will also notice that there is likely a partition called boot.

Once you have found your SD Card in this list, take notice of the mount location. For instance, my own SD Card was under “/dev/disk1“.

3. Now still within the terminal on your Mac, we need to utilize the following command.

This command will basically create a copy of your SD Cards image, and save it to your home directory as “PiSDBackup.dmg” (The file format being a disc image)

Make sure you swap out “/dev/disk1” with whatever you found when using the “diskutil list” command.

sudo dd if=/dev/disk1 of=~/PiSDBackup.dmg
Copy

This command can take some time to complete as it requires reading the entire SD Card to the disk.

The command also provides no feedback on how far along it is, so please be patient and wait for the prompt to enter another command to reappear before removing your SD Card from your Mac.
Restoring your Raspberry Pi Backup on OS X

1. Now that you need to restore your Raspberry Pi to its backup we need to use the “diskutil list” command to find our SD Card. Remember as before, take note of partition sizes to find your SD Card.

diskutil list
Copy

2. Now before we can write to the SD Card, we will need to unmount it. The reason for this is that OSX will attempt to write to it at the same time, unmounting the SD Card prevents this from happening.

Run the following command on your Mac device to unmount the card, again making sure that you replace “/dev/disk1” with the one you found using the “diskutil list” command.

diskutil unmountDisk /dev/disk1
Copy

3. Finally, we can now write the image back to the SD Card, and please be prepared for this to take some time as it involves rewriting the entire SD Card.

Remember to change out “/dev/disk1” with the mount location you grabbed using the diskutil list command.

sudo dd if=~/PiSDBackup.dmg of=/dev/disk1
Copy

Like reading the SD Card to a disk image file, the process of writing the image also takes a long time.

As an added note, the dd tool doesn’t show any writing progress so please be patient and wait till the enter command prompt reappears.

4. Once the writing process has completed we can now eject the SD Card from the Mac so we can continue using our Raspberry Pi Backup.

To eject the SD Card, we will need to utilize the command below.

sudo diskutil eject /dev/rdisk3
Copy

Your Raspberry Pi’s SD Card should now be in the same state as when you made the original backup.
