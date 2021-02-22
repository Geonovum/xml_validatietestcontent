#!/usr/bin/env bash

# Test alle tekst_nummer directories

if [[ -d GEO ]]; then

cd GEO
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE="<formaatInformatieobject>/join/id/stop/informatieobject/gio_002</formaatInformatieobject>";
		sed -i "s|.*formaatInformatieobject>/join/id/stop/informatieobject.*|$NEWLINE|" $d/regelingsgebied.xml
	fi
done
cd ../LVBB_
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE="<formaatInformatieobject>/join/id/stop/informatieobject/gio_002</formaatInformatieobject>";
		sed -i "s|.*formaatInformatieobject>/join/id/stop/informatieobject.*|$NEWLINE|" $d/regelingsgebied.xml
	fi
done
cd ../OZON
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE="<formaatInformatieobject>/join/id/stop/informatieobject/gio_002</formaatInformatieobject>";
		sed -i "s|.*formaatInformatieobject>/join/id/stop/informatieobject.*|$NEWLINE|" $d/regelingsgebied.xml
	fi
done
cd ../TPOD
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE="<formaatInformatieobject>/join/id/stop/informatieobject/gio_002</formaatInformatieobject>";
		sed -i "s|.*formaatInformatieobject>/join/id/stop/informatieobject.*|$NEWLINE|" $d/regelingsgebied.xml
	fi
done
cd ..
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
fi
