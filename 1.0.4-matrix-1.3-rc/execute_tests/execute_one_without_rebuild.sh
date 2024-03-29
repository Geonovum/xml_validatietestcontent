#!/usr/bin/env bash


FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

mkdir ~/xml_validatietestcontent/results
resultfile=~/xml_validatietestcontent/results/result.xml
dt=`date '+%d%m%Y-T-%H%M%S%N'`
logfile=~/xml_validatietestcontent/afbreeklog/ENKELVOUDIG-LOG-$dt.xml
mkdir ~/xml_validatietestcontent/afbreeklog

if [[ -e $1 ]]; then
    file=$1;	
    filename=${file##*/};
    echo $filename;
    filenamewithoutextension=${filename%.zip}
    conversationid=${filenamewithoutextension}
	validatienummer=$(echo $file| cut -d'_' -f 1)
	echo $validatienummer

    
    echo $conversationid;
    action="versturen"
    opdracht="valideren"
    if echo "$file" | grep -q "_p_"; then
        opdracht="publiceren"
        action="versturen"
    fi
    if echo "$file" | grep -q "_v_"; then
        opdracht="valideren"
        action="versturen"
    fi
    if echo "$file" | grep -q "_v_"; then
        opdracht="valideren"
        action="versturen"
    fi
    if echo "$file" | grep -q "_a_"; then
        opdracht="afbreken"
        action="versturen"
    fi
    echo "$dt: $opdracht: $conversationid">$logfile
    echo "De opdracht is: $opdracht"
    echo "De action is: $action"
    result=$(oow-corv $log_level --action $action --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht "$opdracht" "$file")
    echo "executed command is: oow-corv $log_level --action versturen --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht "$opdracht" "$file""
    	
#wait ?? seconds for keten to create results

 if echo "$file" | grep -q "_v_"  || echo "$file" | grep -q "_p_"; then
    rm result
    totaal=0
    for i in {1..50}
    do
        for j in {1..10}
        do
            printf '.' > /dev/tty
            sleep 1
            totaal=$(($totaal+1))
        done
        wget -nv --no-check-certificate $result -O result;
        echo ""
        if  echo "$(cat result)" | grep -q "uitkomst>" ; then
          break
        else
          sleep 1
        fi
    done
    echo ""
    echo "test-duur: $totaal seconden"
    
    #get result
    rm $resultfile
    echo "De resultaat URL = $result"
    echo " ">$resultfile
    #result is the file in which the URL $result is dumped
    wget -nv --no-check-certificate $result -O result;
    if [ "$opdracht" = "valideren" ]; then
        echo "<envelop>">$resultfile
        echo "<test>$conversationid-$opdracht</test>">>$resultfile
        #the variable result contains the URL
        echo "<result>$result</result>">>$resultfile
        #the file result is dumped into the result file
        cat result>>$resultfile;
        echo "</envelop>">>$resultfile
    fi
    if [ "$validatienummer" = "LVBB1502" ]; then
        if [ echo "$opdracht" = "afbreken" ]; then
            echo "<envelop>">>$resultfile
            echo "<test>$conversationid</test>">>$resultfile
            echo "<tijdsduur>$totaal</tijdsduur>">>$resultfile
            #the variable result contains the URL
            echo "<result>$result</result>">>$resultfile
            #the file result is dumped into the result file
            cat result>>$resultfile;
            echo "</envelop>">>$resultfile
        fi
    fi
    if [ "$validatienummer" = "LVBB1550" ]; then
        if [ echo "$opdracht" = "afbreken" ]; then
            echo "<envelop>">>$resultfile
            echo "<test>$conversationid</test>">>$resultfile
            #the variable result contains the URL
            echo "<result>$result</result>">>$resultfile
            #the file result is dumped into the result file
            cat result>>$resultfile;
            echo "</envelop>">>$resultfile
        fi
    fi
    #the file result is queried
    if [ "$opdracht" != "valideren" ]; then
        if  echo "$(cat result)" | grep -q "stop:ernst>fout" ; then
           beschrijving=$( echo "$(cat result)" | grep -o "<stop:beschrijving>.*</stop:beschrijving>");
           echo "$dt: $opdracht: $conversationid"
           echo "FOUT: $beschrijving";
        fi
    fi
    #the file result is removed
    echo "---------------"
    echo "$(cat result)";
    echo "---------------"
    echo "$(cat $logfile)"
    echo "---------------"
    rm result
fi
else
    echo "$1 is not found, please use an existing zip file"
fi

