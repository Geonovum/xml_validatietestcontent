#!/usr/bin/env bash

GEMEENTE="gm0297"

echo "$0"

function substring() {
    local str="$1" start="${2}" end="${3}"
    
    if [[ "$start" == "" ]]; then start="0"; fi
    if [[ "$end"   == "" ]]; then end="${#str}"; fi
    
    local length="((${end}-${start}+1))"
    
    echo "${str:${start}:${length}}"
} 

function replaceIdsSimple() {
	OW=$( grep -xh ".*<$1>.*" *)
	if [ "$OW" != "" ]; then
	   for OW1 in $OW; do
    	  OW2=${OW1%"</$1>"}
	      OLDWORD=${OW2##*>}
	      RANDOM1=$( date +%s%N | cut -b1-17)
          NEWWORD=$(echo $OLDWORD | cut -d '.' -f1).$(echo $OLDWORD | cut -d '.' -f2).$(echo $OLDWORD | cut -d '.' -f3).$RANDOM1
	      FILES=$(grep -l "$OLDWORD" *);
	      for file in $FILES; do
	         echo "changing $OLDWORD to $NEWWORD in $file" 
    	     sed -i "s|$OLDWORD|$NEWWORD|" $file
	      done
	   done
	fi
}

function replaceIdsGUID() {
	OW=$( grep -xh ".*<$1>.*" *)
	if [ "$OW" != "" ]; then
	   for OW1 in $OW; do
    	  OW2=${OW1%"</$1>"}
	      OLDWORD=${OW2##*>}
          cd ../../setscreate/lib
          NEWWORD=$(java -jar uuidgen.jar -q)
          cd -
	      FILES=$(grep -l "$OLDWORD" *);
	      for file in $FILES; do
	         echo "changing $OLDWORD to $NEWWORD in $file" 
    	     sed -i "s|$OLDWORD|$NEWWORD|" $file
	      done
	   done
	fi
}

function replaceIdsComplex() {
	OW=$( grep -xh ".*<$1>.*" *|grep "$2")
	if [ "$OW" != "" ]; then
	   for OW1 in $OW; do
    	  OW2=${OW1%"</$1>"}
	      OLDWORD=${OW2##*>}
	      RANDOM1=$( date +%s%N | cut -b1-17)
          NEWWORD=$(echo $OLDWORD | cut -d '.' -f1).$(echo $OLDWORD | cut -d '.' -f2).$(echo $OLDWORD | cut -d '.' -f3).$RANDOM1
	      FILES=$(grep -l "$OLDWORD" *);
	      for file in $FILES; do
	         echo "changing $OLDWORD to $NEWWORD in $file" 
    	     sed -i "s|$OLDWORD|$NEWWORD|" $file
	      done
	   done
	fi
}

if [ -d "$1" ]; then
    export orgfiledir=$1
    echo "$orgfiledir"
    echo "Script wordt uitgevoerd voor gemeente gm0297"
    echo ""
    echo $1
    cd $1;
    orgdirectory=`pwd`
    #we zijn nu in de directory van de bron bestanden
    #we gaan naar de directory van het unificeringsscript
    #de bronbestanden worden naar de bron-directory van het uniciferingsscript gekopieerd.
    unicificeringsdirectory="unificeringsscript"
    while [ ! -d "$unicificeringsdirectory" ]; do
        if [ ! -d "$unicificeringsdirectory" ]; then
            cd ..
        fi
    done
    #we gaan naar de brondirectory en maken die schoon
    cd "$unicificeringsdirectory"/bron 
    rm *.*
    #we kopieren de te unificieren bestanden hierin
    cp $orgdirectory/*.* .
    #we draaien ant
    cd ..
    ant -q
    if [ ! $? -eq 0 ]; then
        echo "**********************************************************************"
        echo "ANT FAILED: EXECUTION STOPPED !!!!!!!!!!!!!!!!!!!!!"
        echo "**********************************************************************"
    else
        #extract-datetime van opdracht.xml
        cd resultaat
         leveringId=$( grep -xh ".*idLevering.*" *)
         if [ "$leveringId" != "" ]; then
	       for leveringId1 in $leveringId; do
    	       leveringId2=${leveringId1%"</$leveringId>"}
	           LDWORD=${leveringId2##*>}
	           echo $OLDWORD
           done
         fi
    fi
else
    echo "Testset does not exist or Please start from directory opdracht_voorbeeldbestanden/XXX."
fi
