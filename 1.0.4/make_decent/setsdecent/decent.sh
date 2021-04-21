#!/usr/bin/env bash

if [ -d "$1" ]; then
    echo "Test: $1"
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
    export orgfiledir=$1
    echo "$orgfiledir"
    echo "Script wordt uitgevoerd voor opnieuw inrichten nummering/id's"
    echo ""
    echo $1
    cd $1;
    orgdirectory=`pwd`
    #we zijn nu in de directory van de bron bestanden
    #we gaan naar de directory van het unificeringsscript
    #de bronbestanden worden naar de bron-directory van het uniciferingsscript gekopieerd.
    decentdirectory="decent"
    while [ ! -d "$decentdirectory" ]; do
        if [ ! -d "$decentdirectory" ]; then
            cd ..
        fi
    done
    #we gaan naar de brondirectory en maken die schoon
    cd "$decentdirectory"/bron 
    rm *.*
    #we kopieren de te unificieren bestanden hierin
    cp $orgdirectory/*.* .
    #we draaien ant
    cd ..
    ant
    if [ ! $? -eq 0 ]; then
        echo "**********************************************************************"
        echo "ANT FAILED: EXECUTION STOPPED !!!!!!!!!!!!!!!!!!!!!"
        echo "**********************************************************************"
        exit 1
    else
       #extract-datetime van opdracht.xml
       cp resultaat/*.* $orgdirectory
       exit 0
    fi
else
    echo "Testset does not exist or Please start from directory opdracht_voorbeeldbestanden/XXX."
    exit 1
fi
