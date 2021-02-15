#!/bin/sh


#../1.0.3/opdracht_voorbeeldbestanden/GEO
mkdir ../1.0.4
mkdir ../1.0.4/opdracht_voorbeeldbestanden
for d in ../1.0.3/opdracht_voorbeeldbestanden/GEO/*; do
	mkdir ../1.0.4/opdracht_voorbeeldbestanden/GEO
	if [ -d "$d" ]; then
		echo $d
		directoryname=${d##*/}
		echo $directoryname
		mkdir ../1.0.4/opdracht_voorbeeldbestanden/GEO/$directoryname
		rm 1.0.3/opdracht/*
		rm 1.0.4/opdracht/*
		cp $d/* 1.0.3/opdracht 
		cp 1.0.3/opdracht/* 1.0.4/opdracht 
		ant -q -f build.xml main
		cp 1.0.4/opdracht/* ../1.0.4/opdracht_voorbeeldbestanden/GEO/$directoryname
	fi
done

rm 1.0.3/opdracht/*
rm 1.0.4/opdracht/*
