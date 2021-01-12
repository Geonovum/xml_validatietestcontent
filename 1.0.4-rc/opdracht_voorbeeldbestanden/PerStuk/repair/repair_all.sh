#!/usr/bin/sh

# Test alle tekst_nummer directories

cd ..
for d in *; do
    if [ -d "$d" ]; then
	  repair/repair_one.sh $d;
	fi
done
rm repair.zip
