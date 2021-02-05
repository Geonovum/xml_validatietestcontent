#!/usr/bin/env bash


FILE_DIR="~/xml_validatietestcontent/1.0.3/opdracht_voorbeeldbestanden/opdrachten_gereed"
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

dt=`date '+%d%m%Y-%H-%M'`
resultfile=~/xml_validatietestcontent/1.0.3/results/result$dt.xml

execute_single_file () {
	file=$1;
	echo $file;
	filenamewithoutextension=${file%.zip}
	conversationid=${filenamewithoutextension#*_}
	result=$(oow-corv $log_level --action versturen --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht valideren "$file")
	#wait ?? seconds for keten to create results
	sleep 20
	#get result
	wget -nv --no-check-certificate $result -O result.xml;
	echo "<envelop>">>$resultfile
	echo "<test>$conversationid</test>">>$resultfile
	cat result.xml>>$resultfile;
	echo "</envelop>">>$resultfile
        rm result
}




cd ~/xml_validatietestcontent/1.0.3/opdracht_voorbeeldbestanden/opdrachten_gereed

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
	for file in *.zip; do
	        execute_single_file $file;
        done
fi
echo "</result>">>$resultfile

cd -
