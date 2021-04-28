#!/usr/bin/env bash

# Test alle tekst_nummer directories

if [[ -d GEO ]]; then

    cd BHKV
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/GoedeGebieden-$d/GoedeGebieden/g" {} \; 
         find ./ -type f -exec  sed -i "s/GoedeGebieden2-$d/GoedeGebieden2/g" {} \;
         find ./ -type f -exec  sed -i "s/regelingsgebied-$d/regelingsgebied/g" {} \;
    done

    cd ../GEO
    for d in *; do
        echo "Test: $d"
        find ./ -type f -exec  sed -i "s/GoedeGebieden-$d/GoedeGebieden/g" {} \;
        find ./ -type f -exec  sed -i "s/GoedeGebiede2-$d/GoedeGebieden2/g" {} \;
        find ./ -type f -exec  sed -i "s/regelingsgebied-$d/regelingsgebied/g" {} \; 
    done

    cd ../LVBB_
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/GoedeGebieden-$d/GoedeGebieden/g" {} \;
         find ./ -type f -exec  sed -i "s/GoedeGebieden2-$d/GoedeGebieden2/g" {} \;
         find ./ -type f -exec  sed -i "s/regelingsgebied-$d/regelingsgebied/g" {} \;
    done

    cd ../OZON
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/GoedeGebieden-$d/GoedeGebieden/g" {} \;
         find ./ -type f -exec  sed -i "s/GoedeGebieden2-$d/GoedeGebieden2/g" {} \;
         find ./ -type f -exec  sed -i "s/regelingsgebied-$d/regelingsgebied/g" {} \;
    done

    cd ../STOP
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/GoedeGebieden-$d/GoedeGebieden/g" {} \;
         find ./ -type f -exec  sed -i "s/GoedeGebieden2-$d/GoedeGebieden2/g" {} \;
         find ./ -type f -exec  sed -i "s/regelingsgebied-$d/regelingsgebied/g" {} \;
    done

    cd ../TPOD
    for d in *; do
        echo "Test: $d"
         find ./ -type f -exec  sed -i "s/GoedeGebieden-$d/GoedeGebieden/g" {} \;
         find ./ -type f -exec  sed -i "s/GoedeGebieden2-$d/GoedeGebieden2/g" {} \;
         find ./ -type f -exec  sed -i "s/regelingsgebied-$d/regelingsgebied/g" {} \;
    done

    exit 0
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
    exit 1
fi
