#!/usr/bin/env bash

# Test alle tekst_nummer directories

if [[ -d GEO ]]; then

cd GEO
for d in *; do
    if [ -d "$d" ]; then
	  cp ../create_sets/careful/copy_files/* $d;
	fi
done
cd ../LVBB_
for d in *; do
    if [ -d "$d" ]; then
	  cp ../create_sets/careful/copy_files/* $d;
	fi
done
cd ../OZON
for d in *; do
    if [ -d "$d" ]; then
	  cp ../create_sets/careful/copy_files/* $d;
	fi
done
cd ../TPOD
for d in *; do
    if [ -d "$d" ]; then
	  cp ../create_sets/careful/copy_files/* $d;
	fi
done
cd ..
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
fi
