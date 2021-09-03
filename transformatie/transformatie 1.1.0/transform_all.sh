#!/usr/bin/env bash


mkdir ../1.1.0
if [[ -d ../1.0.4/BHKV ]]||[[ -d ../1.0.4/GEO ]]||[[ -d ../1.0.4/LVBB_ ]]||[[ -d ../1.0.4/OZON ]]||[[ -d ../1.0.4/STOP ]]||[[ -d ../1.0.4/TPOD ]]; then

    mkdir ../1.1.0/BHKV
    cd ../1.0.4/BHKV
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../../transformatie\ 1.1.0/transform.sh $d)
        if [[ $? -ne 0 ]] ; then 
            echo $cmd_output
            exit 1 
        fi
    done

    mkdir ../../1.1.0/GEO
    cd ../../1.0.4/GEO
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../../transformatie\ 1.1.0/transform.sh $d)
        if [[ $? -ne 0 ]] ; then 
            echo $cmd_output
            exit 1 
        fi
    done

    mkdir ../../1.1.0/LVBB_
    cd ../../1.0.4/LVBB_
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../../transformatie\ 1.1.0/transform.sh $d)
        if [[ $? -ne 0 ]] ; then 
            echo $cmd_output
            exit 1 
        fi
    done

    mkdir ../../1.1.0/OZON
    cd ../../1.0.4/OZON
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../../transformatie\ 1.1.0/transform.sh $d)
        if [[ $? -ne 0 ]] ; then 
            echo $cmd_output
            exit 1 
        fi
    done

    mkdir ../../1.1.0/STOP
    cd ../../1.0.4/STOP
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../../transformatie\ 1.1.0/transform.sh $d)
        if [[ $? -ne 0 ]] ; then 
            echo $cmd_output
            exit 1 
        fi
    done

    mkdir ../../1.1.0/TPOD
    cd ../../1.0.4/TPOD
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../../transformatie\ 1.1.0/transform.sh $d)
        if [[ $? -ne 0 ]] ; then 
            echo $cmd_output
            exit 1 
        fi
    done

    cd ..
    exit 0
else
    echo "Please start transformer directory."
    exit 1
fi