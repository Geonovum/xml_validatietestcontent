#!/usr/bin/env bash


ZIPFILE_DIR="../opdracht_voorbeeldbestanden/opdrachten_gereed";
START_EXECUTE="../execute_tests/for_each_start";
FINDNUMBER=$1
DEBUG=$2
LOGLEVEL=""

create_work_id () { 
	file_name=$1;
	TESTFILE=${file_name##*/opdracht_};
	TESTNUMBER=${TESTFILE%.zip};
	echo $TESTNUMBER;
}

execute_command () {
	file_name=$1;
	log_level=$2;
	workid=$(create_work_id "$file_name")
	result=$(oow-corv $log_level --action versturen --levering_id id-publicatie-$workid --conversation_id $workid --oin 00000001812579446000 --opdracht valideren $file_name)
	sleep 10
	wget --no-check-certificate $result;
}

if [[ -n $FINDNUMBER ]]; then
	echo "Processing $ZIPFILE_DIR/opdracht_$FINDNUMBER*.zip";
	if [[ -n $DEBUG ]]; then
		if [[ $DEBUG == "DEBUG" ]]; then
			LOGLEVEL="--log_level DEBUG";
		fi
	fi
	NUMFILE=$(find $ZIPFILE_DIR -name "opdracht_$FINDNUMBER*.zip"|wc -l)
	if [[ $NUMFILE -eq 0 ]]; then
		echo "No files found in $ZIPFILE_DIR with wildcard opdracht_$FINDNUMBER*.zip" 
	else
		FILES=$(find $ZIPFILE_DIR -name "opdracht_$FINDNUMBER*.zip" -print);
		for file in $FILES; do
			execute_command "$file" "$LOGLEVEL"
		done
	fi
else
	for file in $ZIPFILE_DIR/*; do
		TESTFILE=${file##*/opdracht_};
  		TESTNUMBER=${TESTFILE%.zip};
  		echo $TESTNUMBER;
  		echo "#!/usr/bin/env bash" > "$START_EXECUTE/$TESTNUMBER.sh";
  		echo "test" >> "$START_EXECUTE/$TESTNUMBER.sh";
  		sleep 30;
	done
fi


# oow-corv --log_level DEBUG --action versturen --levering_id id-publicatie-LVBB4017_339 --conversation_id LVBB4017_339  --oin 00000001812579446000 --opdracht valideren ~/xml_validatietestcontent/1.0.3/opdracht_voorbeeldbestanden/opdrachten_gereed/opdracht_LVBB4017_339.zip
# wget --no-check-certificate https://acceptatie.overheidsservicebus.com/opentunnel/00000003560458830000/dso/lvbb/spa/resultaat/ophalen/00000001812579446000_LVBB4017_339
