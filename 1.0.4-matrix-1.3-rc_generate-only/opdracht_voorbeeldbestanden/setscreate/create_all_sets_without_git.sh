#!/usr/bin/env bash

# Test alle tekst_nummer directories

datePart=$(date +%Y%m%d%H%M%S)
ONGELDIGE_ZIP=LVBB1001-"$datePart"_v_;
rm opdrachten_gereed/LVBB1001*.zip;
echo "Test: LVBB1001"
echo "ongeldige zip" >  opdrachten_gereed/"$ONGELDIGE_ZIP".zip

if [[ -d BHKV ]]||[[ -d GEO ]]||[[ -d LVBB_ ]]||[[ -d OZON ]]||[[ -d STOP ]]||[[ -d TPOD ]]; then

    cd BHKV
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one_without_git.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../GEO
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one_without_git.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../LVBB_
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one_without_git.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../OZON
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one_without_git.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../STOP
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one_without_git.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../TPOD
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one_without_git.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ..
    exit 0
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
    exit 1
fi
