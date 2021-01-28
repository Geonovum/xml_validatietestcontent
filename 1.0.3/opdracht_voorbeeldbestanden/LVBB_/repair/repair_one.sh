#!/usr/bin/sh

randomstring()
{
tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null
}



echo $1
cd $1;
RANDOM=tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null
FILENAMEPART=$1_$RANDOM
NEWLINE="<idLevering>id-publicatie-$FILENAMEPART</idLevering>";
echo $NEWLINE;
echo $NEWLINE;
echo $FILENAMEPART;
echo $FILENAMEPART;
sed -i "s|.*idLevering.*|$NEWLINE|" opdracht.xml
rm ../../opdrachten_gereed/opdracht_$1*.zip;
zip a ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip *;
git add *;
git add ../../opdrachten_gereed/opdracht_$FILENAMEPART.zip;
git commit -a -m $1;git push;
cd ..;
