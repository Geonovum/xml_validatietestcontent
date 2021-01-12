#!/usr/bin/sh


echo $1
cd $1;rm ../opdracht_$1.zip;zip a ../opdracht_$1.zip *;git add *;git add ../opdracht_$1.zip;git commit -a -m $1;git push;cd ..;
