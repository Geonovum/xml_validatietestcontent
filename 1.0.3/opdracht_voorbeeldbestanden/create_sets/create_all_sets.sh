#!/usr/bin/sh

# Test alle tekst_nummer directories


for d in *; do
    if [ -d "$d" ]; then
	  ../create_sets/create_one_set.sh $d;
	fi
done
rm ../opdrachten_gereed/opdracht_create_sets*.zip
