#!/usr/bin/env bash

# Test alle tekst_nummer directories

if [[ -d GEO ]]; then

cd BHKV
for d in *; do
    if [ -d "$d" ]; then
	  ../setscreate/create_one_set.sh $d;
	fi
done

cd ../GEO
for d in *; do
    if [ -d "$d" ]; then
	  ../setscreate/create_one_set.sh $d;
	fi
done
cd ../LVBB_
for d in *; do
    if [ -d "$d" ]; then
        if [ "$d" = "LVBB4010" ]; then
	       ../setscreate/create_LVBB4010.sh $d;
	    else
	       ../setscreate/create_one_set.sh $d;
	    fi
	fi
done
cd ../OZON
for d in *; do
    if [ -d "$d" ]; then
	  ../setscreate/create_one_set.sh $d;
	fi
done

cd ../STOP
for d in *; do
    if [ -d "$d" ]; then
	  ../setscreate/create_one_set.sh $d;
	fi
done

cd ../TPOD
for d in *; do
    if [ -d "$d" ]; then
	  ../setscreate/create_one_set.sh $d;
	fi
done


cd ..
rm opdrachten_gereed/opdracht_-.zip
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
fi
