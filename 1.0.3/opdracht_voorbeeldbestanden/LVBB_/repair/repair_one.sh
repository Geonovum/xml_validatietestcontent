#!/usr/bin/sh


echo $1
cd $1;
RANDOM=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`;
NEWLINE="<idLevering>id-publicatie-$1-$RANDOM</idLevering>";
echo $NEWLINE;
sed -i "s|.*idLevering.*|$NEWLINE|" opdracht.xml
rm ../../opdrachten_gereed/opdracht_$1_*.zip;
zip a ../../opdrachten_gereed/opdracht_$1_$RANDOM.zip *;
git add *;
git add ../../opdrachten_gereed/opdracht_$1_$RANDOM.zip;
git commit -a -m $1;git push;
cd ..;
