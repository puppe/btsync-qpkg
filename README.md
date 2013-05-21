# BitTorrent Sync on QNAP NAS devices

## Instructions

This REAMDE will show you how to install BitTorrent Sync on your QNAP
NAS device by first building QPKG packages, which can then be installed
using the QPKG Center application.

**Note**:  
I have only tested this on a QNAP TS-412. It may or may not work on
other devices.

In order to build the packages, you will need to have
[QDK](http://wiki.qnap.com/wiki/QPKG_Development_Guidelines) installed
on your NAS. Download the QDK distribution, unzip it and install it
using QPKG Center.

The next step is to figure out which working directory you are going to
use for the packaging process. `/tmp` and `/root` may not be
sufficiently large. You should pick a directory that is located on the
HDDs. For the QNAP TS-412 at least, `/share/Download` will work fine.
Login to your NAS via ssh and download the files from this repository.

```sh
cd /share/Download # Change to the working directory
curl -kL https://github.com/puppe/btsync-qpkg/archive/master.tar.gz | tar -xz
cd btsync-qpkg-master
```

**Note**:  
Apparently the certificate for the CA of github.com is not installed.
Because of that, we tell curl to ignore certificate warnings by using
the `-k` switch. If you are concerned about MITM attacks, you should
download the files to your local machine and transfer them via ssh to
your NAS. But note also that I have not found a way to download
BitTorrent Sync via a secure connection. And this applies to the QDK
distribution as well. So yeah, if you are paranoid (not necessarily a
bad thing), you are out of luck.

Before building the packages, you should change the password for the
Web UI in file `config/btsync`. If you want to use a different port for
the Web UI, you will have to edit two files. In file
`qpkg.cfg`, change the variable `QPKG_WEB_PORT`. In file
`config/btsync.conf`, edit the line that says `"listen" :
"0.0.0.0:14859"`. You may also want to change the variable `QPKG_VER` in
`qpkg.cfg` such that it reflects the current version number of
BitTorrent Sync. Although I am not quite sure whether this has any
effect at all.

You are now ready to execute `./make.sh`. This will download BitTorrent
Sync and then build the packages using `qbuild`. Once the script has
terminated, you should find the QPKG files in the `build` subdirectory.
Copy these to your local machine and install the appropriate package for
your architecture via QPKG Center. After installing, you can start
BitTorrent Sync from QPKG Center.

If you want to change the configuration of BitTorrent Sync after
installing it, you can edit `btsync.conf`. At least for my device and
setup, this file can be found in
`/share/MD0_DATA/.qpkg/BitTorrentSync/`.

If you have any questions, ask them in the [BitTorrent forum
thread](http://forum.bittorrent.com/topic/19752-bittorrent-sync-on-qnap-nas-devices/)
or file an issue. Pull requests are always welcome!

## Thanks

Parts of the init script are taken from Bittorrent forum user
[sitnin's init script](http://forum.bittorrent.com/topic/17218-qnap-ts-210-installer/#entry43514).
