#!/bin/bash

mkdir -p /tmp/rcopy

if curl -s -I http://192.168.56.1:8377/getimg | grep 'image/png' ; then
    echo "download"
    curl -s  http://192.168.56.1:8377/getimg  -o /tmp/rcopy/test.png
    exit
fi

echo "noimg"