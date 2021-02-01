#!/usr/bin/env bash

echo $1
cd $1;
RANDOM=tr -c -d '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null
FILENAMEPART=$1_$RANDOM
NEWLINE="<idLevering>id-publicatie-$FILENAMEPART</idLevering>";
sed -i "s|.*idLevering.*|$NEWLINE|" opdracht.xml
rm ../../opdrachten_gereed/opdracht_$1*.zip;

if command -v zip &> /dev/null
then
	zip a ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip *;
else
	unzip u ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip *;
fi

git add *;
git add ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip;
git commit -a -m $1;git push;
cd ..;
