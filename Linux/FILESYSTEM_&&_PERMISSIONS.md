# Introduction to the Linux Filesystem Hierarchy Standard (FHS)

Linux uses a structured directory layout known as the Filesystem Hierarchy Standard (FHS). The FHS defines how directories are organized and what type of files should be stored in each directory.

At the top of this structure is the root directory `/`, which serves as the starting point of the entire filesystem. The structure resembles a tree, where `/` is the trunk and all other directories branch out from it.

Below are some important directories in a typical Linux system:

## / — Root Directory

The top-level directory in Linux. All other directories and files exist under this directory.

## /etc — Configuration Files

Contains system-wide configuration files and settings required by the operating system and installed services.

Examples:

- Network configuration files

- Service configuration files

- System initialization scripts

## /bin — Essential User Binaries

Contains essential command-line utilities needed for basic system operation. These commands are available to all users.

Examples:

- ls
- cp
- mv
- cat
- /sbin — System Binaries

Contains important system administration commands, typically used by the root user for system maintenance.

Examples:

- reboot
- shutdown
- mount
- ifconfig (on older systems)
- /lib — Shared Libraries

Stores shared libraries required by programs in /bin and /sbin. These are similar to DLL files in Windows.

## /dev — Device Files

Contains device files that represent hardware devices attached to the system (e.g., disks, USB drives, terminals). In Linux, devices are treated as files.

Examples:

- /dev/sda (hard drive)
- /dev/tty (terminal)

## /home — User Home Directories

Contains personal directories for regular users on the system.

Example:

- /home/john

- /home/mary

Each user stores personal files, downloads, and configurations here.

## /root — Root User Home Directory

The home directory for the root (administrator) user. It is separate from /home for security and system integrity reasons.

- /mnt — Mount Point for Temporary Filesystems

Used for temporarily mounting storage devices such as external drives or network filesystems.

Example:

Mounting a USB drive manually.

## /var — Variable Data

Contains files that change frequently while the system is running.

Examples:

- Log files (/var/log)
- Mail files
- Print spool files
- Cache files
