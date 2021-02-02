#!/usr/bin/env bash


FILE_DIR="../opdracht_voorbeeldbestanden";
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""
dt=`date '+%d%m%Y%H%M%S'`
resultfile="../results/result$dt.xml"

creating_zipfile_with_unique_levering_id () {
	directory=$1
        directoryname=$(basename $directory)
	log_level=""
	echo "Processing $directory $directoryname"

	#building sed-command
	RANDOM=tr -c -d '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null
	FILENAMEPART="$directoryname-$RANDOM"
	NEWLINE="<idLevering>id-publicatie-$FILENAMEPART</idLevering>";

	#changing opdracht.xml and creating zipfile
	cp $directory/opdracht.xml opdracht.bak;
	sed -i "s|.*idLevering.*|$NEWLINE|" $directory/opdracht.xml
	cd $directory
	zip "opdracht_$FILENAMEPART.zip" *;
	cd -
	mv opdracht.bak $directory/opdracht.xml;

	#execute keten-test
	result=$(oow-corv $log_level --action versturen --levering_id "id-publicatie-$FILENAMEPART" --conversation_id "$FILENAMEPART" --oin 00000001812579446000 --opdracht valideren "$directory/opdracht_$FILENAMEPART.zip")
	rm "$directory/opdracht_$FILENAMEPART.zip";

	#wait 10 seconds for keten to create results
	sleep 10
	#get result
	wget -nv --no-check-certificate $result -O result;
	cat result>>$resultfile; 
	rm result
}

execute_single_directory () {
	directory=$1
	directory_name=$(basename $directory)
	creating_zipfile_with_unique_levering_id $directory
}


find_directory () {
	DIRECTORIES=$(find $FILE_DIR/$1/* -name "*" -print);
        for directory in $DIRECTORIES; do
                if [ -d "$directory" ]; then
                        execute_single_directory $directory
                fi
        done
}


echo "<result>">$resultfile
if [[ -n $FINDNUMBER ]]; then
	echo "Processing with argument $FINDNUMBER";
	
	#find directory and test if is a directory or wildcard
	NUMFILE=$(find $FILE_DIR -name "$FINDNUMBER*"|wc -l)
	if [[ $NUMFILE -eq 0 ]]; then
		echo "No files found with wildcard $FINDNUMBER*" 
	else
		DIRECTORIES=$(find $FILE_DIR -name "$FINDNUMBER*" -print);
		for directory in $DIRECTORIES; do
			if [ -d "$directory" ]; then
				 execute_single_directory $directory;
			fi
		done
	fi
else
	#do all directories
	find_directory "GEO";
	find_directory "LVBB_";
	find_directory "OZON";
	find_directory "TPOD";
fi
echo "</result>">>$resultfile
