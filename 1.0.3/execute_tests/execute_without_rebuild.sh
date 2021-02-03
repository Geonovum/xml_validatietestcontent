#!/usr/bin/env bash


FILE_DIR="../opdracht_voorbeeldbestanden/opdrachten_gereed";
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

file=$1;	
filename=${file##*/};
echo $filename;
filenamewithoutextension=${filename%.zip}
conversationid=${filenamewithoutextension#*_}
result=$(oow-corv $log_level --action versturen --levering_id "id-publicatie-$conversationid" --conversation_id "$conversationid" --oin 00000001812579446000 --opdracht valideren "$file")
#wait 10 seconds for keten to create results
sleep 10
#get result
wget -nv --no-check-certificate $result -O result.xml;
