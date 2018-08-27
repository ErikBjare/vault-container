#!/bin/bash

sudo cryptsetup luksOpen ./vault.dmcrypt vault
sudo mount /dev/mapper/vault /mnt/vault
