#!/usr/bin/env bash

# Test alle tekst_nummer directories

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

    rm ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_AFBREEK*.zip;

    $datePart=$(date +%Y%m%d%H%M%S)
    ONGELDIGE_ZIP="LVBB1001-$datePart";
    rm ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_LVBB1001*.zip;
    echo "ongeldige zip" >  ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$ONGELDIGE_ZIP.zip
    
    cd ..
    exit 0
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
    exit 1
fi
