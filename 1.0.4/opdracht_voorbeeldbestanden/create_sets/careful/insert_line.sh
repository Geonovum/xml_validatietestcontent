#!/usr/bin/env bash

# Test alle tekst_nummer directories

		NEWLINE="<formaatInformatieobject>/join/id/stop/informatieobject/gio_002</formaatInformatieobject>";
		sed -i "/.*formaatInformatieobject>/join/id/stop/informatieobject.*/ a $NEWLINE" regelingsgebied.xml
