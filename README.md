# BitTorrent Sync on QNAP NAS devices

This REAMDE explains how to install BitTorrent Sync on your QNAP
NAS device by first building QPKG packages, which can then be installed
using the QPKG Center application.

## Compatible Devices

* TS-219P
* TS-259Pro (see [this forum post](http://forum.bittorrent.com/topic/19752-bittorrent-sync-on-qnap-nas-devices/#entry51722)
  and the troubleshooting section)
* TS-269L
* TS-412
* TS-420
* TS-469L

The following instructions should work for a wide range of QNAP NAS
devices. If a device is missing, I just have not tested it or heard
from users about it. Please try and post your results to the [BitTorrent
forum
thread](http://forum.bittorrent.com/topic/19752-bittorrent-sync-on-qnap-nas-devices/)
or make a pull request.

## Instructions

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
your NAS.

Before building the packages, you should change the password for the Web
UI in file `config/btsync.conf`. If you want to use a different port for
the Web UI, you will have to edit two files. In file `qpkg.cfg`, change
the variable `QPKG_WEB_PORT`. In file `config/btsync.conf`, edit the
line that says `"listen" : "0.0.0.0:14859"`.

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

## Troubleshooting

### Error upon executing ./make.sh

*Problem*:  
You get the following error when you execute ./make.sh

```sh
./make.sh: /usr/bin/qbuild: /bin/bash: bad interpreter: No such file or directory
```

*Solution*:  
Create a symbolic link that points to `/bin/sh`, then try again, and
finally remove the link.

```sh
ln -s /bin/sh /bin/bash
./make.sh
rm /bin/bash
```

Thanks to [bakanach](http://forum.bittorrent.com/topic/19752-bittorrent-sync-on-qnap-nas-devices/#entry51722)!

## Thanks

Parts of the init script are taken from Bittorrent forum user
[sitnin's init script](http://forum.bittorrent.com/topic/17218-qnap-ts-210-installer/#entry43514).
