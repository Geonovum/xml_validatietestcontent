#!/usr/bin/env bash


FILE_DIR="../opdracht_voorbeeldbestanden/opdrachten_gereed";
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

resultfile=~/xml_validatietestcontent/results/result.xml

if [[ -e $1 ]]; then
    file=$1;	
    filename=${file##*/};
    echo $filename;
    filenamewithoutextension=${filename%.zip}
    conversationid=${filenamewithoutextension#*_}
    echo $conversationid;
    action="valideren"
    if [[ $file == *-0.zip ]];then
        action="publiceren"
    fi
    if [[ $file == *-afbreek.zip ]];then
        action="afbreken"
    fi
    result=$(oow-corv $log_level --action versturen --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht "$action" "$file")
	
#wait ?? seconds for keten to create results

    for i in {1..45}
    do
        printf '.' > /dev/tty
        sleep 1
    done
    echo ""

#get result
    echo " ">$resultfile
    wget -nv --no-check-certificate $result -O result;
    echo "<envelop>">>$resultfile
    echo "<test>$conversationid</test>">>$resultfile
    cat result>>$resultfile;
    echo "</envelop>">>$resultfile
    rm result

else
    echo "$1 is not found, please use an existing zip file"
fi
