#!/usr/bin/env bash

if [ -d "$1" ]; then
    echo $1
    #mkdir ../Orig
    rm ../Orig/*
    cd $1;
    cp * ../../Orig
    rm *
    cd -
    cp ../setscreate/default_artikel_lvbb/* $1
else
    echo "Testset does not exist or Please start from directory opdracht_voorbeeldbestanden/XXX."
fi