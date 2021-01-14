#!/usr/bin/sh


echo $1
cd $1;rm ../../opdrachten_gereed/opdracht_$1.zip;zip a ../../opdrachten_gereed/opdracht_$1.zip *;git add *;git add ../../opdrachten_gereed/opdracht_$1.zip;git commit -a -m $1;git push;cd ..;
