#!/usr/bin/env bash

	ORGDIR="org/1.0.3/opdracht_voorbeeldbestanden"
	DESTDIR="dest/1.0.4/opdracht_voorbeeldbestanden"
	WORKDIR="1.0.3/opdracht"
	NEWWORKDIR="1.0.4/opdracht"

handle_main_directory () {
	if [[ ! -d "$DESTDIR/$1" ]]; then
		mkdir "$DESTDIR/$1"	
	fi
	cd "$ORGDIR/$1/"
	ORGDIRS=$(ls)
	cd -
	for d in $ORGDIRS; do
		cd "$DESTDIR/$1"
		if [[ ! -d $d ]]; then
			echo "creating $d in "`pwd`
			eval mkdir -v $d
			
			## CLEANING UP
			eval cd -
			eval cd $WORKDIR
			OLDWORKFILES=$(ls)
			echo "oldfiles: $OLDWORKFILES"
			echo "cleaning in "`pwd`
			echo "-------------------------------"
			for f in $OLDWORKFILES; do
				rm -v $f
			done
			echo "-------------------------------"
			pwd
			eval cd -
			eval cd $NEWWORKDIR
			NEWWORKFILES=$(ls)
			echo "newfiles: $NEWWORKFILES"
			echo "cleaning in "`pwd`
			echo "-------------------------------"
			for f in $NEWWORKFILES; do
				rm -v $f
			done
			echo "-------------------------------"
			
			##LOADING NEW FILES
			echo "Loading new files org"
			pwd
			eval cd -
			eval cd $ORGDIR/$1/$d
			WORKFILES=$(ls)
			echo "workfiles: $WORKFILES"
			echo "copy from "`pwd`
			echo "-------------------------------"
			for f in $WORKFILES; do
				cp -v $f ../../../../../$WORKDIR
			done
			
			##RUNNING
			echo "Run your thing, everything prepared, and press enter to continue"
			eval cd -
			echo "current directory "`pwd`
			read -p $d
			
			##STORING NEW FILES
			echo "Storing new created files from Newworkdir to new destination dir"
			eval cd $NEWWORKDIR
			NEWWORKFILES=$(ls)
			echo "workfiles: $NEWWORKFILES"
			echo "copy from "`pwd`
			echo "-------------------------------"
			for f in $NEWWORKFILES; do
				cp -v $f ../../$DESTDIR/$1/$d
			done
			echo "-------------------------------"
			eval cd -
			pwd
			echo "New $1 RUN: "`pwd`
		fi
		pwd
	done
}


if [[ -d 1.0.3 && -d 1.0.4 && -f build.xml ]]; then
	if [[ ! -d "dest" ]]; then
		mkdir "dest"
	fi
	if [[ ! -d "dest/1.0.4" ]]; then
       mkdir "dest/1.0.4"
    fi
	if [[ ! -d "dest/1.0.4/opdracht_voorbeeldbestanden" ]]; then
        mkdir "dest/1.0.4/opdracht_voorbeeldbestanden"
    fi
	
	handle_main_directory "GEO"
	
	handle_main_directory "LVBB_"
	
	handle_main_directory "OZON"
	
	handle_main_directory "TPOD"
    
else
	echo "Please start from /c/Werkbestanden/Transformatie 1.0.4"
fi

