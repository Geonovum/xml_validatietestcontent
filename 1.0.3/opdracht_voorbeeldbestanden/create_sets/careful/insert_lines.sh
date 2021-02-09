#!/usr/bin/env bash

# Test alle tekst_nummer directories

if [[ -d GEO ]]; then

cd GEO
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE=" <bestand>\n     <bestandsnaam>owLocatieRegelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE=" <bestand>\n     <bestandsnaam>regelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="\n <bestand>\n     <bestandsnaam>regelingsgebied.gml</bestandsnaam>\n     <contentType>application/gml+xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="  <Bestand>\n     <naam>owLocatieRegelingsgebied.xml</naam>\n      <objecttype>Gebied</objecttype>\n   </Bestand>";
		sed -i "/.*DoelID>\/join\/id\/proces\/gm0297\/2019.*/ a $NEWLINE" $d/manifest-ow.xml
	fi
done
cd ../LVBB_
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE=" <bestand>\n     <bestandsnaam>owLocatieRegelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE=" <bestand>\n     <bestandsnaam>regelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="\n <bestand>\n     <bestandsnaam>regelingsgebied.gml</bestandsnaam>\n     <contentType>application/gml+xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="  <Bestand>\n     <naam>owLocatieRegelingsgebied.xml</naam>\n      <objecttype>Gebied</objecttype>\n   </Bestand>";
		sed -i "/.*DoelID>\/join\/id\/proces\/gm0297\/2019.*/ a $NEWLINE" $d/manifest-ow.xml
	fi
done
cd ../OZON
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE=" <bestand>\n     <bestandsnaam>owLocatieRegelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE=" <bestand>\n     <bestandsnaam>regelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="\n <bestand>\n     <bestandsnaam>regelingsgebied.gml</bestandsnaam>\n     <contentType>application/gml+xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="  <Bestand>\n     <naam>owLocatieRegelingsgebied.xml</naam>\n      <objecttype>Gebied</objecttype>\n   </Bestand>";
		sed -i "/.*DoelID>\/join\/id\/proces\/gm0297\/2019.*/ a $NEWLINE" $d/manifest-ow.xml
	fi
done
cd ../TPOD
for d in *; do
    if [ -d "$d" ]; then
		NEWLINE=" <bestand>\n     <bestandsnaam>owLocatieRegelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE=" <bestand>\n     <bestandsnaam>regelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="\n <bestand>\n     <bestandsnaam>regelingsgebied.gml</bestandsnaam>\n     <contentType>application/gml+xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" $d/manifest.xml
		NEWLINE="  <Bestand>\n     <naam>owLocatieRegelingsgebied.xml</naam>\n      <objecttype>Gebied</objecttype>\n   </Bestand>";
		sed -i "/.*DoelID>\/join\/id\/proces\/gm0297\/2019.*/ a $NEWLINE" $d/manifest-ow.xml
	fi
done
cd ..
else
    echo "Please start from directory opdracht_voorbeeldbestanden."
fi
