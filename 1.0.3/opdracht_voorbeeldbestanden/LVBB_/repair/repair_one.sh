#!/usr/bin/sh


echo $1
cd $1;
RANDOM=random-string 16
NEWLINE="<idLevering>id-publicatie-$1-$RANDOM</idLevering>";
echo $NEWLINE;
echo "$RANDOM";
echo "$RANDOM";
sed -i "s|.*idLevering.*|$NEWLINE|" opdracht.xml
rm ../../opdrachten_gereed/opdracht_$1*.zip;
zip a ../../opdrachten_gereed/opdracht_$1_$RANDOM.zip *;
git add *;
git add ../../opdrachten_gereed/opdracht_$1_$RANDOM.zip;
git commit -a -m $1;git push;
cd ..;

random-string()
{
    cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w ${1:-32} | head -n 1
}
