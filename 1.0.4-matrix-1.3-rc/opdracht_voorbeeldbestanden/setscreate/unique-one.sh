#!/usr/bin/env bash

current_dir=`pwd`
while [ ! -d opdracht_voorbeeldbestanden ]; do
    if [ ! -d opdracht_voorbeeldbestanden ]; then
        cd ..
    fi
done
opdracht_voorbeeldbestanden=`pwd`/opdracht_voorbeeldbestanden

cd $current_dir


#passeer ID-omkatter

#inpakken naar zip

inpakken_maar () {
    orgfiledir="${1}"

    number="${2}"
    
    lId=$( grep -h  idLevering *)
    l1=${lId%</*}
    l2=${l1#*>} 
    export datePart=${l2##*-}   
	export postfix="$orgfiledir"_"$datePart"
	#default
    export newPostfix="$postfix"b"$number"_v_
    #creeren zip-toevoeging voor bron-directory (we zijn in resultaat!!!!!)
	if echo "$(cat opdracht.xml)" | grep -q "publicatieOpdracht"; then
	   export newPostfix="$postfix"a"$number"_p_
    fi
	if echo "$(cat opdracht.xml)" | grep -q "validatieOpdracht"; then
	   export newPostfix="$postfix"b"$number"_v_
	fi
	if echo "$(cat opdracht.xml)" | grep -q "breekPublicatieAfOpdracht"; then
	   export newPostfix="$postfix"z"$number"_a_
	fi
	pwd
    echo "creating $opdracht_voorbeeldbestanden/opdrachten_gereed/"$newPostfix".zip"	    	   
	zip $opdracht_voorbeeldbestanden/opdrachten_gereed/"$newPostfix".zip *;
	echo "git add $opdracht_voorbeeldbestanden/opdrachten_gereed/"$newPostfix".zip;"
	git add $opdracht_voorbeeldbestanden/opdrachten_gereed/"$newPostfix".zip;
	pwd
}

passeer_ID_omkatter () {
    cd $1
    pwd
    inpakken_maar $1 "0"
    echo "git add *"
    git add *
}


if [ "$1" = "LVBB1004"  ]; then
    passeer_ID_omkatter $1
    exit 0;
fi
if [ "$1" = "LVBB4703"  ]; then
    passeer_ID_omkatter $1
    exit 0;
fi
if [ "$1" = "LVBB4707"  ]; then
    passeer_ID_omkatter $1
    exit 0;
fi
if [ "$1" = "LVBB4708"  ]; then
    passeer_ID_omkatter $1
    exit 0;
fi
if [ "$1" = "LVBB4712"  ]; then
    passeer_ID_omkatter $1
    exit 0;
fi

if [ -d "$1" ]; then
    export orgfiledir=$1
    echo "$orgfiledir"
    echo "Script wordt uitgevoerd voor Validatie-testbestand"
    echo "REMOVING $opdracht_voorbeeldbestanden/opdrachten_gereed/"$orgfiledir"*.zip"
	rm $opdracht_voorbeeldbestanden/opdrachten_gereed/"$orgfiledir"*.zip

    echo ""
    echo $1
    cd $1;
    orgdirectory=`pwd`
    #we zijn nu in de directory van de bron bestanden
    #we gaan naar de directory van omkat
    omkatdir="ValidatieTest-ID-Omkatter"
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
            #verwijder oude bestanden
        	rm $opdracht_voorbeeldbestanden/opdrachten_gereed/"$orgfiledir"*.zip;

           #extract-datetime van opdracht.xml
           cd resultaat 
           #verwijderen oude bestanden van deze directory

           echo "**********************************************************************"
           inpakken_maar $orgfiledir "0"
           
           #adding to git (if not done yet)
	       echo "git add $orgdirectory/bron/*"
	       git add $orgdirectory/bron/*
	       
	       cd ..;

	       for i in {1..100}
           do
	          if [ -d "resultaat_$i" ];then
    	           cd resultaat_$i
	               pwd
	               
	               inpakken_maar $orgfiledir $i "bron_$i"
	               
	               cd ..;	           
	           fi
           done

           if [ -d "resultaat_afbreek" ];then
	           export newPostfix="$postfix"z0_a_
               cd resultaat_afbreek
               pwd
               
               inpakken_maar $orgfiledir "0" "bron_afbreek"
               
               #adding to git (if not done yet)
	           echo "git add $orgdirectory/bron_afbreek/*"
	           git add $orgdirectory/bron_afbreek/*
               cd ..;	
           
           fi
           if [ -d "resultaat_afbreek_1" ];then
	           export newPostfix="$postfix"z1_a_
               cd resultaat_afbreek_1
               pwd
               
               inpakken_maar $orgfiledir "1" "bron_afbreek_1"

               #adding to git (if not done yet)
	           echo "git add $orgdirectory/bron_afbreek_1/*"
	           git add $orgdirectory/bron_afbreek_1/*
               
               cd ..;	  
         
           fi
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
           cd resultaat
           
           #uitzondering voor LBVV1002
           if [ "$1" == "LVBB1002" ]; then
    	       rm opdracht.xml
	       fi
	       #uitzondering voor LBVV1003
           if [ "$1" = "LVBB1003" ]; then
    	       rm manifest.xml
	       fi
           #uitzondering voor LBVV1009
           if [ "$1" = "LVBB1009" ]; then
    	       rm GoedeGebieden.xml
	       fi
	       #uitzondering voor LBVV1027
           if [ "$1" = "LVBB1027" ]; then
    	       rm manifest-ow.xml
	       fi
           #uitzondering voor LBVV4010
           if [ "$1" = "LVBB4010" ]; then
    	       rm akn_nl_bill_gm0297-3520-01.xml
	       fi
	       #uitzondering voor LBVV1514
           if [ "$1" == "LVBB1514" ]; then
    	       rm GoedeGebieden.xml
	       fi
	       #uitzondering voor LBVV1600
	       if [ "$1" = "LVBB1600" ]; then
    	       rm regelingsgebied.xml
    	       rm regelingsgebied.gml
    	       rm besluit.xml
	       fi
	       #uitzondering voor LBVV2501
           if [ "$1" = "LVBB2501" ]; then
    	       rm manifest-ow.xml
	       fi
	       #uitzondering voor LBVV3504
           if [ "$1" = "LVBB3504" ]; then
    	       rm GoedeGebieden.xml
    	       rm GoedeGebieden.gml
	       fi
	       #uitzondering voor LBVV3506
           if [ "$1" = "LVBB3506" ]; then
    	       rm GoedeGebieden.gml
	       fi
	       #uitzondering voor LBVV3514
           if [ "$1" = "LVBB3514" ]; then
    	       rm GoedeGebieden.xml
    	       rm GoedeGebieden.gml
	       fi
	       
	       inpakken_maar $orgfiledir "0"

	       echo "git add $orgdirectory/*"
	       git add $orgdirectory/*
       fi
    fi
else
    echo "Testset does not exist or Please start from directory opdracht_voorbeeldbestanden/XXX."
fi
