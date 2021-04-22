#!/usr/bin/env bash

if [ "$1" = "LVBB1004"  ]; then
    exit 0;
fi
if [ "$1" = "LVBB4703"  ]; then
    exit 0;
fi
if [ "$1" = "LVBB4707"  ]; then
    exit 0;
fi
if [ "$1" = "LVBB4708"  ]; then
    exit 0;
fi
if [ "$1" = "LVBB4712"  ]; then
    exit 0;
fi
if [ "$1" = "LVBB4737"  ]; then
    exit 0;
fi


if [ -d "$1" ]; then
    export orgfiledir=$1
    echo "$orgfiledir"
    echo "Script wordt uitgevoerd voor Validatie-testbestand"
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
		exit 1
    else
       #extract-datetime van opdracht.xml
       cd resultaat
       lId=$( grep -h  idLevering *)
       l1=${lId%</*}
       l2=${l1#*>} 
       export datePart=${l2##*-}   
       #verwijderen oude bestanden van deze directory
       rm ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$orgfiledir*.zip; 
       #uitzondering voor LBVV1009
       if [ "$1" == "LVBB1009" ]; then
    	    rm GoedeGebieden.xml
	   fi
       #uitzondering voor LBVV1002
       if [ "$1" == "LVBB1002" ]; then
    	    rm opdracht.xml
	   fi
       #uitzondering voor LBVV4010
       if [ "$1" == "LVBB4010" ]; then
    	    rm akn_nl_bill_gm0297-3520-01.xml
	   fi
	   #uitzondering voor LBVV1027
       if [ "$1" == "LVBB1027" ]; then
    	    rm manifest-ow.xml
	   fi
	   #uitzondering voor LBVV1514
       if [ "$1" == "LVBB1514" ]; then
    	    rm GoedeGebieden.xml
	   fi
	   #uitzondering voor LBVV2501
       if [ "$1" == "LVBB2501" ]; then
    	    rm manifest-ow.xml
	   fi
	   #uitzondering voor LBVV3504
       if [ "$1" == "LVBB3504" ]; then
    	    rm GoedeGebieden.xml
    	    rm GoedeGebieden.gml
	   fi
	   #uitzondering voor LBVV3506
       if [ "$1" == "LVBB3506" ]; then
    	    rm GoedeGebieden.gml
	   fi
	   #uitzondering voor LBVV3514
       if [ "$1" == "LVBB3514" ]; then
    	    rm GoedeGebieden.xml
    	    rm GoedeGebieden.gml
	   fi
	   #creeren zip-toevoeging
	   export postfix="$orgfiledir-$datePart"
       echo "creating ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfix.zip"	    	   
	   zip ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfix.zip *;
	   echo "git add $orgdirectory/*"
	   git add $orgdirectory/*
	   echo "git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfix.zip;"
	   git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfix.zip;
	   
	   ONGELDIGE_ZIP="LVBB1001-$datePart";
	   rm ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_LVBB1001*.zip;
	   echo "ongeldige zip" >  ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$ONGELDIGE_ZIP.zip
	   git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$ONGELDIGE_ZIP.zip;
       echo "c"
       git commit -a -m $orgfiledir;
       echo "d"
       git push;
       cd ..;
    fi
else
    echo "Testset does not exist or Please start from directory opdracht_voorbeeldbestanden/XXX."
fi
