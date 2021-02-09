#!/usr/bin/env bash

GEMEENTE="gm0297"

echo "Script wordt uitgevoerd voor gemeente gm0297"

echo ""
echo $1
cd $1;
RANDOM=tr -c -d '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null

directoryname=$1
FILENAMEPART=$directoryname_$RANDOM


#building levering-id-sed-command
	FILENAMEPART="$directoryname-$RANDOM"
	NEWLINE1="<idLevering>id-publicatie-$FILENAMEPART</idLevering>";
	NEWLINE6="<sl:leveringsId>id-publicatie-$FILENAMEPART</sl:leveringsId>";

	#building AKN-sed
	AKNPART="$directoryname$RANDOM"
	NEWLINE2="<FRBRWork>/akn/nl/bill/$GEMEENTE/2019/$AKNPART</FRBRWork>";
	NEWLINE3="<FRBRExpression>/akn/nl/bill/$GEMEENTE/2019/$AKNPART/nld@2019-06-27</FRBRExpression>"
	
	#changing opdracht.xml and creating zipfile
	echo "changing levering_id to $NEWLINE1 in opdracht.xml" 
	sed -i "s|.*idLevering.*|$NEWLINE1|" opdracht.xml
	echo "changing levering_id to $NEWLINE6 in owRegelingsgebied.xml" 
	sed -i "s|.*idLevering.*|$NEWLINE6|" owRegelingsgebied.xml
	echo "changing levering_id to $NEWLINE6 in owLocatieRegelingsgebied.xml" 
	sed -i "s|.*idLevering.*|$NEWLINE6|" owLocatieRegelingsgebied.xml
	echo "changing levering_id to $NEWLINE6 in owLocaties-Gemeentestad.xml" 
	sed -i "s|.*idLevering.*|$NEWLINE6|" owLocaties-Gemeentestad.xml
	echo "changing levering_id to $NEWLINE6 in owRegeltekst-Gemeentestad.xml" 
	sed -i "s|.*idLevering.*|$NEWLINE6|" owRegeltekst-Gemeentestad.xml
	echo "changing FRBRWork to $NEWLINE2 in akn_nl_bill_gm0297-3520-01.xml" 
	sed -i "s|.*FRBRWork>/akn/nl/bill/$GEMEENTE/2019/.*|$NEWLINE2|" akn_nl_bill_gm0297-3520-01.xml
	echo "changing FRBRExpression to $NEWLINE3 in akn_nl_bill_gm0297-3520-01.xml" 
	sed -i "s|.*FRBRExpression>/akn/nl/bill/$GEMEENTE/2019/.*|$NEWLINE3|" akn_nl_bill_gm0297-3520-01.xml
	
	OW=$( grep -xh ".*<FRBRWork>/akn/nl/act/.*" *)
	OW1=${OW%"</FRBRWork>"}
	OLDWORD=${OW1##*/}
	NEWWORD="$directoryname$RANDOM"
	#changing reg456 or similar
	FILES=$(grep -l "$OLDWORD" *);
	for file in $FILES; do
		echo "changing /akn/nl/act.....$OLDWORD to /akn/nl/act.....$NEWWORD in $file" 
		sed -i "s|$OLDWORD|$NEWWORD|" $file
	done
	
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
		echo "changing heeftGeboorteregeling to <heeftGeboorteregeling>/akn/nl/act/$GEMEENTE/2019/$NEWWORD</heeftGeboorteregeling> in $giofile" 
		sed -i "s|.*heeftGeboorteregeling>/akn/nl/act/$GEMEENTE/2019/.*|<heeftGeboorteregeling>/akn/nl/act/$GEMEENTE/2019/$NEWWORD</heeftGeboorteregeling>|" $giofile
	done
	#building doel-seds
	DOELPART="$directoryname$RANDOM"
    NEWLINE5="<DoelID>/join/id/proces/$GEMEENTE/2019/$DOELPART</DoelID>";
	NEWLINE6="<doel>/join/id/proces/$GEMEENTE/2019/$DOELPART</doel>"

	echo "changing <DoelID> to $NEWLINE5 in manifest-ow.xml" 
	sed -i "s|.*DoelID>/join/id/proces/$GEMEENTE.*|$NEWLINE5|" manifest-ow.xml
	echo "changing <doel> to $NEWLINE6 in akn_nl_bill_gm0297-3520-01.xml" 
	sed -i "s|.*doel>/join/id/proces/$GEMEENTE.*|$NEWLINE6|" akn_nl_bill_gm0297-3520-01.xml
	

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
