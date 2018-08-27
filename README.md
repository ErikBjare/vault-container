vault-container
===============

Some files are just too sensitive to have laying around, even if you have full disk encryption. 

Also, sometimes you just want to upload something very important to an untrusted service (for backup purposes), and an encrypted container works wonders.


# Why?

I got tired of using Truecrypt/Veracrypt, and needed something simple that will stand the test of time.


# Usage

Follow the guide below to create a volume, you may then use the convenience scripts `mount.sh` and `unmount.sh` instead of following the mounting and unmounting steps manually (which might be prone to errors).


# How to create dmcrypt volumes

## Creating

Guide based on: https://www.digitalocean.com/community/tutorials/how-to-use-dm-crypt-to-create-an-encrypted-volume-on-an-ubuntu-vps

First, create a 512MB file to contain the volume. 
There are a few options:

```sh
# Fill it with zeroes:
dd if=/dev/zero of=./test-volume.dmcrypt bs=1M count=512

# Fill it with random data:
dd if=/dev/urandom of=./test-volume.dmcrypt bs=1M count=512

# Fill it with better random data (slower):
dd if=/dev/random of=./test-volume.dmcrypt bs=1M count=512
```

Then create a dm-crypt LUKS container in the file.
At this point you will be asked to enter the password for the volume.

```sh
cryptsetup -y luksFormat ./test-volume.dmcrypt
```

Now we need to open the LUKS device.
This will map the device and create an entry in /dev/mapper with the given argument as name.

```sh
cryptsetup luksOpen ./test-volume.dmcrypt test-volume
```

Now we need to format the filesystem. Ext4 should be fine.

```sh
mkfs.ext4 -j /dev/mapper/test-volume
```


## Mounting

**ONLY NEEDED ONCE PER MACHINE** 
Create a mount point.

```sh
mkdir /mnt/test-volume
```

Open the encrypted volume as a block device:

```sh
sudo cryptsetup luksOpen ./test-volume.dmcrypt test-volume
```

Mount the filesystem.

```sh
sudo mount /dev/mapper/test-volume /mnt/test-volume
```

You should now be able to read and write to the volume! (Try `df -h` to see the device)


## Unmounting

First unmount the filesystem.

```sh
umount /mnt/test-volume
```

Note that the mapper is still exposing the decrypted volume, so we also need to do:

```sh
cryptsetup luksClose test-volume


