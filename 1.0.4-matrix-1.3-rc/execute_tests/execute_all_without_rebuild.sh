#!/usr/bin/env bash


FILE_DIR="~/xml_validatietestcontent/1.0.4/opdracht_voorbeeldbestanden/opdrachten_gereed"
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

dt=`date '+%d%m%Y-%H-%M'`
resultfile=~/xml_validatietestcontent/results/result$dt.xml

execute_single_file () {
	file=$1;
	echo $file;
	filenamewithoutextension=${file%.zip}
	conversationid=${filenamewithoutextension#*_}
	action="valideren"
	if [[ $file == *-0 ]];then
	   action="publiceren"
	fi
	if [[ $file == *-afbreek ]];then
        action="publiceren"
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
	wget -nv --no-check-certificate $result -O result;
	echo "<envelop>">>$resultfile
	echo "<test>$conversationid</test>">>$resultfile
	echo "<result>$result</result>">>$resultfile
	cat result>>$resultfile;
	echo "</envelop>">>$resultfile
    rm result
}




cd ~/xml_validatietestcontent/1.0.4/opdracht_voorbeeldbestanden/opdrachten_gereed

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

cd -