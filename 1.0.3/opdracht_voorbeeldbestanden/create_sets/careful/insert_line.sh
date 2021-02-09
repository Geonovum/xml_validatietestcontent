#!/usr/bin/env bash

# Test alle tekst_nummer directories

		NEWLINE=" <bestand>\n     <bestandsnaam>owLocatieRegelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" manifest.xml
		NEWLINE=" <bestand>\n     <bestandsnaam>regelingsgebied.xml</bestandsnaam>\n     <contentType>application/xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" manifest.xml
		NEWLINE=" <bestand>\n     <bestandsnaam>regelingsgebied.gml</bestandsnaam>\n     <contentType>application/gml+xml</contentType>\n    </bestand>";
		sed -i "/.*manifest xmlns=\"http:\/\/www.overheid.nl\/2017\/lvbb\">.*/ a $NEWLINE" manifest.xml
		NEWLINE="  <Bestand>\n     <naam>owLocatieRegelingsgebied.xml</naam>\n      <objecttype>Gebied</objecttype>\n   </Bestand>";
		sed -i "/.*DoelID>\/join\/id\/proces\/gm0297\/2019.*/ a $NEWLINE" manifest-ow.xml
