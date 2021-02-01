#!/usr/bin/env bash


ZIPFILE_DIR="../opdracht_voorbeeldbestanden/opdrachten_gereed";
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""


echo "<result>" > result.xml
if [[ -n $FINDNUMBER ]]; then
	echo "Processing with argument $FINDNUMBER";
	#find file and test if is a directory
	NUMFILE=$(find $ZIPFILE_DIR -name "opdracht_$FINDNUMBER*.zip"|wc -l)
	if [[ $NUMFILE -eq 0 ]]; then
		echo "No files found in $ZIPFILE_DIR with wildcard opdracht_$FINDNUMBER*.zip" 
	else
		FILES=$(find $ZIPFILE_DIR -name "$FINDNUMBER*" -print);
		for file in $FILES; do
			echo $file;
			#execute_command "$file" "$LOGLEVEL"
		done
	fi
else
	echo "wait";
fi
echo "</result>" >> result.xml
