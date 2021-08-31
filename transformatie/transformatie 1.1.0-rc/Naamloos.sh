if [[ -d BHKV ]]||[[ -d GEO ]]||[[ -d LVBB_ ]]||[[ -d OZON ]]||[[ -d STOP ]]||[[ -d TPOD ]]; then

    cd BHKV
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../GEO
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../LVBB_
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../OZON
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../STOP
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one.sh $d)
        if [[ $? -ne 0 ]] ; then 
            exit 1 
        fi
    done

    cd ../TPOD
    for d in *; do
        echo "Test: $d"
        cmd_output=$(../setscreate/unique-one.sh $d)
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