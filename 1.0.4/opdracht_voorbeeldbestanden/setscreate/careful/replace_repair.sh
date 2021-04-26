#!/usr/bin/env bash

# Test alle tekst_nummer directories

if [[ -d GEO ]]; then

    cd BHKV
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/$d-$d/$d/g" {} \; 
    done

    cd ../GEO
    for d in *; do
        echo "Test: $d"
        find ./ -type f -exec  sed -i "s/$d-$d/$d/g" {} \; 
    done

    cd ../LVBB_
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/$d-$d/$d/g" {} \;
    done

    cd ../OZON
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/$d-$d/$d/g" {} \;
    done

    cd ../STOP
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/$d-$d/$d/g" {} \;
    done

    cd ../TPOD
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/$d-$d/$d/g" {} \;
    done

    exit 0
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
    exit 1
fi
