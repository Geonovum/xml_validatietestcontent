#!/usr/bin/sh


echo $1
cd $1;
RANDOM=`cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 8 | head -n 1`;
NEWLINE="<idLevering>id-publicatie-$1-$RANDOM</idLevering>";
# sed -i '/.*idLevering.*/d' opdracht.xml
echo $NEWLINE;
sed -i "s/.*idLevering.*/$NEWLINE/" opdracht.xml
rm ../../opdrachten_gereed/opdracht_$1.zip;
zip a ../../opdrachten_gereed/opdracht_$1.zip *;
git add *;
git add ../../opdrachten_gereed/opdracht_$1.zip;
git commit -a -m $1;git push;
cd ..;
