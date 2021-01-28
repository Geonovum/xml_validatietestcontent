#!/usr/bin/sh

randomstring()
{
tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null
}



echo $1
cd $1;
RANDOM=tr -dc '[:alnum:]' < /dev/urandom  | dd bs=4 count=8 2>/dev/null
NEWLINE="<idLevering>id-publicatie-$1-$RANDOM</idLevering>";
echo $NEWLINE;
echo $1-$RANDOM;
echo $1-$RANDOM;
sed -i "s|.*idLevering.*|$NEWLINE|" opdracht.xml
rm ../../opdrachten_gereed/opdracht_$1*.zip;
zip a ../../opdrachten_gereed/opdracht_$1_$RANDOM.zip *;
git add *;
git add ../../opdrachten_gereed/opdracht_$1_$RANDOM.zip;
git commit -a -m $1;git push;
cd ..;

