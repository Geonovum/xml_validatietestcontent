#!/usr/bin/env bash

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
	sed -i "s|.*idLevering.*|$NEWLINE1|" opdracht.xml
	sed -i "s|.*FRBRWork>/akn/nl/bill/gm0297/2019/.*|$NEWLINE2|" akn_nl_bill_gm0297-3520-01.xml
	sed -i "s|.*FRBRExpression>/akn/nl/bill/gm0297/2019/.*|$NEWLINE3|" akn_nl_bill_gm0297-3520-01.xml

#NEWLINE="<idLevering>id-publicatie-$FILENAMEPART</idLevering>";
#sed -i "s|.*idLevering.*|$NEWLINE|" opdracht.xml
rm ../../opdrachten_gereed/opdracht_$1*.zip;

zip ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip *;

git add *;
git add ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip;
git commit -a -m $1;git push;
cd ..;
