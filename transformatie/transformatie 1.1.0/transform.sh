#!/usr/bin/env bash

function hasDirs ()
{
    ls -ld $1*/ >/dev/null 2>&1 ;
}


if [ -d "$1" ]; then
	directory="$1"
	mkdir ../../1.1.0/${PWD##*/}/${directory##*/}
    if hasDirs "$1/"
    then
       for d in ../../1.0.4/${PWD##*/}/$directory/*; do
             mkdir ../../1.1.0/${PWD##*/}/${directory##*/}/${d##*/}
     		rm ../../transformatie\ 1.1.0/1.0.4/opdracht/*
             rm ../../transformatie\ 1.1.0/1.1.0/opdracht/*
		     cp ../../1.0.4/${PWD##*/}/${directory##*/}/${d##*/}/* ../../transformatie\ 1.1.0/1.0.4/opdracht 
		     cp ../../transformatie\ 1.1.0/1.0.4/opdracht/* ../../transformatie\ 1.1.0/1.1.0/opdracht 
		     cd ../../transformatie\ 1.1.0
		     if [[ ${d##*/} != *"afbreek"* ]]; then
		      ant -q -f build.xml main
		     fi
		     cd -
		     cp ../../transformatie\ 1.1.0/1.1.0/opdracht/* ../../1.1.0/${PWD##*/}/${directory##*/}/${d##*/}
        done
     else
	    rm ../../transformatie\ 1.1.0/1.0.4/opdracht/*
	    rm ../../transformatie\ 1.1.0/1.1.0/opdracht/*
	    cp ../../1.0.4/${PWD##*/}/${directory##*/}/* ../../transformatie\ 1.1.0/1.0.4/opdracht 
	    cp ../../transformatie\ 1.1.0/1.0.4/opdracht/* ../../transformatie\ 1.1.0/1.1.0/opdracht 
	    cd ../../transformatie\ 1.1.0
	    ant -q -f build.xml main
	    cd -
	    cp ../../transformatie\ 1.1.0/1.1.0/opdracht/* ../../1.1.0/${PWD##*/}/${directory##*/}
     fi
fi
