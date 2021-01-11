#!/usr/bin/sh


#cd ../LVBB3507;zip a ../opdracht_lvbb3507.zip *;git add * ../*;git commit -a -m "lvbb3507";git push
echo $1
cd $1;zip a ../opdracht_$1.zip *;git add * opdracht_$1.zip;git commit -a -m $1;git push;cd ..;
