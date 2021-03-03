#!/usr/bin/env bash

GEMEENTE="gm0297"

function substring() {
    local str="$1" start="${2}" end="${3}"
    
    if [[ "$start" == "" ]]; then start="0"; fi
    if [[ "$end"   == "" ]]; then end="${#str}"; fi
    
    local length="((${end}-${start}+1))"
    
    echo "${str:${start}:${length}}"
} 

if [ -d "$1" ]; then
    echo "Script wordt uitgevoerd voor gemeente gm0297"
    echo ""
    echo $1
    cd $1;
    RANDOM=tr -c -d '[:alnum:]' < /dev/urandom  | dd bs=4 count=16 2>/dev/null

    #building levering-id-sed-command
    directoryname=$(echo $1|sed -e 's/\.//g')
	FILENAMEPART="$directoryname-$RANDOM"
	NEWLINE1="<idLevering>id-publicatie-$FILENAMEPART</idLevering>";
	echo "changing levering_id to $NEWLINE1 in opdracht.xml" 
	sed -i "s|.*idLevering.*|$NEWLINE1|" opdracht.xml
	#changing leveringid in opdracht.xml
	NEWLINE6="<sl:leveringsId>id-publicatie-$FILENAMEPART</sl:leveringsId>";
	#changing leveringid in ow bestanden
	echo "changing levering_id to $NEWLINE6 in owRegelingsgebied.xml" 
	sed -i "s|.*leveringsId.*|$NEWLINE6|" owRegelingsgebied.xml
	if [ -f "owLocaties-Gemeentestad.xml"]; then
	   echo "changing levering_id to $NEWLINE6 in owLocaties-Gemeentestad.xml" 
	   sed -i "s|.*leveringsId.*|$NEWLINE6|" owLocaties-Gemeentestad.xml
	fi
	if [ -f "owRegeltekst-Gemeentestad.xml"]; then
	   echo "changing levering_id to $NEWLINE6 in owRegeltekst-Gemeentestad.xml" 
	   sed -i "s|.*leveringsId.*|$NEWLINE6|" owRegeltekst-Gemeentestad.xml
	fi

	#building AKN-sed
	AKNPART="$directoryname$RANDOM"
	NEWLINE2="<FRBRWork>/akn/nl/bill/$GEMEENTE/2019/$AKNPART</FRBRWork>";
	NEWLINE3="<FRBRExpression>/akn/nl/bill/$GEMEENTE/2019/$AKNPART/nld@2019-06-27</FRBRExpression>"
	BESLUIT=""
	if [ -f "akn_nl_bill_gm0297-3520-01.xml"]; then
	   BESLUIT="akn_nl_bill_gm0297-3520-01.xml"
	fi
	if [ -f "Mutatie_besluit_eerstewijziging.xml"]; then
	   BESLUIT="Mutatie_besluit_eerstewijziging.xml"
	fi
	#changing besluit ID in besluit.
	echo "changing FRBRWork to $NEWLINE2 in $BESLUIT" 
	sed -i "s|.*FRBRWork>/akn/nl/bill/$GEMEENTE/2019/.*|$NEWLINE2|" "$BESLUIT"
	echo "changing FRBRExpression to $NEWLINE3 in akn_nl_bill_gm0297-3520-01.xml" 
	sed -i "s|.*FRBRExpression>/akn/nl/bill/$GEMEENTE/2019/.*|$NEWLINE3|" "$BESLUIT"
	
	#changing regelingsid en verdere voorkomens
	OW=$( grep -xh ".*<FRBRWork>/akn/nl/act/.*" *)
	OW1=${OW%"</FRBRWork>"}
	OLDWORD=${OW1##*/}
	NEWWORD="$directoryname$RANDOM"
	FILES=$(grep -l "$OLDWORD" *);
	for file in $FILES; do
		echo "changing /akn/nl/act.....$OLDWORD to /akn/nl/act.....$NEWWORD in $file" 
		sed -i "s|$OLDWORD|$NEWWORD|" $file
	done
	FILES=$(find . -name "*.gml" -print);
	for file in $FILES; do
		filewithoutextension=${file%.gml}
		giofile="$filewithoutextension.xml"
		echo "changing heeftGeboorteregeling to <heeftGeboorteregeling>/akn/nl/act/$GEMEENTE/2019/$NEWWORD</heeftGeboorteregeling> in $giofile" 
		sed -i "s|.*heeftGeboorteregeling>/akn/nl/act/$GEMEENTE/2019/.*|<heeftGeboorteregeling>/akn/nl/act/$GEMEENTE/2019/$NEWWORD</heeftGeboorteregeling>|" $giofile
	done

	
	#changing juridische regel en verdere voorkomens
	OW=$( grep -xh ".*<r:identificatie>.*" *|grep "juridischeregel")
	OW1=${OW%"</r:identificatie>"}
	OLDWORD=${OW1##*>}
	RANDOM1=$( date +%s%N | cut -b1-17)
    NEWWORD=$(echo $OLDWORD | cut -d '.' -f1).$(echo $OLDWORD | cut -d '.' -f2).$(echo $OLDWORD | cut -d '.' -f3).$RANDOM1
	FILES=$(grep -l "$OLDWORD" *);
	for file in $FILES; do
		echo "changing $OLDWORD to $NEWWORD in $file" 
		sed -i "s|$OLDWORD|$NEWWORD|" $file
	done
	
	#changing regeltekst en verdere voorkomens
	OW=$( grep -xh ".*<r:identificatie>.*" *|grep "regeltekst")
	OW1=${OW%"</r:identificatie>"}
	OLDWORD=${OW1##*>}
	RANDOM1=$( date +%s%N | cut -b1-17)
    NEWWORD=$(echo $OLDWORD | cut -d '.' -f1).$(echo $OLDWORD | cut -d '.' -f2).$(echo $OLDWORD | cut -d '.' -f3).$RANDOM1
	FILES=$(grep -l "$OLDWORD" *);
	for file in $FILES; do
		echo "changing $OLDWORD to $NEWWORD in $file" 
		sed -i "s|$OLDWORD|$NEWWORD|" $file
	done

    #changing locatie en verdere voorkomens
	OW=$( grep -xh ".*<l:identificatie>.*" *)
	OW1=${OW%"</l:identificatie>"}
	OLDWORD=${OW1##*>}
	RANDOM1=$( date +%s%N | cut -b1-17)
    NEWWORD=$(echo $OLDWORD | cut -d '.' -f1).$(echo $OLDWORD | cut -d '.' -f2).$(echo $OLDWORD | cut -d '.' -f3).$RANDOM1
	FILES=$(grep -l "$OLDWORD" *);
	for file in $FILES; do
		echo "changing $OLDWORD to $NEWWORD in $file" 
		sed -i "s|$OLDWORD|$NEWWORD|" $file
	done

    #changing regelingsgebied en verdere voorkomens	
	OW=$( grep -xh ".*<rg:identificatie>.*" *)
	OW1=${OW%"</rg:identificatie>"}
	OLDWORD=${OW1##*>}
	RANDOM1=$( date +%s%N | cut -b1-17)
    NEWWORD=$(echo $OLDWORD | cut -d '.' -f1).$(echo $OLDWORD | cut -d '.' -f2).$(echo $OLDWORD | cut -d '.' -f3).$RANDOM1
	#changing reg456 or similar
	FILES=$(grep -l "$OLDWORD" *);
	for file in $FILES; do
		echo "changing $OLDWORD to $NEWWORD in $file" 
		sed -i "s|$OLDWORD|$NEWWORD|" $file
	done


	
	#replacing hash in io
	FILES=$(find . -name "*.gml" -print);
	for file in $FILES; do
		SHA512=$(sha512sum $file)
		HASH=$(echo ${SHA512% *}|xargs)
		 NEWLINE4="<hash>$HASH</hash>"
		filewithoutextension=${file%.gml}
		giofile="$filewithoutextension.xml"
		echo "changing hash to $NEWLINE4 in $giofile" 
		sed -i "s|.*hash>.*|$NEWLINE4|" $giofile
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
    rm ../../opdrachten_gereed/opdracht_$directoryname*.zip;
    
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
else
    echo "Please start from directory opdracht_voorbeeldbestanden/XXX."
fi
