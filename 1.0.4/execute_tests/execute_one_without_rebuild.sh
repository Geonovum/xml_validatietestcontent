#!/usr/bin/env bash


FILE_DIR="../opdracht_voorbeeldbestanden/opdrachten_gereed";
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

resultfile=~/xml_validatietestcontent/1.0.4/results/result.xml

if [[ -e $1 ]]; then

file=$1;	
filename=${file##*/};
echo $filename;
filenamewithoutextension=${filename%.zip}
conversationid=${filenamewithoutextension#*_}
result=$(oow-corv $log_level --action versturen --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht valideren "$file")
#wait ?? seconds for keten to create results
sleep 30

#get result
echo "<result>">$resultfile
wget -nv --no-check-certificate $result -O result;
echo "<envelop>">>$resultfile
echo "<test>$conversationid</test>">>$resultfile
cat result>>$resultfile;
echo "</envelop>">>$resultfile
rm result
echo "</result>">>$resultfile

else
    echo "$1 is not found, please use an existing zip file"
fi
