#!/usr/bin/env bash


FILE_DIR="~/xml_validatietestcontent/1.0.4/opdracht_voorbeeldbestanden/opdrachten_gereed"
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

mkdir ~/xml_validatietestcontent/results
dt=`date '+%d%m%Y-%H-%M'`
resultfile=~/xml_validatietestcontent/results/result$dt.xml
logfile=~/xml_validatietestcontent/afbreeklog/AFBREEK_LOG-$dt.xml
dt=`date '+%d-%m-%YT%H:%M:%S:%N'`
mkdir ~/xml_validatietestcontent/afbreeklog
echo "<log>">$logfile
echo "<tijdstip>$dt</tijdstip">>$logfile

execute_single_file () {
	file=$1;
	echo $file;
	filenamewithoutextension=${file%.zip}
	conversationid=${filenamewithoutextension}
	validatienummer=$(echo $file| cut -d'_' -f 1)
	echo $validatienummer
	action="versturen"
    opdracht="valideren"
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
    echo "<logging>">>$logfile
    echo "<conversationid>$conversationid</conversationid>">>$logfile
    echo "<tijdstip>$dt</tijdstip>">>$logfile
    echo "<opdracht>$opdracht</opdracht>">>$logfile
    echo "<action>$action</action>">>$logfile
    echo "De opdracht is: $opdracht"
    echo "De action is: $action"
	result=$(oow-corv $log_level --action $action --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht "$opdracht" "$file")
	
	#wait ?? seconds for keten to create results
	#for i in {1..90}
    #do
    #    printf '.' > /dev/tty
    #    sleep 1
    #done
    #echo ""
    
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
    echo "De resultaat URL = $result"
    #result is the file in which the URL $result is dumped
    wget -nv --no-check-certificate $result -O result;
    #alleen bij valideren entree in results
    if [ "$opdracht" = "valideren" ]; then
        echo "<envelop>">>$resultfile
        echo "<test>$conversationid-$opdracht</test>">>$resultfile
        echo "<tijdsduur>$totaal</tijdsduur>">>$resultfile
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
    #the result is queried
    if [ "$opdracht" != "valideren" ]; then
        if echo "$(cat result)" | grep -q "stop:ernst>fout"; then
           beschrijving=$( echo "$(cat result)" | grep -o "<stop:beschrijving>.*</stop:beschrijving>");
           echo "$dt: $opdracht: $conversationid"
           echo "------------------------------------------"
           echo "FOUT: $beschrijving";
           echo "------------------------------------------"
           echo "<beschrijving>$beschrijving</beschrijving>">>$logfile;
        fi
    fi
    #the file result is removed
    rm result
    echo "</logging>">>$logfile
}




cd ~/xml_validatietestcontent/1.0.4-matrix-1.3-rc/opdracht_voorbeeldbestanden/opdrachten_gereed

echo "<result>">$resultfile
if [[ -n $FINDNUMBER ]]; then
        echo "Processing with argument $FINDNUMBER";

        #find directory and test if is a directory or wildcard
        NUMFILE=$(ls *$FINDNUMBER*.zip|wc -l)
        if [[ $NUMFILE -eq 0 ]]; then
                echo "No files found with wildcard *$FINDNUMBER*"
        else
                FILES=$(ls *$FINDNUMBER*.zip);
                for file in $FILES; do
	                execute_single_file $file;
                done
        fi
else
	for file in `ls *.zip| sort -g`; do
	        execute_single_file $file;
        done
fi
echo "</result>">>$resultfile
echo "</log>">>$logfile

cd -
