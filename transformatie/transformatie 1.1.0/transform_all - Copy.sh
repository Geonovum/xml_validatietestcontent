#!/usr/bin/env bash


mkdir ../1.1.0

    mkdir ../1.1.0/LVBB_
    cd ../1.0.4/LVBB_
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

    cd ..
    exit 0
else
    echo "Please start transformer directory."
    exit 1
fi