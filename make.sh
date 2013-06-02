#!/bin/sh

if [[ $1 = "" ]]; then
    command -v qbuild >/dev/null 2>&1 || { echo >&2 "qbuild is required in order to build the packages. Aborting."; exit 1; }
    echo "Downloading files"
    mkdir -p arm-x09
    curl http://btsync.s3-website-us-east-1.amazonaws.com/btsync_arm.tar.gz | tar -zx -C arm-x09
    mkdir -p arm-x19
    curl http://btsync.s3-website-us-east-1.amazonaws.com/btsync_arm.tar.gz | tar -zx -C arm-x19
    mkdir -p x86
    curl http://btsync.s3-website-us-east-1.amazonaws.com/btsync_i386.tar.gz | tar -zx -C x86
    mkdir -p x86_64
    curl http://btsync.s3-website-us-east-1.amazonaws.com/btsync_x64.tar.gz | tar -zx -C x86_64

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
