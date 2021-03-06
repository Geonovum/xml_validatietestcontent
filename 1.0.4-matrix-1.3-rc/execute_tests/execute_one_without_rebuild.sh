#!/usr/bin/env bash


FILE_DIR="../opdracht_voorbeeldbestanden/opdrachten_gereed";
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

mkdir ~/xml_validatietestcontent/results
resultfile=~/xml_validatietestcontent/results/result.xml
dt=`date '+%d-%m-%YT%H:%M:%S:%N'`
logfile=~/xml_validatietestcontent/afbreeklog/ENKELVOUDIG-LOG-$dt.xml
mkdir ~/xml_validatietestcontent/afbreeklog

if [[ -e $1 ]]; then
    file=$1;	
    filename=${file##*/};
    echo $filename;
    filenamewithoutextension=${filename%.zip}
    conversationid=${filenamewithoutextension#*_}
    echo $conversationid;
    action="versturen"
    opdracht="valideren"
    if echo "$file" | grep -q "publiceren"; then
        opdracht="publiceren"
        action="versturen"
    fi
    if echo "$file" | grep -q "valideren"; then
        opdracht="valideren"
        action="versturen"
    fi
    if echo "$file" | grep -q "afbreken"; then
        opdracht="afbreken"
        action="versturen"
    fi
    echo "$dt: $opdracht: $conversationid">$logfile
    echo "De opdracht is: $opdracht"
    echo "De action is: $action"
    result=$(oow-corv $log_level --action $action --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht "$opdracht" "$file")
    echo "executed command is: oow-corv $log_level --action versturen --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht "$opdracht" "$file""
    	
#wait ?? seconds for keten to create results

    for i in {1..45}
    do
        printf '.' > /dev/tty
        sleep 1
    done
    echo ""

    #get result
    rm $resultfile
    echo "De resultaat URL = $result"
    echo " ">$resultfile
    #result is the file in which the URL $result is dumped
    wget -nv --no-check-certificate $result -O result;
    if [ "$opdracht" = "valideren" ]; then
        echo "<envelop>">$resultfile
        echo "<test>$conversationid</test>">>$resultfile
        #the variable result contains the URL
        echo "<result>$result</result>">>$resultfile
        #the file result is dumped into the result file
        cat result>>$resultfile;
        echo "</envelop>">>$resultfile
    fi
    #the file result is queried
    if [ "$opdracht" != "valideren" ]; then
        if echo "$(cat result)" | grep -q "stop:ernst>fout"; then
           beschrijving=$( echo "$(cat result)" | grep -o "<stop:beschrijving>.*</stop:beschrijving>");
           echo "$dt: $opdracht: $conversationid"
           echo "FOUT: $beschrijving";
           echo "FOUT: $beschrijving">>$logfile;
        fi
    fi
    #the file result is removed
    rm result
    echo "---------------"
    echo "$(cat $resultfile)";
    echo "---------------"
    echo "$(cat $logfile)"
    echo "---------------"

else
    echo "$1 is not found, please use an existing zip file"
fi

