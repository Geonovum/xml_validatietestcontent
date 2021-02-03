#!/usr/bin/env bash

echo ""
echo $1
cd $1;
RANDOM=tr -c -d '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null

directoryname=$1
FILENAMEPART=$directoryname_$RANDOM

#building levering-id-sed-command
	FILENAMEPART="$directoryname-$RANDOM"
	NEWLINE1="<idLevering>id-publicatie-$FILENAMEPART</idLevering>";

	#building AKN-sed
	AKNPART="$directoryname$RANDOM"
	NEWLINE2="<FRBRWork>/akn/nl/bill/gm0297/2019/$AKNPART</FRBRWork>";
	NEWLINE3="<FRBRExpression>/akn/nl/bill/gm0297/2019/$AKNPART/nld@2019-06-27</FRBRExpression>"

	#changing opdracht.xml and creating zipfile
	echo "changing levering_id to $NEWLINE1 in opdracht.xml" 
	sed -i "s|.*idLevering.*|$NEWLINE1|" opdracht.xml
	echo "changing FRBRWork to $NEWLINE2 in akn_nl_bill_gm0297-3520-01.xml" 
	sed -i "s|.*FRBRWork>/akn/nl/bill/gm0297/2019/.*|$NEWLINE2|" akn_nl_bill_gm0297-3520-01.xml
	echo "changing FRBRExpression to $NEWLINE3 in akn_nl_bill_gm0297-3520-01.xml" 
	sed -i "s|.*FRBRExpression>/akn/nl/bill/gm0297/2019/.*|$NEWLINE3|" akn_nl_bill_gm0297-3520-01.xml
	
	#replacing hash in io
	FILES=$(find . -name "*.gml" -print);
	for file in $FILES; do
		SHA512=$(sha512sum $file)
		HASH=${SHA512% *}
		NEWLINE4="<hash>$HASH</hash>"
		filewithoutextension=${file%.gml}
		giofile="$filewithoutextension.xml"
		echo "changing hash to $NEWLINE4 in $giofile" 
		sed -i "s|.*hash>.*|$NEWLINE4|" $giofile
	done
	
	OW=$( grep -xh ".*<FRBRWork>/akn/nl/act/.*" *)
	OW1=${OW%"</FRBRWork>"}
	OLDWORD=${OW1##*/}
	NEWWORD="$directoryname$RANDOM"
	#changing reg456
	FILES=$(grep -l "$OLDWORD" *);
	for file in $FILES; do
		echo "changing /akn/nl/act.....$OLDWORD to /akn/nl/act.....$NEWWORD in $file" 
		sed -i "s|$OLDWORD|$NEWWORD|" $file
	done
	

echo ""
rm ../../opdrachten_gereed/opdracht_$1*.zip;

zip ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip *;

echo ""
git add *;
echo ""
git add ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip;
echo ""
git commit -a -m $1;
echo ""
git push;
cd ..;
