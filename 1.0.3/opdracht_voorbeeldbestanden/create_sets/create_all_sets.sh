#!/usr/bin/sh

# Test alle tekst_nummer directories

cd GEO
for d in *; do
    if [ -d "$d" ]; then
	  ../create_sets/create_one_set.sh $d;
	fi
done
cd ../LVBB_
for d in *; do
    if [ -d "$d" ]; then
	  ../create_sets/create_one_set.sh $d;
	fi
done
cd ../OZON
for d in *; do
    if [ -d "$d" ]; then
	  ../create_sets/create_one_set.sh $d;
	fi
done
cd ../TPOD
for d in *; do
    if [ -d "$d" ]; then
	  ../create_sets/create_one_set.sh $d;
	fi
done
cd ..