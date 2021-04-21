#!/usr/bin/env bash

# Test alle tekst_nummer directories

if [[ -d GEO ]]; then

cd BHKV
for d in *; do
    if [ -d "$d" ]; then
        echo "Test: $d"
	     cmd_output=$(../setsdecent/decent.sh $d)
	  if [[ $? -ne 0 ]] ; then 
	       exit 1 
	   fi
	fi
done

cd ../GEO
for d in *; do
    if [ -d "$d" ]; then
        echo "Test: $d"
	   cmd_output=$(../setsdecent/decent.sh $d)
	  if [[ $? -ne 0 ]] ; then 
	       exit 1 
	   fi
	fi
done
cd ../LVBB_
for d in *; do
    if [ -d "$d" ]; then
        echo "Test: $d"
        cmd_output=$(../setsdecent/decent.sh $d)
	  if [[ $? -ne 0 ]] ; then 
	       exit 1 
	   fi
	fi
done

cd ../OZON
for d in *; do
    if [ -d "$d" ]; then
        echo "Test: $d"
	   cmd_output=$(../setsdecent/decent.sh $d)
	  if [[ $? -ne 0 ]] ; then 
	       exit 1 
	   fi
	fi
done

cd ../STOP
for d in *; do
    if [ -d "$d" ]; then
        echo "Test: $d"
	   cmd_output=$(../setsdecent/decent.sh $d)
	  if [[ $? -ne 0 ]] ; then 
	       exit 1 
	   fi
	fi
done

cd ../TPOD
for d in *; do
    if [ -d "$d" ]; then
       echo "Test: $d"
       cmd_output=$(../setsdecent/decent.sh $d)
	fi
	  if [[ $? -ne 0 ]] ; then 
	       exit 1 
	   fi
done


cd ..
rm opdrachten_gereed/opdracht_-.zip
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
fi
