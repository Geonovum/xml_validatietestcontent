#!/bin/sh

#script om alle Test-schematrons op bijgeleverde xml-bestanden uit te voeren

echo ""
echo "====================================="
echo "Dit script draait op de KOOP tests"
echo "Dit script moet vanuit de directory voor Opdracht worden opgestart"
echo "====================================="
echo ""

mkdir tmp
ant -q -f build2.xml compile
ant -q -f build2.xml validate
ant -q -f build2.xml cleanup
rmdir tmp
