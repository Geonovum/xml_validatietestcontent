#!/usr/bin/env bash

cleanup () {
    rm *.xml;
    rm *.gml;
    rm *.bmp;
    rm *.jpg
    rm *.png
    rm *.txt
}

getAkn () {
    akn=$(awk '/bill/ && /FRBRWork/' *);
    akn=${akn%</*};
    akn=${akn#*>};
}

for file in `ls ../*.zip| sort -g`; do
    cp $file .;
    unzip $file;	  
    rm $file; 
    getAkn     
        
    if grep -q "publicatieOpdracht" *.xml;then
        echo $akn
 
        echo "<?xml version="1.0" encoding="UTF-8"?>" > manifest.xml;
        echo "<manifest xmlns="http://www.overheid.nl/2017/lvbb">" >> manifest.xml;
        echo "   <bestand>" >> manifest.xml;
        echo "      <bestandsnaam>manifest.xml</bestandsnaam>" >> manifest.xml;
        echo "      <contentType>application/xml</contentType>" >> manifest.xml;
        echo "   </bestand>" >> manifest.xml;
        echo "   <bestand>" >> manifest.xml;
        echo "      <bestandsnaam>opdracht.xml</bestandsnaam>" >> manifest.xml;
        echo "      <contentType>application/xml</contentType>" >> manifest.xml;
        echo "   </bestand>" >> manifest.xml;
        echo "</manifest>" >> manifest.xml;
    
        d=$(date +%s%N);

        suffix=${akn#*2019/};
        echo $suffix;
        filename=opdr-$suffix-0-afbreken;  

        echo "<?xml version="1.0" encoding="utf-8"?>" > opdracht.xml;
        echo "<breekPublicatieAfOpdracht xmlns="http://www.overheid.nl/2017/lvbb">" >> opdracht.xml;
        echo "   <idLevering>$d</idLevering>" >> opdracht.xml;
        echo "   <idBevoegdGezag>00000001812579446000</idBevoegdGezag>" >> opdracht.xml;
        echo "   <idAanleveraar>00000003560458830000</idAanleveraar>" >> opdracht.xml;
        echo "   <identificatie>$akn</identificatie>" >> opdracht.xml;
        echo "</breekPublicatieAfOpdracht>" >> opdracht.xml;

        zip $filename opdracht.xml manifest.xml;
    fi;
    cleanup

done
 