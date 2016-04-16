#!/bin/sh

if [[ $1 = "" ]]; then
    command -v qbuild >/dev/null 2>&1 || { echo >&2 "qbuild is required in order to build the packages. Aborting."; exit 1; }

    echo "Downloading BitTorrent Sync archive files"
    mkdir -p downloads
    cd downloads
    
    curl -kO https://download-cdn.getsync.com/2.3.6/linux-arm/BitTorrent-Sync_arm.tar.gz
    
    curl -kO https://download-cdn.getsync.com/2.3.6/linux-i386/BitTorrent-Sync_i386.tar.gz
    
    curl -kO https://download-cdn.getsync.com/2.3.6/linux-x64/BitTorrent-Sync_x64.tar.gz
    
    cd ..

    sha256sum -c checksums.txt > /dev/null
    if [[ $? == 0 ]] ; then
        echo "Checksums OK"
    else
        echo "At least one computed checksum did NOT match"
        exit 1
    fi

    for dir in arm-x09 arm-x19 x86 x86_64 ; do
        mkdir -p $dir
    done

    echo "Extracting archives"
    tar -C arm-x09 -zxf downloads/BitTorrent-Sync_arm.tar.gz
    cp -r arm-x09/* arm-x19/
    tar -C x86 -zxf downloads/BitTorrent-Sync_i386.tar.gz
    tar -C x86_64 -zxf downloads/BitTorrent-Sync_x64.tar.gz

    rm -r downloads

    echo "Building packages"
    qbuild --exclude-from exclude

    if [[ $? == 0 ]] ; then
        echo "Done"
    else
        echo "Some error occurred, check the troubleshooting section of the README, or post in the forum thread."
    fi
fi

if [[ $1 = "clean" ]]; then
    echo "Deleting downloaded files"
    rm -rf arm*
    rm -rf x86*
    echo "Done"
fi
