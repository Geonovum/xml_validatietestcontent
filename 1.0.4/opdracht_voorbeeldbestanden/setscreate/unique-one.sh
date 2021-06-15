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
    #we gaan naar de directory van omkat
    omkatdir="ID-Omkatter"
    while [ ! -d "$omkatdir" ]; do
        if [ ! -d "$omkatdir" ]; then
            cd ..
        fi
    done
    #we checken of "bron" een subdirectory van org-directory is (multi-versie)
    if [ -d "$orgdirectory/bron" ]; then
        #we gaan naar de omkat/brondirectory en maken die schoon
        rm "$omkatdir"/bron/*.*
        rm -fr "$omkatdir"/bron_*
        #de bronbestanden worden naar de bron-directories van omkat gekopieerd, niet bestaande directories worden gemaakt
        cd $omkatdir
        cp -R $orgdirectory/* .
        #we draaien ant
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
	       export postfix="$orgfiledir-$datePart"
           #verwijderen oude bestanden van deze directory
           rm ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$orgfiledir*.zip;
            
	       #creeren zip-toevoeging voor bron-directory (we zijn in resultaat!!!!!)
	       export newPostfix="$postfix-0"
           echo "creating ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip"	    	   
	       zip ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip *;
	       #adding to git (if not done yet)
	       echo "git add $orgdirectory/bron/*"
	       git add $orgdirectory/bron/*
	       echo "git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip;"
	       git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip;
	       #overige resultaat-directories
	       cd ..;
	       for i in {1..100}
	       do
	           if [ -d "resultaat_$i" ];then
    	           export newPostfix="$postfix-$i"
	               cd resultaat_$i
	               pwd
                   echo "creating ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip"	    	   
	               zip ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip *;
	               #adding to git (if not done yet)
	               echo "git add $orgdirectory/bron_$i/*"
	               git add $orgdirectory/bron_$i/*
	               echo "git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip;"
	               git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$newPostfix.zip;
	               #overige resultaat-directories
	               cd ..;	           
	           fi
	       done
	       
       fi
    #anders single versie
    else
        #we gaan naar de omkat/brondirectory en maken die schoon
        rm $omkatdir/bron/*.* 
        rm -fr "$omkatdir"/bron_*
        #de bronbestanden worden naar de bron-directory van omkat gekopieerd.
        cp $orgdirectory/*.* $omkatdir/bron
        #we draaien ant
        cd $omkatdir
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
           #uitzondering voor LBVV1002
           if [ "$1" == "LVBB1002" ]; then
    	       rm opdracht.xml
	       fi
	       #uitzondering voor LBVV1003
           if [ "$1" == "LVBB1003" ]; then
    	       rm manifest.xml
	       fi
           #uitzondering voor LBVV1009
           if [ "$1" == "LVBB1009" ]; then
    	       rm GoedeGebieden.xml
	       fi
	       #uitzondering voor LBVV1027
           if [ "$1" == "LVBB1027" ]; then
    	       rm manifest-ow.xml
	       fi
           #uitzondering voor LBVV4010
           if [ "$1" == "LVBB4010" ]; then
    	       rm akn_nl_bill_gm0297-3520-01.xml
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
           echo "creating ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfixls .zip"	    	   
	       zip ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfix.zip *;
	       echo "git add $orgdirectory/*"
	       git add $orgdirectory/*
	       echo "git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfix.zip;"
	       git add ../../opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_$postfix.zip;
	       cd ..;
       fi
    fi
else
    echo "Testset does not exist or Please start from directory opdracht_voorbeeldbestanden/XXX."
fi
