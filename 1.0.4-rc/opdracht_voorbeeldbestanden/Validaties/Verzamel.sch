<?xml version="1.0" encoding="UTF-8"?>
<sch:schema queryBinding="xslt2" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:sch="http://purl.oclc.org/dsdl/schematron"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <!-- ======================imop-aknjoin.sch=========================================================================================================== -->
    <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/"/>
    <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>  

    <sch:p>Versie 1.0.4</sch:p>
    <sch:p>Schematron voor aanvullende validatie van de regels voor AKNs en JOINs</sch:p>

    <sch:pattern id="sch_data_001" see="data:FRBRWork data:FRBRExpression data:instrumentVersie
        data:doel">
        <sch:title>AKN- of JOIN-identificatie mag geen punt bevatten</sch:title>
        <sch:rule context="data:FRBRWork | data:FRBRExpression | data:instrumentVersie | data:doel">
            <sch:p>Een AKN- of JOIN-identificatie mag geen punt bevatten</sch:p>
            <sch:report id="STOP1000" role="error" test="contains(., '.')">
                {"code": "STOP1000", "ID": "<sch:value-of select="."/>", "melding": "De identifier <sch:value-of select="."/> bevat een punt. Dit is niet toegestaan. Verwijder de punt.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_002" see="data:ExpressionIdentificatie data:FRBRWork
        data:FRBRExpression">
        <sch:title>ExpressionID begint met WorkID</sch:title>
        <sch:rule context="data:ExpressionIdentificatie">
            <sch:p>Het deel vóór de @ van de FRBRExpression moet gelijk aan zijn FRBRWork</sch:p>
            <sch:assert id="STOP1001" role="error" test="starts-with(data:FRBRExpression/normalize-space(), data:FRBRWork/normalize-space())">
                {"code": "STOP1001", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "melding": "Het gedeelte van de FRBRExpression <sch:value-of select="data:FRBRExpression"/> vóór de 'taalcode/@' is niet gelijk aan de FRBRWork-identificatie <sch:value-of select="data:FRBRWork"/>.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_005" see="data:ExpressionIdentificatie">
        <sch:title>AKN/JOIN validaties Expression/Work in ExpressionIdentificatie</sch:title>
        <sch:rule context="data:ExpressionIdentificatie">
            <sch:let name="soortWork" value="./data:soortWork/string()"/>
            <sch:let name="Expression" value="./data:FRBRExpression/string()"/>
            <sch:let name="Work" value="./data:FRBRWork/string()"/>
            <sch:let name="Expression_reeks" value="tokenize($Expression, '/')"/>
            <sch:let name="Expression_objecttype" value="$Expression_reeks[3]"/>
            <sch:let name="Expression_land" value="$Expression_reeks[3]"/>
            <sch:let name="Expression_collectie" value="$Expression_reeks[4]"/>
            <sch:let name="Expression_documenttype" value="$Expression_reeks[4]"/>
            <sch:let name="Expression_overheid" value="$Expression_reeks[5]"/>
            <sch:let name="Expression_datum_work" value="$Expression_reeks[6]"/>
            <sch:let name="Expression_restdeel" value="$Expression_reeks[8]"/>
            <sch:let name="Expression_restdeel_reeks" value="tokenize($Expression_restdeel, '@')"/>
            <sch:let name="Expression_taal" value="$Expression_restdeel_reeks[1]"/>
            <sch:let name="Expression_restdeel_deel2" value="$Expression_restdeel_reeks[2]"/>
            <sch:let name="Expression_restdeel_deel2_reeks"
                value="tokenize($Expression_restdeel_deel2, ';')"/>
            <sch:let name="Expression_datum_expr" value="$Expression_restdeel_deel2_reeks[1]"/>
            
            <sch:let name="Work_reeks" value="tokenize($Work, '/')"/>
            <sch:let name="Work_objecttype" value="$Work_reeks[3]"/>
            <sch:let name="Work_land" value="$Work_reeks[3]"/>
            <sch:let name="Work_collectie" value="$Work_reeks[4]"/>
            <sch:let name="Work_documenttype" value="$Work_reeks[4]"/>
            <sch:let name="Work_overheid" value="$Work_reeks[5]"/>
            <sch:let name="Work_datum_work" value="$Work_reeks[6]"/>
            
            <sch:let name="is_join" value="$soortWork = '/join/id/stop/work_010'"/>
            <sch:let name="is_akn"
                value="$soortWork = '/join/id/stop/work_003' or $soortWork = '/join/id/stop/work_015' or $soortWork = '/join/id/stop/work_019' or $soortWork = '/join/id/stop/work_006' or $soortWork = '/join/id/stop/work_021'"/>
            
            <sch:let name="is_besluit" value="$soortWork = '/join/id/stop/work_003'"/>
            <sch:let name="is_regeling"
                value="$soortWork = '/join/id/stop/work_019' or $soortWork = '/join/id/stop/work_006' or $soortWork = '/join/id/stop/work_021'"/>
            <sch:let name="is_publicatie" value="$soortWork = '/join/id/stop/work_015'"/>
            <sch:let name="is_informatieobject" value="$soortWork = '/join/id/stop/work_010'"/>
            <sch:let name="is_geconsolideerderegeling" value="$soortWork = '/join/id/stop/work_006'"/>
            
            <sch:let name="landexpressie" value="'^(nl|aw|cw|sx)$'"/>
            <sch:let name="overheidexpressie" value="'^(mnre\d{4}|mn\d{3}|gm\d{4}|ws\d{4}|pv\d{2})$'"/>
            <sch:let name="bladcode" value="'^(bgr|gmb|prb|stb|stcrt|trb|wsb)$'"/>
            <sch:let name="taalexpressie" value="'^(nld|eng|fry|pap|mul|und)$'"/>
            <sch:let name="collectieexpressie" value="'^(regdata|infodata|pubdata)$'"/>
            
            <sch:p>AKN-identificatie (work) MOET als tweede deel een geldig land hebben</sch:p>
            <sch:report id="STOP1002" role="error" test="$is_akn and not(matches($Work_land, $landexpressie))">
                {"code": "STOP1002", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_land"/>", "melding": "Landcode <sch:value-of select="$Work_land"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan. Pas landcode aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>AKN-identificatie (Work) van officiele publicatie MOET als derde deel officialGazette
                hebben</sch:p>
            <sch:report id="STOP1011" role="error" test="$is_publicatie and not(matches($Work_documenttype, '^officialGazette$'))">
                {"code": "STOP1011", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_documenttype"/>", "melding": "Derde veld <sch:value-of select="$Work_documenttype"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij officiele publicatie. Pas dit veld aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>AKN-identificatie (Work) van besluit MOET als derde deel bill hebben</sch:p>
            <sch:report id="STOP1013" role="error" test="$is_besluit and not(matches($Work_documenttype, '^bill$'))">
                {"code": "STOP1013", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_documenttype"/>", "melding": "Derde veld <sch:value-of select="$Work_documenttype"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij besluit. Pas dit veld aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>AKN-identificatie (work) van (evt gecons) regeling MOET als derde deel act
                hebben</sch:p>
            <sch:report id="STOP1012" role="error" test="$is_regeling and not(matches($Work_documenttype, '^act$'))">
                {"code": "STOP1012", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_documenttype"/>", "melding": "Derde veld <sch:value-of select="$Work_documenttype"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij regeling. Pas dit veld aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>JOIN-identificatie (work) MOET als tweede deel 'id' hebben</sch:p>
            <sch:report id="STOP1003" role="error" test="$is_join and not(matches($Work_objecttype, '^id$'))">
                {"code": "STOP1003", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "melding": "Tweede deel JOIN-identificatie <sch:value-of select="data:FRBRWork"/> moet gelijk zijn aan 'id'. Pas dit aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>JOIN-identificatie (werk) MOET als derde deel regdata,pubdata, infodata hebben</sch:p>
            <sch:report id="STOP1004" role="error" test="$is_join and not(matches($Work_collectie, $collectieexpressie))">
                {"code": "STOP1004", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "melding": "Derde deel JOIN-identificatie <sch:value-of select="data:FRBRWork"/> moet gelijk zijn aan regdata, pubdata, of infodata. Pas dit aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>AKN of JOIN identificatie MOET als vijfde deel jaartal of geldigde datum hebben</sch:p>
            <sch:report id="STOP1006" role="error" test="($is_join or $is_akn) and not(($Work_datum_work castable as xs:date) or ($Work_datum_work castable as xs:gYear))">
                {"code": "STOP1006", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "melding": "Vijfde deel AKN- of JOIN-identificatie <sch:value-of select="data:FRBRWork"/> moet gelijk zijn aan jaartal of geldige datum. Pas dit aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>JOIN-identificatie (expressie) MOET als eerste deel na de '@' een jaartal of een
                geldige datum hebben</sch:p>
            <sch:report id="STOP1007" role="error" test="$is_join and not(($Expression_datum_expr castable as xs:date) or ($Expression_datum_expr castable as xs:gYear))">
                {"code": "STOP1007", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "melding": "Voor een JOIN-identificatie (<sch:value-of select="data:FRBRExpression"/>) moet het eerste deel na de '@' een jaartal of een geldige datum zijn. Pas dit aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>JOIN-identificatie (expressie) MOET als eerste deel na de '@' een jaartal of een
                geldige datum hebben groter/gelijk aan jaartal in werk</sch:p>
            <sch:report id="STOP1008" role="error" test="$is_join and not($Expression_datum_expr >= $Expression_datum_work)"> 
                {"code": "STOP1008", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "melding": "JOIN-identificatie (<sch:value-of select="data:FRBRExpression"/>) MOET als eerste deel na de '@' een jaartal of een geldige datum hebben groter/gelijk aan jaartal in werk (<sch:value-of select="data:FRBRWork"/>). Pas dit aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>AKN- of JOIN-identificatie (expressie) MOET als deel voorafgaand aan de '@' een geldige
                taal hebben</sch:p>
            <sch:report id="STOP1009" role="error" test="($is_join or $is_akn) and not(matches($Expression_taal, $taalexpressie))">
                {"code": "STOP1009", "Expression-ID": "<sch:value-of select="data:FRBRExpression"/>", "substring": "<sch:value-of select="$Expression_taal"/>", "melding": "Voor een AKN- of JOIN-identificatie (<sch:value-of select="data:FRBRExpression"/>) moet deel voorafgaand aan de '@' (<sch:value-of select="$Expression_taal"/>) een geldige taal zijn ('nld','eng','fry','pap','mul','und'). Pas dit aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>Vierde deel AKN werken niet offpub en niet geconsolideerde regeling MOET brp-code
                zijn</sch:p>
            <sch:report id="STOP1010" role="error" test="($is_akn or $is_join) and not($is_publicatie) and not($is_geconsolideerderegeling) and not(matches($Work_overheid, $overheidexpressie))"> 
                {"code": "STOP1010", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_overheid"/>", "melding": "Vierde deel van AKN/JOIN van werk (<sch:value-of select="data:FRBRWork"/>) moet gelijk zijn aan een brp-code. Pas (<sch:value-of select="$Work_overheid"/>) aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>Vierde deel AKN van offpub werken MOET bladcode zijn</sch:p>
            <sch:report id="STOP1017" role="error" test="$is_publicatie and not(matches($Work_overheid, $bladcode))"> 
                {"code": "STOP1017", "Work-ID": "<sch:value-of select="data:FRBRWork"/>", "substring": "<sch:value-of select="$Work_overheid"/>", "melding": "Vierde veld <sch:value-of select="$Work_overheid"/> in de AKN-identificatie <sch:value-of select="data:FRBRWork"/> is niet toegestaan bij officiele publicatie. Pas dit veld aan.", "ernst": "fout"},</sch:report>
            
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_003" see="data:FRBRWork data:FRBRExpression data:instrumentVersie
        data:doel">
        <sch:title>AKN en JOIN identificaties starten met /akn/ of /join/</sch:title>
        <sch:rule context="data:FRBRWork | data:FRBRExpression | data:instrumentVersie | data:doel">
            <sch:p>Een AKN of JOIN identificatie MOET starten met /akn/ of /join/</sch:p>
            <sch:assert id="STOP1014" role="error" test="starts-with(./normalize-space(), '/akn/') or starts-with(./normalize-space(), '/join/')">
                {"code": "STOP1014", "ID": "<sch:value-of select="."/>", "melding": "De waarde <sch:value-of select="."/> begint niet met /akn/ of /join/. Pas de waarde aan.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- ==================imop-consolidatie.sch=============================================================================================================== -->
    <sch:p>Versie 1.0.4</sch:p>
    <sch:p>Schematron voor aanvullende validatie voor consolidatie-informatie</sch:p>
    
    <sch:pattern id="sch_data_012" see="data:BeoogdeRegeling">
        <sch:title>data:instrumentVersie moet expressionID (AKN/act) zijn</sch:title>
        <sch:rule context="data:BeoogdeRegeling">
            <sch:p>data:instrumentVersie moet expressionID (AKN/act) zijn</sch:p>
            <sch:assert id="STOP1026" role="error" test="matches(./data:instrumentVersie/string(), '^/akn/(nl|aw|cw|sx)/act')">
                {"code": "STOP1026", "ID": "<sch:value-of select="./data:instrumentVersie/string()"/>", "melding": "De waarde van instrumentVersie <sch:value-of select="./data:instrumentVersie/string()"/> in BeoogdeRegeling MOET een expressionID (AKN/act) zijn", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_013" see="data:BeoogdInformatieobject">
        <sch:title>data:instrumentVersie moet JOIN/regdata zijn</sch:title>
        <sch:rule context="data:BeoogdInformatieobject">
            <sch:p>data:instrumentVersie moet JOIN/regdata zijn</sch:p>
            <sch:assert id="STOP1027" role="error" test="matches(./data:instrumentVersie/string(), '^/join/id/regdata/')">
                {"code": "STOP1027", "ID": "<sch:value-of select="./data:instrumentVersie/string()"/>", "melding": "De waarde van instrumentVersie in BeoogdInformatieobject <sch:value-of select="./data:instrumentVersie/string()"/> MOET een JOIN/regdata zijn", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_014" see="data:BeoogdInformatieobject">
        <sch:title>data:Intrekking/data:instrument moet work-Id (/AKN/Act) zijn</sch:title>
        <sch:rule context="data:Intrekking">
            <sch:p>data:Intrekking/data:instrument moet work-Id (/AKN/Act) zijn</sch:p>
            <sch:assert id="STOP1028" role="error" test="matches(./data:instrument/string(), '^/akn/(nl|aw|cw|sx)/act')">
                {"code": "STOP1028", "ID": "<sch:value-of select="./data:instrument/string()"/>", "melding": "Het instrument binnen een Intrekking <sch:value-of select="./data:instrument/string()"/> MOET een work-Id (/AKN/Act) zijn", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_015" see="data:doel data:Tijdstempel">
        <sch:title>Een doel kan maar 1 datum inwerking hebben</sch:title>
        <sch:rule context="data:Tijdstempels">
            <sch:p>Een doel kan maar 1 datum inwerking hebben</sch:p>
            <sch:assert id="STOP1029" role="error" test="count(./data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'juridischWerkendVanaf' or ../data:soortTijdstempel = 'geldigVanaf')]) = count(distinct-values(./data:Tijdstempel/data:doel[(../data:soortTijdstempel = 'juridischWerkendVanaf' or ../data:soortTijdstempel = 'geldigVanaf')]))">
                {"code": "STOP1029", "melding": "Een doel MAG binnen Tijdstempels maar één datum inwerking (dus juridischWerkendVanaf of geldigVanaf) hebben", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!-- =====================imop-geo.sch============================================================================================================ -->
    <sch:ns prefix="geo" uri="https://standaarden.overheid.nl/stop/imop/geo/"/>
    <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
    <sch:ns prefix="basisgeo" uri="http://www.geostandaarden.nl/basisgeometrie/1.0"/>
    <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
    
    <sch:p>Versie 1.0.4</sch:p>
    <sch:p>Schematron voor aanvullende validatie voor imop-geo.xsd</sch:p>
    
    <sch:pattern id="sch_geo_001" see="geo:Locatie">
        <sch:title>Locatie rules</sch:title>
        <sch:rule context="geo:locaties">
            <sch:let name="aantalLocaties" value="count(./geo:Locatie)"/>
            <sch:let name="aantalLocatiesMetGroepID" value="count(./geo:Locatie/geo:groepID)"/>
            <sch:let name="aantalLocatiesMetKwantitatieveNormwaarde"
                value="count(./geo:Locatie/geo:kwantitatieveNormwaarde)"/>
            <sch:let name="aantalLocatiesMetKwalitatieveNormwaarde"
                value="count(./geo:Locatie/geo:kwalitatieveNormwaarde)"/>
            
            <sch:p>Als er één locatie is in een GIO waar een waarde groepID is ingevuld MOETEN ze allemaal
                zijn ingevuld.</sch:p>
            <sch:assert id="STOP3000" role="error" test="($aantalLocatiesMetGroepID = 0) or ($aantalLocatiesMetGroepID = $aantalLocaties)">
                {"code": "STOP3000", "melding": "Als er één locatie is in een GIO waar een waarde groepID is ingevuld moet elke locatie een GroepID hebben. Geef alle locaties een groepID.", "ernst": "fout"},</sch:assert>
            
            <sch:p>Als er één locatie is in een GIO waar kwantitatieveNormwaarde is ingevuld MOETEN alle
                locaties een kwantitatieveNormWaarde hebben.</sch:p>
            <sch:assert id="STOP3006" role="error" test="($aantalLocatiesMetKwantitatieveNormwaarde = 0) or ($aantalLocatiesMetKwantitatieveNormwaarde = $aantalLocaties)">
                {"code": "STOP3006", "melding": "Een locatie heeft een kwantitatieveNormwaarde, en één of meerdere andere locaties niet. Geef alle locaties een kwantitatieveNormwaarde, of verwijder alle kwantitatieveNormwaardes.", "ernst": "fout"},</sch:assert>
            
            <sch:p>Als er één locatie is in een GIO waar kwalitatieveNormwaarde is ingevuld MOETEN alle
                locaties een kwalitatieveNormwaarde hebben.</sch:p>
            <sch:assert id="STOP3007" role="error" test="($aantalLocatiesMetKwalitatieveNormwaarde = 0) or ($aantalLocatiesMetKwalitatieveNormwaarde = $aantalLocaties)">
                {"code": "STOP3007", "melding": "Een locatie heeft een kwalitatieveNormwaarde, en één of meerdere andere locaties niet. Geef alle locaties een kwalitatieveNormwaarde, of verwijder alle kwalitatieveNormwaardes.", "ernst": "fout"},</sch:assert>
            
            <sch:p>Als de locaties van de GIO kwantitatieve normwaarden hebben, moet de
                eenheid(eenheidlabel en eenheidID) aanwezig zijn in de GIO.</sch:p>
            <sch:report id="STOP3009" role="error" test="(($aantalLocatiesMetKwantitatieveNormwaarde gt 0) and ((not(exists(../geo:eenheidlabel))) or (not(exists(../geo:eenheidID)))))">
                {"code": "STOP3009", "Work-ID": "<sch:value-of select="../geo:FRBRWork"/>", "melding": "De locaties van de GIO <sch:value-of select="../geo:FRBRWork"/> bevatten kwantitatieve normwaarden, terwijl eenheidlabel en/of eenheidID ontbreken. Vul deze aan.", "ernst": "fout"},</sch:report>
            
            
            <sch:p>Als de locaties van de GIO kwalitatieve normwaarden hebben, MOGEN eenheidlabel en
                eenheidID NIET voorkomen.</sch:p>
            <sch:report id="STOP3015" role="error" test="(($aantalLocatiesMetKwalitatieveNormwaarde gt 0) and ((exists(../geo:eenheidlabel) or exists(../geo:eenheidID))))">
                {"code": "STOP3015", "Work-ID": "<sch:value-of select="../geo:FRBRWork"/>", "melding": "De GIO met Work-ID <sch:value-of select="../geo:FRBRWork"/> met kwalitatieve normwaarden, mag geen eenheidlabel noch eenheidID hebben. Verwijder eenheidlabel en eenheidID toe, of verwijder de kwalitatieve normwaarden.", "ernst": "fout"},</sch:report>
            
            
            <sch:p>Als de locaties van de GIO kwantitatieve òf kwalitatieve normwaarden hebben, dan moet
                de norm (normlabel en normID) aanwezig zijn.</sch:p>
            <sch:report id="STOP3011" role="error" test="((($aantalLocatiesMetKwantitatieveNormwaarde + $aantalLocatiesMetKwalitatieveNormwaarde) gt 0) and ((not(exists(../geo:normlabel))) or (not(exists(../geo:normID)))))">
                {"code": "STOP3011", "Work-ID": "<sch:value-of select="../geo:FRBRWork"/>", "melding": "De locaties binnen GIO met Work-ID <sch:value-of select="../geo:FRBRWork"/> bevatten wel kwantitatieve òf kwalitatieve normwaarden, maar geen norm. Vul normlabel en normID aan.", "ernst": "fout"},</sch:report>
            
            <sch:p>Binnen 1 GIO mag elke basisgeo:id (GUID) van de geometrie van een locatie maar één keer
                voorkomen.</sch:p>
            <sch:assert id="STOP3013" role="error" test="count(./geo:Locatie/geo:geometrie/basisgeo:Geometrie/basisgeo:id) = count(distinct-values(./geo:Locatie/geo:geometrie/basisgeo:Geometrie/basisgeo:id))">
                {"code": "STOP3013", "Work-ID": "<sch:value-of select="../geo:FRBRWork"/>", "melding": "In Work-ID <sch:value-of select="../geo:FRBRWork"/> zijn de basisgeo:id's niet uniek. Binnen 1 GIO mag basisgeo:id van geometrieen van verschillende locaties niet gelijk zijn aan elkaar. Pas dit aan.", "ernst": "fout"},</sch:assert>
            
        </sch:rule>
        
        <sch:rule context="geo:locaties/geo:Locatie">
            <sch:let name="ID" value="./geo:geometrie/basisgeo:Geometrie/basisgeo:id"/>
            
            <sch:p>Van de elementen kwalitatieveNormwaarde en kwantitatieveNormwaarde in een Locatie mag
                er slechts één ingevuld zijn.</sch:p>
            <sch:assert id="STOP3008" role="error" test="count(./geo:kwantitatieveNormwaarde) + count(./geo:kwalitatieveNormwaarde) le 1">
                {"code": "STOP3008", "ID": "<sch:value-of select="$ID"/>", "melding": "Locatie met basisgeo:id <sch:value-of select="$ID"/> heeft zowel een kwalitatieveNormwaarde als een kwantitatieveNormwaarde. Verwijder één van beide.", "ernst": "fout"},</sch:assert>
            
            <sch:p>Een Locatie binnen een GIO mag niet zowel een groepID (GIO-deel) als een (kwalitatieve
                of kwantitatieve) Normwaarde bevatten.</sch:p>
            <sch:report id="STOP3012" role="error" test="exists(./geo:groepID) and (exists(./geo:kwalitatieveNormwaarde) or exists(./geo:kwantitatieveNormwaarde))">
                {"code": "STOP3012", "ID": "<sch:value-of select="$ID"/>", "melding": "Locatie met basisgeo:id <sch:value-of select="$ID"/> heeft zowel een groepID (GIO-deel) als een (kwalitatieve of kwantitatieve) Normwaarde. Verwijder de Normwaarde of de groepID.", "ernst": "fout"},</sch:report>
        </sch:rule>
        
        <sch:rule context="geo:locaties/geo:Locatie/geo:kwalitatieveNormwaarde">
            <sch:p>Een kwalitatieveNormwaarde mag geen lege string (“”) zijn.</sch:p>
            <sch:assert id="STOP3010" role="error" test="normalize-space(.)">
                {"code": "STOP3010", "ID": "<sch:value-of select="../geo:geometrie/basisgeo:Geometrie/basisgeo:id"/>", "melding": "De kwalitatieveNormwaarde van locatie met basisgeo:id <sch:value-of select="../geo:geometrie/basisgeo:Geometrie/basisgeo:id"/> is niet gevuld. Vul deze aan.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
    </sch:pattern>
    
    <sch:pattern id="sch_geo_002" see="geo:groepID">
        <sch:title>Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje
            groepen.</sch:title>
        <sch:rule context="geo:Locatie/geo:groepID">
            <sch:let name="doelwit" value="./string()"/>
            <sch:p>Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje
                groepen.</sch:p>
            <sch:assert id="STOP3001" role="error" test="count(../../../geo:groepen/geo:Groep[./geo:groepID = $doelwit]) gt 0">
                {"code": "STOP3001", "ID": "<sch:value-of select="$doelwit"/>", "melding": "Als een locatie een groepID heeft, dan MOET deze voorkomen in het lijstje groepen. GroepID <sch:value-of select="$doelwit"/> komt niet voor in groepen. Geef alle locaties een groepID die voorkomt in groepen.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_geo_003" see="geo:groepID">
        <sch:title>Als GroepID voorkomt mag het niet leeg zijn.</sch:title>
        <sch:rule context="geo:groepID">
            <sch:p>Als GroepID voorkomt mag het niet leeg zijn.</sch:p>
            <sch:assert id="STOP3002" role="error" test="normalize-space(.)">
                {"code": "STOP3002", "melding": "Als GroepID voorkomt mag het niet leeg zijn. Geef een correcte groepID.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_geo_004" see="geo:groepen">
        <sch:title>Check op unieke labels en groepIDs.</sch:title>
        <sch:rule context="geo:groepen">
            <sch:p>Twee groepIDs in het lijstje groepen mogen niet dezelfde waarde hebben.</sch:p>
            <sch:assert id="STOP3003" role="error" test="count(./geo:Groep/geo:groepID) = count(distinct-values(./geo:Groep/geo:groepID))">
                {"code": "STOP3003", "melding": "Een groepID komt meerdere keren voor. Geef unieke groepIDs.", "ernst": "fout"},</sch:assert>
            <sch:assert id="STOP3004" role="error" test="count(./geo:Groep/geo:label) = count(distinct-values(./geo:Groep/geo:label))">
                {"code": "STOP3004", "melding": "Een label komt meerdere keren voor. Geef een unieke labels.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_geo_005" see="geo:groepID">
        <sch:title>Als een groepID voorkomt in het lijstje groepen dan MOET er minstens 1 locatie zijn
            met dat groepID.</sch:title>
        <sch:rule context="geo:groepen/geo:Groep/geo:groepID">
            <sch:let name="doelwit" value="./string()"/>
            <sch:p>Als een groepID voorkomt in het lijstje groepen dan MOET er minstens 1 locatie zijn met
                dat groepID.</sch:p>
            <sch:assert id="STOP3005" role="error" test="count(../../../geo:locaties/geo:Locatie[./geo:groepID = $doelwit]) gt 0">
                {"code": "STOP3005", "ID": "<sch:value-of select="$doelwit"/>", "melding": "GroepID <sch:value-of select="$doelwit"/> wordt niet gebruikt voor een locatie. Verwijder deze groep, of gebruik de groep bij een Locatie.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_geo_006" see="geo:eenheidlabel geo:eenheidID geo:normlabel geo:normID">
        <sch:title>Geen norm elementen in een GIO zonder normwaarde.</sch:title>
        <sch:rule context="geo:GeoInformatieObjectVersie">
            <sch:p>In een GIO waar locaties geen kwalitatieve of kwantitatieve normwaarde hebben, MOGEN
                eenheidID, eenheidlabel, normID en normlabel NIET voorkomen.</sch:p>
            <sch:report id="STOP3016" role="error" test="(exists(geo:normID) or exists(geo:normlabel) or exists(geo:eenheidID) or exists(geo:eenheidlabel)) and (count(geo:locaties/geo:Locatie/geo:kwantitatieveNormwaarde) + count(geo:locaties/geo:Locatie/geo:kwalitatieveNormwaarde) = 0)">
                {"code": "STOP3016", "Work-ID": "<sch:value-of select="geo:FRBRWork"/>", "melding": "De GIO met Work-ID <sch:value-of select="geo:FRBRWork"/> bevat norm (normID en normlabel) en/of eenheid (eenheidID en eenheidlabel), terwijl kwantitatieve of kwalitatieve normwaarden ontbreken. Geef de locaties normwaarden of verwijder de norm/eenheid elementen.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_geo_007" see="geo:wasID">
        <sch:title>wasID rules</sch:title>
        <sch:rule context="geo:wasID">
            <sch:p>Als een GIO een wasID heeft, dan MOET de wasID een voorgaande expressie zijn van
                hetzelfde work.</sch:p>
            <sch:assert id="STOP3017" role="error" test="starts-with(., ../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRWork)"> 
                {"code": "STOP3017", "Expression-ID": "<sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRExpression"/>", "ID": "<sch:value-of select="."/>", "Work-ID": "<sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRWork"/>", "melding": "De wasID (<sch:value-of select="."/>) van de GIO met Work-ID <sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRWork"/> is geen voorgaande expressie van dit work met Expression-ID <sch:value-of select="../geo:vastgesteldeVersie/geo:GeoInformatieObjectVersie/geo:FRBRExpression"/> . Verbeter de WasID.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ====================imop-metadata.sch============================================================================================================= -->
    
    <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/" />
    <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
    
    <sch:p>Versie 1.0.4</sch:p>
    <sch:p>Schematron voor aanvullende validatie voor metadata</sch:p>
    
    
    <sch:pattern id="sch_data_004" see="data:InformatieObjectMetadata data:officieleTitel">
        <sch:title>OfficieleTitel InformatieObject is JOIN identifier</sch:title>
        <sch:rule context="data:InformatieObjectMetadata">
            <sch:p>De officieleTitel van een InformatieObject MOET starten met /join/id/</sch:p>
            <sch:assert id="STOP1015" role="error"
                test="starts-with(./data:officieleTitel/string(), '/join/id/')"> {"code": "STOP1015", "substring": "<sch:value-of select="./data:officieleTitel" />", "melding": "De waarde van officieleTitel <sch:value-of select="./data:officieleTitel" /> MOET starten met /join/id/. Maak er een JOIN-identifier van.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_006" see="data:RegelingVersieMetadata">
        <sch:title>RegelingVersieMetadata validaties</sch:title>
        <sch:rule context="data:RegelingVersieMetadata/data:versienummer">
            <sch:p>Versienummer van regeling moet voldoen onze specificaties</sch:p>
            <sch:report id="STOP1016" role="error"
                test="not(matches(./string(), '^[a-zA-Z0-9\-]{1,32}$'))"> {"code": "STOP1016", "substring": "<sch:value-of select="./string()" />", "melding": "Het versienummer van een regeling <sch:value-of select="./string()" /> MOET bestaan uit maximaal 32 cijfers, onderkast- en bovenkast-letters en -, en MAG NIET bestaan uit punt en underscore.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_007" see="data:informatieobjectRefs">
        <sch:title>informatieobjectRefs uniek</sch:title>
        <sch:rule context="data:informatieobjectRefs">
            <sch:p>alle data:informatieobjectref binnen een data:informatieobjectRefs zijn uniek</sch:p>
            <sch:report id="STOP1018" role="error"
                test="count(./data:informatieobjectRef) != count(distinct-values(./data:informatieobjectRef))"
                > {"code": "STOP1018", "melding": "Alle referenties binnen informatieobjectRefs moeten uniek zijn. Pas dit aan.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    
    <sch:pattern id="sch_data_008"
        see="data:rechtsgebieden data:overheidsdomeinen data:onderwerpen
        data:alternatieveTitels data:opvolging">
        <sch:title>data:rechtsgebieden, data:overheidsdomeinen, data:onderwerpen,
            data:alternatieveTitels, data:opvolging uniek</sch:title>
        <sch:rule context="data:rechtsgebieden">
            <sch:p>data:rechtsgebieden zijn uniek</sch:p>
            <sch:report id="STOP1019" role="error"
                test="count(./data:rechtsgebied) != count(distinct-values(./data:rechtsgebied))"> {"code": "STOP1019", "melding": "Gebruik elke waarde binnen container data:rechtsgebieden maar één keer.", "ernst": "fout"},</sch:report>
        </sch:rule>
        <sch:rule context="data:overheidsdomeinen">
            <sch:p>data:overheidsdomeinen zijn uniek</sch:p>
            <sch:report id="STOP1030" role="error"
                test="count(./data:overheidsdomein) != count(distinct-values(./data:overheidsdomein))">
                {"code": "STOP1030", "melding": "Gebruik elke waarde binnen container data:overheidsdomeinen maar één keer.", "ernst": "fout"},</sch:report>
        </sch:rule>
        <sch:rule context="data:onderwerpen">
            <sch:p>data:onderwerpen zijn uniek</sch:p>
            <sch:report id="STOP1031" role="error"
                test="count(./data:onderwerp) != count(distinct-values(./data:onderwerp))"> {"code": "STOP1031", "melding": "Gebruik elke waarde binnen container data:onderwerpen maar één keer.", "ernst": "fout"},</sch:report>
        </sch:rule>
        <sch:rule context="data:alternatieveTitels">
            <sch:p>data:alternatieveTitels zijn uniek</sch:p>
            <sch:report id="STOP1022" role="error"
                test="count(./data:alternatieveTitel) != count(distinct-values(./data:alternatieveTitel))">
                {"code": "STOP1022", "melding": "De alternatieve titels binnen alternatieveTitels MOETEN allen uniek zijn.", "ernst": "fout"},</sch:report>
        </sch:rule>
        <sch:rule context="data:opvolging">
            <sch:p>data:opvolging zijn uniek</sch:p>
            <sch:report id="STOP1023" role="error"
                test="count(./data:opvolgerVan) != count(distinct-values(./data:opvolgerVan))"> {"code": "STOP1023", "melding": "Alle opvolgerVan binnen een opvolging MOETEN uniek zijn.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_009" see="data:alternatieveTitel data:citeertitel">
        <sch:title>alternatieveTitel niet gelijk aan citeertitel</sch:title>
        <sch:rule context="data:alternatieveTitel">
            <sch:p>Geen van de alternatieveTitel is gelijk aan de citeertitel</sch:p>
            <sch:report id="STOP1020" role="error"
                test="./string() = ../../data:heeftCiteertitelInformatie/data:CiteertitelInformatie/data:citeertitel/string()"
                > {"code": "STOP1020", "melding": "De citeertitel MAG NIET gelijk zijn aan een alternatieve titel.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_010" see="data:opvolgerVan">
        <sch:title>data:opvolgerVan wijst naar een Work van een Regeling</sch:title>
        <sch:rule context="data:opvolgerVan">
            <sch:p>data:opvolgerVan wijst naar een Work van een Regeling</sch:p>
            <sch:assert id="STOP1024" role="error" test="matches(./string(), '^/akn/(nl|aw|cw|sx)/act')">
                {"code": "STOP1024", "substring": "<sch:value-of select="./string()" />", "melding": "In opvolgerVan (<sch:value-of select="./string()" />) MOET verwezen worden naar een Work van een Regeling.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_011" see="data:TekstReferentie">
        <sch:title>data:uri moet corresponderen met data:soortRef</sch:title>
        <sch:rule context="data:TekstReferentie">
            <sch:let name="is_akn" value="./data:soortRef/string() = 'AKN'" />
            <sch:let name="is_jci" value="./data:soortRef/string() = 'JCI'" />
            <sch:let name="is_url" value="./data:soortRef/string() = 'URL'" />
            
            <sch:let name="akn_patroon" value="'^/akn/(nl|aw|cw|sx)/act'" />
            <sch:let name="jci_patroon" value="'^jci'" />
            <sch:let name="url_patroon" value="'^http?://'" />
            
            <sch:p>Het patroon in data:uri moet overeenkomen met zijn data:soortRef (URL: correcte
                http-ref, AKN: correcte AKN, JCI: correcte JCI)</sch:p>
            <sch:assert id="STOP1021" role="error"
                test="($is_akn and matches(./data:uri/string(), $akn_patroon)) or ($is_jci and matches(./data:uri/string(), $jci_patroon)) or ($is_url and matches(./data:uri/string(), $url_patroon))"
                > {"code": "STOP1021", "substring": "<sch:value-of select="./data:uri/string()" />", "melding": "De uri <sch:value-of select="./data:uri/string()" /> MOET corresponderen met de soortRef (URL: correcte http-ref, AKN: correcte AKN, JCI: correcte JCI). Pas deze aan.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_012_1">
        <sch:title>datum ondertekening verplicht voor off pub van besluit en verboden voor off pub van
            kennisgeving</sch:title>
        <sch:rule
            context="data:OfficielePublicatieMetadata[data:soortPublicatie = '/join/id/stop/soortpublicatie_001']">
            <sch:assert id="STOP1032" test="data:ondertekendOp"> {"code": "STOP1032", "melding": "De officiële publicatie van het besluit heeft geen datum ondertekening.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        <sch:rule
            context="data:OfficielePublicatieMetadata[data:soortPublicatie = '/join/id/stop/soortpublicatie_002']">
            <sch:report id="STOP1033" test="data:ondertekendOp"> {"code": "STOP1033", "melding": "De officiële publicatie van een besluit heeft ten onrechte een datum ondertekening.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_013_1">
        <sch:title>soortBestuursorgaan gevuld voor decentraal</sch:title>
        <sch:let name="is_decentraal" value="'gemeente|provincie|waterschap'" />
        <sch:rule context="
            data:RegelingMetadata[data:eindverantwoordelijke[matches(., $is_decentraal)]] |
            data:BesluitMetadata[data:eindverantwoordelijke[matches(., $is_decentraal)]]">
            <sch:report id="STOP1034"
                test="not(data:soortBestuursorgaan) or data:soortBestuursorgaan=''">{"code": "STOP1034", "melding": "soortBestuursorgaan MAG NIET leeg zijn voor gemeente, provincie of waterschap. Vul soortBestuursorgaan in.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_data_014_1">
        <sch:title>soortBestuursorgaan passend bij eindverantwoordelijke</sch:title>
        <sch:rule context="data:RegelingMetadata|data:BesluitMetadata">
            
            <sch:let name="is_gemeente" value="matches(./data:eindverantwoordelijke, 'gemeente')" />
            <sch:let name="is_waterschap" value="matches(./data:eindverantwoordelijke, 'waterschap')" />
            <sch:let name="is_provincie" value="matches(./data:eindverantwoordelijke, 'provincie')" />
            <sch:let name="is_staat" value="matches(./data:eindverantwoordelijke, 'ministerie')" />
            
            <sch:let name="gemeente_bestuursorgaan_patroon" value="'c_2c4e7407|c_28ecfd6d|c_2a7d8663|^$'" />
            <sch:let name="waterschap_bestuursorgaan_patroon"
                value="'c_70c87e3d|c_5cc92c89|c_f70a6113|^$'" />
            <sch:let name="provincie_bestuursorgaan_patroon" value="'c_e24d39f6|c_61676cbc|c_411b4e4a|^$'" />
            <sch:let name="staat_bestuursorgaan_patroon" value="'c_bcfb7b4e|c_91fb5e42|c_3aaa4d12|^$'" />
            
            <sch:assert id="STOP1035"
                test="
                ($is_gemeente and matches(./data:soortBestuursorgaan, $gemeente_bestuursorgaan_patroon)) or
                ($is_waterschap and matches(./data:soortBestuursorgaan, $waterschap_bestuursorgaan_patroon)) or
                ($is_provincie and matches(./data:soortBestuursorgaan, $provincie_bestuursorgaan_patroon)) or
                ($is_staat and matches(./data:soortBestuursorgaan, $staat_bestuursorgaan_patroon)) or (not(./data:eindverantwoordelijke))"
                >{"code": "STOP1035", "melding": "soortBestuursorgaan MOET corresponderen met eindverantwoordelijke. Pas soortBestuursorgaan of eindverantwoordelijke aan.", "ernst": "fout"},</sch:assert>
            
        </sch:rule>
    </sch:pattern>
    
    <!-- ================imop-procedure.sch================================================================================================================= -->
    
    <sch:ns prefix="data" uri="https://standaarden.overheid.nl/stop/imop/data/" />
    <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
    
    <sch:p>Versie 1.0.4</sch:p>
    <sch:p>Schematron voor aanvullende validatie voor procedureverlopen</sch:p>
    
    <sch:pattern id="sch_proc_001" see="data:Procedureverloop data:Procedureverloopmutatie">
        <sch:title>Unieke stapsoorten</sch:title>
        <sch:rule context="data:Procedureverloop | data:Procedureverloopmutatie">
            <sch:report id="STOP1036" role="error" test="//data:soortStap[.=following::data:soortStap]">
                {"code": "STOP1036", "soortstap": "<sch:value-of select="//data:soortStap[.=following::data:soortStap]" />", "melding": "Er zijn meer dan één procedurestappen met <sch:value-of select="//data:soortStap[.=following::data:soortStap]" /> aangetroffen. Elke stap moet voorzien zijn een unieke soort stap binnen het procedureverloop.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    
    <!-- ==================imop-se.sch=============================================================================================================== -->
    
    <sch:ns prefix="geo" uri="https://standaarden.overheid.nl/stop/imop/geo/"/>
    <sch:ns prefix="se" uri="http://www.opengis.net/se"/>
    <sch:ns prefix="ogc" uri="http://www.opengis.net/ogc"/>
    <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
    <sch:ns prefix="basisgeo" uri="http://www.geostandaarden.nl/basisgeometrie/1.0"/>
    <sch:ns prefix="gml" uri="http://www.opengis.net/gml/3.2"/>
    
    <sch:p>Versie 1.0.4</sch:p>
    <sch:p>Schematron voor aanvullende validatie voor het STOP-deel van de Symbol Encoding (se)
        standaard.</sch:p>
    
    <sch:pattern id="sch_se_001" see="se:FeatureTypeStyle">
        <sch:rule context="se:FeatureTypeStyle">
            <sch:assert id="STOP3100" role="warning" test="not(se:Name)">
                {"code": "STOP3100", "ID": "<sch:value-of select="./se:Name"/>", "melding": "De FeatureTypeStyle bevat een Name <sch:value-of select="./se:Name"/>, deze informatie wordt genegeerd.", "ernst": "waarschuwing"},</sch:assert>
            
            <sch:assert id="STOP3101" role="warning" test="not(se:Description)">
                {"code": "STOP3101", "ID": "<sch:value-of select="./se:Description/normalize-space()"/>", "melding": "De FeatureTypeStyle bevat een Description \"<sch:value-of select="./se:Description/normalize-space()"/>\", deze informatie wordt genegeerd.", "ernst": "waarschuwing"},</sch:assert>
            
            <sch:p>FeatureTypeStyle version MOET zijn "1.1.0".</sch:p>
            <sch:assert id="STOP3105" role="warning" test="./@version = '1.1.0'">
                {"code": "STOP3105", "ID": "<sch:value-of select="./@version"/>", "melding": "De FeatureTypeStyle versie is <sch:value-of select="./@version"/>, dit moet 1.1.0 zijn. Wijzig het SE versie nummer.", "ernst": "waarschuwing"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_002" see="se:FeatureTypeName">
        <sch:rule context="se:FeatureTypeName">
            <sch:assert id="STOP3102" role="error" test="(. = 'Locatie') or (substring-after(., ':') = 'Locatie')">
                {"code": "STOP3102", "ID": "<sch:value-of select="."/>", "melding": "De FeatureTypeStyle:FeatureTypeName is <sch:value-of select="."/>, dit moet Locatie zijn. Wijzig de FeatureTypeName in Locatie (evt. met een namespace prefix voor https://standaarden.overheid.nl/stop/imop/geo/).", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_003" see="se:SemanticTypeIdentifier">
        <sch:rule context="se:SemanticTypeIdentifier">
            <sch:let name="AllowedValue"
                value="'^(geometrie|groepID|kwalitatieveNormwaarde|kwantitatieveNormwaarde)$'"/>
            <sch:assert id="STOP3103" role="error" test="matches(substring-after(., ':'), $AllowedValue)">
                {"code": "STOP3103", "ID": "<sch:value-of select="."/>", "melding": "De FeatureTypeStyle:SemanticTypeIdentifier is <sch:value-of select="."/>, dit moet geo:geometrie, geo:groepID, geo:kwalitatieveNormwaarde of geo:kwantitatieveNormwaarde zijn (evt. met een andere namespace prefix voor https://standaarden.overheid.nl/stop/imop/geo/). Wijzig de SemanticTypeIdentifier.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_004" see="ogc:Filter">
        <sch:rule context="ogc:Filter">
            <sch:let name="SemanticTypeId"
                value="substring-after(preceding::se:SemanticTypeIdentifier, ':')"/>
            <sch:let name="AllowedValue"
                value="'^(groepID|kwalitatieveNormwaarde|kwantitatieveNormwaarde)$'"/>
            <sch:assert id="STOP3114" role="error" test="matches($SemanticTypeId, $AllowedValue)">
                {"code": "STOP3114", "ID": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>", "melding": "Rule heeft een Filter terwijl de SemanticTypeIdentifier <sch:value-of select="preceding::se:SemanticTypeIdentifier"/> is. Verwijder het Filter, of wijzig de SemanticTypeIdentifier in geo:groepID, geo:kwalitatieveNormwaarde of geo:kwantitatieveNormwaarde zijn (evt. met een andere namespace prefix voor https://standaarden.overheid.nl/stop/imop/geo/).", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_005" see="ogc:PropertyName">
        <sch:rule context="ogc:PropertyName">
            <sch:assert id="STOP3115" role="error" test=". = substring-after(preceding::se:SemanticTypeIdentifier, ':')">
                {"code": "STOP3115", "ID": "<sch:value-of select="."/>", "ID2": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>", "melding": "PropertyName is <sch:value-of select="."/>, dit moet overeenkomen met de SemanticTypeIdentifier <sch:value-of select="preceding::se:SemanticTypeIdentifier"/> (zonder namepace prefix). Corrigeer de PropertyName van het filter of pas de SemanticTypeIdentifier aan.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_006" see="ogc:Filter">
        <sch:rule
            context="ogc:PropertyIsBetween | ogc:PropertyIsNotEqualTo | ogc:PropertyIsLessThan | ogc:PropertyIsGreaterThan | ogc:PropertyIsLessThanOrEqualTo | ogc:PropertyIsGreaterThanOrEqualTo">
            <sch:let name="SemanticTypeId"
                value="substring-after(preceding::se:SemanticTypeIdentifier, ':')"/>
            <sch:let name="AllowedValue" value="'^(kwantitatieveNormwaarde)$'"/>
            <sch:assert id="STOP3118" role="error" test="matches($SemanticTypeId, $AllowedValue)">
                {"code": "STOP3118", "ID": "<sch:value-of select="preceding::se:SemanticTypeIdentifier"/>", "melding": "De SemanticTypeIdentifier is <sch:value-of select="preceding::se:SemanticTypeIdentifier"/>. De operator in Rule:Filter is alleen toegestaan bij SemanticTypeIdentifier geo:kwantitatieveNormwaarde (evt. met een andere namespace prefix voor https://standaarden.overheid.nl/stop/imop/geo/). Corrigeer de operator of pas de SemanticTypeIdentifier aan.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_007" see="ogc:And">
        <sch:rule context="ogc:And">
            <sch:assert id="STOP3120" role="error" test="./ogc:PropertyIsGreaterThanOrEqualTo and ./ogc:PropertyIsLessThan">
                {"code": "STOP3120", "ID": "<sch:value-of select="preceding::se:Name"/>", "melding": "In Rule met Rule:Name <sch:value-of select="preceding::se:Name"/> is de operator in Rule:Filter AND, maar de operanden zijn niet PropertyIsLessThan en PropertyIsGreaterThanOrEqualTo. Corrigeer de And expressie in het filter.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_008" see="se:Rule">
        <sch:rule context="se:Rule/se:Description/se:Title">
            <sch:assert id="STOP3126" role="error" test="./normalize-space() != ''">
                {"code": "STOP3126", "ID": "<sch:value-of select="preceding::se:Name"/>", "melding": "In Rule met Rule:Name <sch:value-of select="preceding::se:Name"/> is de Description:Title leeg, deze moet een tekst bevatten die in de legenda getoond kan worden. Voeg de legenda tekst toe aan de Description:Title.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_009" see="se:PointSymbolizer">
        <sch:rule context="se:PointSymbolizer">
            <sch:assert id="STOP3135" role="error" test="not(./se:Graphic/se:Mark/se:Fill/se:GraphicFill)">
                {"code": "STOP3135", "ID": "<sch:value-of select="./se:Name"/>", "melding": "De PointSymbolizer van Rule:Name <sch:value-of select="./se:Name"/> heeft een Mark:Fill:GraphicFill, dit is niet toegestaan. Gebruik SvgParameter.", "ernst": "fout"},</sch:assert>
            
            <sch:assert id="STOP3138" role="error" test="./se:Graphic/se:Mark/se:Fill/se:SvgParameter">
                {"code": "STOP3138", "ID": "<sch:value-of select="./se:Name"/>", "melding": "De PointSymbolizer van Rule:Name <sch:value-of select="./se:Name"/> heeft niet de vorm se:Graphic/se:Mark/se:Fill/se:GraphicFill/se:SvgParameter, dit is verplicht. Wijzig deze symbolizer.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_010" see="se:SvgParameter">
        <sch:rule context="se:SvgParameter[@name = 'stroke']">
            <sch:assert id="STOP3140" role="error" test="matches(./string(), '^#[0-9a-f]{6}$')">
                {"code": "STOP3140", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke\" waarde:<sch:value-of select="."/>, is ongeldig. Vul deze met een valide hexadecimale waarde.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
        <sch:rule context="se:SvgParameter[@name = 'fill']">
            <sch:assert id="STOP3147" role="error" test="matches(./string(), '^#[0-9a-f]{6}$')">
                {"code": "STOP3147", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"fill\" waarde: <sch:value-of select="."/>, is ongeldig. Vul deze met een valide hexadecimale waarde.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
        <sch:rule context="se:SvgParameter[@name = 'stroke-width']">
            <sch:assert id="STOP3141" role="error" test="matches(./string(), '^[0-9]+(.[0-9])?[0-9]?$')">
                {"code": "STOP3141", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-width\" waarde: <sch:value-of select="."/>, is ongeldig. Vul deze met een positief getal met 0,1 of 2 decimalen.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
        <sch:rule context="se:SvgParameter[@name = 'stroke-dasharray']">
            <sch:assert id="STOP3142" role="error" test="matches(./string(), '^([0-9]+ ?)*$')">
                {"code": "STOP3142", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-dasharray\" waarde: <sch:value-of select="."/>, is ongeldig. Vul deze met setjes van 2 positief gehele getallen gescheiden door spaties.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
        <sch:rule context="se:SvgParameter[@name = 'stroke-linecap']">
            <sch:assert id="STOP3143" role="error" test="./string() = 'butt'">
                {"code": "STOP3143", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-linecap\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in \"butt\".", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
        <sch:rule context="se:SvgParameter[@name = 'stroke-opacity']">
            <sch:assert id="STOP3144" role="error" test="matches(./string(), '^0((.[0-9])?[0-9]?)|1((.0)?0?)$')">
                {"code": "STOP3144", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-opacity\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in een decimaal positief getal tussen 0 en 1 (beide inclusief) met 0,1 of 2 decimalen.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
        <sch:rule context="se:SvgParameter[@name = 'fill-opacity']">
            <sch:assert id="STOP3148" role="error" test="matches(./string(), '^0((.[0-9])?[0-9]?)|1((.0)?0?)$')">
                {"code": "STOP3148", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"fill-opacity\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in een decimaal positief getal tussen 0 en 1 (beide inclusief) met 0,1 of 2 decimalen.", "ernst": "fout"},</sch:assert>
        </sch:rule>
        
        <sch:rule context="se:SvgParameter[@name = 'stroke-linejoin']">
            <sch:assert id="STOP3145" role="error" test="./string() = 'round'">
                {"code": "STOP3145", "ID": "<sch:value-of select="."/>", "melding": "SvgParameter name=\"stroke-linejoin\" waarde: <sch:value-of select="."/>, is ongeldig. Wijzig deze in \"round\".", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_011" see="se:Stroke/SvgParameter">
        <sch:rule context="se:Stroke/se:SvgParameter">
            <sch:let name="AllowedValue"
                value="'^(stroke|stroke-width|stroke-dasharray|stroke-linecap|stroke-opacity|stroke-linejoin)$'"/>
            <sch:assert id="STOP3139" role="error" test="matches(./@name, $AllowedValue)"> 
                {"code": "STOP3139", "ID": "<sch:value-of select="./@name"/>", "melding": "Een Stroke:SvgParameter met een ongeldig name attribute <sch:value-of select="./@name"/>. Maak hier een valide name attribute van.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_012" see="se:Fill/se:SvgParameter">
        <sch:rule context="se:Fill/se:SvgParameter">
            <sch:let name="AllowedValue" value="'^(fill|fill-opacity)$'"/>
            <sch:assert id="STOP3146" role="error" test="matches(./@name, $AllowedValue)"> 
                {"code": "STOP3146", "ID": "<sch:value-of select="./@name"/>", "melding": "Een Fill:SvgParameter met een ongeldig name attribute <sch:value-of select="./@name"/>. Maak hier een valide name-attribute van.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_013" see="se:WellKnownName">
        <sch:rule context="se:WellKnownName">
            <sch:let name="AllowedValue" value="'^(cross|cross_fill|square|circle|star|triangle)$'"/>
            <sch:assert id="STOP3157" role="error" test="matches(., $AllowedValue)">
                {"code": "STOP3157", "ID": "<sch:value-of select="."/>", "melding": "De Mark:WellKnownName <sch:value-of select="."/> is niet toegestaan. Maak hier cross(of cross_fill), square, circle, star of triangle van.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_014" see="se:Size">
        <sch:rule context="se:Size">
            <sch:assert id="STOP3163" role="error" test="matches(./string(), '^[0-9]+$')">
                {"code": "STOP3163", "ID": "<sch:value-of select="../../se:Name"/>", "ID2": "<sch:value-of select="."/>", "melding": "De (Point/Polygon)symbolizer met se:Name <sch:value-of select="../../se:Name"/> heeft een ongeldige Graphic:Size <sch:value-of select="."/>. Wijzig deze in een geheel positief getal.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_015" see="se:Rotation">
        <sch:rule context="se:Rotation">
            <sch:assert id="STOP3164" role="error" test="matches(./string(), '^\-?[0-9]([0-9][0-9]?)?(.[0-9][0-9]?)?$')">
                {"code": "STOP3164", "ID": "<sch:value-of select="../../se:Name"/>", "ID2": "<sch:value-of select="."/>", "melding": "De (Point/Polygon)symbolizer met se:Name <sch:value-of select="../../se:Name"/> heeft een ongeldige Graphic:Rotation <sch:value-of select="."/>. Wijzig deze in een getal met maximaal 2 decimalen.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_016" see="se:PolygonSymbolizer/se:Fill/se:GraphicFill/se:Graphic">
        <sch:rule context="se:PolygonSymbolizer/se:Fill/se:GraphicFill/se:Graphic">
            <sch:assert id="STOP3170" role="error" test="./se:ExternalGraphic and not(./se:Mark)">
                {"code": "STOP3170", "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>", "melding": "De PolygonSymbolizer:Fill:GraphicFill:Graphic met Name <sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/> bevat geen se:ExternalGraphic of ook een se:Mark, dit is wel vereist. Voeg een se:ExternalGraphic element toe.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_017" see="se:InlineContent[@encoding='base64']">
        <sch:rule context="se:InlineContent[@encoding = 'base64']">
            <sch:assert id="STOP3173" role="error" test="matches(./normalize-space(), '^[A-Z0-9a-z+/ =]*$')">
                {"code": "STOP3173", "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>", "ID2": "<sch:value-of select="normalize-space(replace(./string(), '[A-Z0-9a-z+/ =]', ''))"/>", "melding": "De PolygonSymbolizer:Fill:GraphicFill:Graphic:ExternalGraphic:InlineContent van Rule:Name <sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/> bevat ongeldige tekens <sch:value-of select="normalize-space(replace(./string(), '[A-Z0-9a-z+/ =]', ''))"/>. Wijzig dit. Een base64 encodig mag alleen bestaan uit: hoofd- en kleine letters, cijfers, spaties, plus-teken, /-teken en =-teken.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <sch:pattern id="sch_se_018" see="se:ExternalGraphic/se:Format">
        <sch:rule context="se:ExternalGraphic/se:Format">
            <sch:assert id="STOP3174" role="error" test="./string() = 'image/png'">
                {"code": "STOP3174", "ID": "<sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/>", "ID2": "<sch:value-of select="."/>", "melding": "De ExternalGraphic:Format van (Polygon)symbolizer:Name <sch:value-of select="ancestor::se:PolygonSymbolizer/se:Name"/> heeft een ongeldig Format <sch:value-of select="."/>. Wijzig deze in image/png", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    <!-- ==================imop-tekst.sch=============================================================================================================== -->
    
      <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/"/>
  <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform"/>
  <!-- -->
  <sch:p>Versie 1.0.4</sch:p>
  <sch:p>Schematron voor aanvullende validatie voor imop-tekst.xsd</sch:p>
  <sch:pattern id="sch_tekst_001" see="tekst:Lijst tekst:Li tekst:LiNummer">
    <sch:title>Lijst - Nummering lijstitems</sch:title>
    <sch:rule context="tekst:Lijst[@type = 'ongemarkeerd']">
      <sch:assert id="STOP0001" role="error" test="count(tekst:Li/tekst:LiNummer) = 0"> {"code": "STOP0001", "eId": "<sch:value-of select="@eId"/>", "melding": "De Lijst met eId <sch:value-of select="@eId"/> van type 'ongemarkeerd' heeft LiNummer-elementen met een nummering of symbolen, dit is niet toegestaan. Pas het type van de lijst aan of verwijder de LiNummer-elementen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
    <!--  -->
    <sch:rule context="tekst:Lijst[@type = 'expliciet']">
      <sch:assert id="STOP0002" role="error"
        test="count(tekst:Li[tekst:LiNummer]) = count(tekst:Li)"> {"code": "STOP0002", "eId": "<sch:value-of select="@eId"/>", "melding": "De Lijst met eId <sch:value-of select="@eId"/> van type 'expliciet' heeft geen LiNummer elementen met nummering of symbolen, het gebruik van LiNummer is verplicht. Pas het type van de lijst aan of voeg LiNummer's met nummering of symbolen toe aan de lijst-items", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_022" see="tekst:Al">
    <sch:title>Alinea - Bevat content</sch:title>
    <sch:rule context="tekst:Al">
      <sch:report id="STOP0005" role="error"
        test="normalize-space(.) = '' and not(tekst:InlineTekstAfbeelding)"> {"code": "STOP0005", "element": "<sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "De alinea voor element <sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/> met id <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/> bevat geen tekst. Verwijder de lege alinea", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_027" see="tekst:Kop">
    <sch:title>Kop - Bevat content</sch:title>
    <sch:rule context="tekst:Kop">
      <sch:report id="STOP0006" role="error" test="normalize-space(.) = ''"> {"code": "STOP0006", "element": "<sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "De kop voor element <sch:value-of select="ancestor::tekst:*[@eId][1]/local-name()"/> met id <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/> bevat geen tekst. Corrigeer de kop of verplaats de inhoud naar een ander element", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_003" see="tekst:table tekst:NootRef">
    <sch:title>Tabel - Referenties naar een noot</sch:title>
    <sch:rule context="tekst:table//tekst:Nootref">
      <sch:let name="nootID" value="@refid"/>
      <sch:assert id="STOP0008" test="ancestor::tekst:table//tekst:Noot[@id = $nootID]"> {"code": "STOP0008", "ref": "<sch:value-of select="@refid"/>", "eId": "<sch:value-of
          select="ancestor::tekst:table/@eId"/>", "melding": "De referentie naar de noot met id <sch:value-of select="@refid"/> verwijst niet naar een noot in dezelfde tabel <sch:value-of
          select="ancestor::tekst:table/@eId"/>. Verplaats de noot waarnaar verwezen wordt naar de tabel of vervang de referentie in de tabel voor de noot waarnaar verwezen wordt", "ernst": "fout"},</sch:assert>
    </sch:rule>
    <sch:rule context="tekst:Nootref">
      <sch:let name="nootID" value="@refid"/>
      <sch:assert id="STOP0007" test="ancestor::tekst:table"> {"code": "STOP0007", "ref": "<sch:value-of select="@refid"/>", "melding": "De referentie naar de noot met id <sch:value-of select="@refid"/> staat niet in een tabel. Vervang de referentie naar de noot voor de noot waarnaar verwezen wordt", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_004" see="tekst:Lijst tekst:Li tekst:table">
    <sch:title>Lijst - plaatsing tabel in een lijst</sch:title>
    <sch:rule context="tekst:Li[tekst:table]">
      <sch:report id="STOP0009" role="warning"
        test="self::tekst:Li/tekst:table and not(ancestor::tekst:Instructie)"> {"code": "STOP0009", "eId": "<sch:value-of select="@eId"/>", "melding": "Het lijst-item <sch:value-of select="@eId"/> bevat een tabel, onderzoek of de tabel buiten de lijst kan worden geplaatst, eventueel door de lijst in delen op te splitsen", "ernst": "waarschuwing"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="sch_tekst_032" see="tekst:Illustratie tekst:InlineTekstAfbeelding">
    <sch:title>Illustratie - attributen kleur en schaal worden niet ondersteund</sch:title>
    <sch:rule context="tekst:Illustratie | tekst:InlineTekstAfbeelding">
      <sch:report id="STOP0045" role="warning" test="@schaal"> {"code": "STOP0045", "ouder": "<sch:value-of select="local-name(ancestor::*[@eId][1])"/>", "eId": "<sch:value-of
          select="ancestor::*[@eId][1]/@eId"/>", "melding": "De Illustratie binnen <sch:value-of select="local-name(ancestor::*[@eId][1])"/> met eId <sch:value-of
          select="ancestor::*[@eId][1]/@eId"/> heeft een waarde voor attribuut @schaal. Dit attribuut wordt genegeerd in de publicatie van documenten volgens STOP 1.0.4. In plaats daarvan wordt het attribuut @dpi gebruikt voor de berekening van de afbeeldingsgrootte. Verwijder het attribuut @schaal.", "ernst": "waarschuwing"},</sch:report>
      <sch:report id="STOP0046" role="warning" test="@kleur"> {"code": "STOP0046", "ouder": "<sch:value-of select="local-name(ancestor::*[@eId][1])"/>", "eId": "<sch:value-of
          select="ancestor::*[@eId][1]/@eId"/>", "melding": "De Illustratie binnen <sch:value-of select="local-name(ancestor::*[@eId][1])"/> met eId <sch:value-of
          select="ancestor::*[@eId][1]/@eId"/> heeft een waarde voor attribuut @kleur. Dit attribuut wordt genegeerd in de publicatie van STOP 1.0.4. Verwijder het attribuut @kleur.", "ernst": "waarschuwing"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_005" see="tekst:Divisietekst tekst:Kop">
    <sch:title>Divisietekst - gebruik verplichte Kop</sch:title>
    <sch:rule
      context="tekst:Divisietekst[not(child::tekst:Kop)][ancestor::tekst:Bijlage[starts-with(@wId, 'mnre1034_1-0__cmp_') or starts-with(@wId, 'mnre1034_2-0__cmp_')]]">
      <sch:assert id="STOP0042" role="warning"
        test="parent::tekst:Bijlage and (count(parent::tekst:*/tekst:Divisietekst) + count(parent::tekst:*/tekst:Divisie) = 1)"
        > {"code": "STOP0042", "eId": "<sch:value-of select="@eId"/>", "melding": "Een Kop voor Divisietekst met eId <sch:value-of select="@eId"/> is eigenlijk verplicht; maar deze waarschuwing is alleen voor de Omgevingsregeling (OR) niet blokkerend.", "ernst": "waarschuwing"},</sch:assert>
    </sch:rule>
    <sch:rule
      context="tekst:Divisietekst[not(child::tekst:Kop)][not(ancestor::tekst:RegelingMutatie)]">
      <sch:assert id="STOP0041" role="error"
        test="(parent::tekst:Bijlage | parent::tekst:Toelichting | parent::tekst:Motivering | parent::tekst:AlgemeneToelichting | ancestor::tekst:Kennisgeving) and (count(parent::tekst:*/tekst:Divisietekst) + count(parent::tekst:*/tekst:Divisie) = 1)"
        > {"code": "STOP0041", "eId": "<sch:value-of select="@eId"/>", "melding": "Een Kop voor Divisietekst met eId <sch:value-of select="@eId"/> is verplicht. Voeg een valide Kop aan deze Divisietekst toe, wijzig Divisietekst naar Inleidendetekst, of wijzig het bovenliggende element Divisie naar Divisietekst", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    INTERNE REFERENTIES HEBBEN CORRECTE VERWIJZINGEN
  -->
  <sch:pattern id="sch_tekst_006" see="tekst:IntRef">
    <sch:title>Referentie intern - correcte verwijzing</sch:title>
    <sch:rule context="tekst:IntRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref"/>
      <sch:assert id="STOP0010" role="error" test="//*[@eId = $doelwit] | //*[@wId = $doelwit]"> {"code": "STOP0010", "element": "<sch:name/>", "ref": "<sch:value-of select="$doelwit"
        />", "melding": "De @ref van element <sch:name/> met waarde <sch:value-of select="$doelwit"
        /> verwijst niet naar een bestaande identifier van een tekst-element in de tekst van dezelfde expression als waar de verwijzing in staat. Controleer de referentie, corrigeer of de referentie of de identificatie van het element waarnaar wordt verwezen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <sch:pattern id="sch_tekst_034" see="tekst:IntRef">
    <sch:title>Interne referentie - correcte scope</sch:title>
    <sch:rule context="tekst:IntRef[@scope]">
      <sch:let name="alle-elementnamen-met-eId"
        value="'^(Aanhef|Afdeling|AlgemeneToelichting|Artikel|ArtikelgewijzeToelichting|Begrip|Begrippenlijst|BesluitCompact |Bijlage|Boek|Citaat|Deel|Divisie|Divisietekst|ExtIoRef|Figuur|Formule|Hoofdstuk|InleidendeTekst|IntIoRef|Kadertekst|Li|Lichaam|Lid|Lijst|Motivering|Paragraaf|RegelingOpschrift|Sluiting|Subparagraaf|Subsubparagraaf|Titel|Toelichting|WijzigArtikel|WijzigBijlage|WijzigLid|table)$'"/>
      <sch:assert test="matches(normalize-space(@scope), $alle-elementnamen-met-eId)">
        {"code": "STOP0052", "scope": "<sch:value-of select="@scope"/>", "ref": "<sch:value-of
          select="@ref"/>", "melding": "De scope <sch:value-of select="@scope"/> van de IntRef met <sch:value-of
          select="@ref"/> bevat niet een in het tekst-schema gedefinieerde naam van een verwijsbaar element. Geef de juiste elementnaam in attribuut scope.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_028" see="tekst:IntIoRef">
    <sch:title>Referentie informatieobject - correcte verwijzing</sch:title>
    <sch:rule context="tekst:IntIoRef[not(ancestor::tekst:RegelingMutatie)]">
      <sch:let name="doelwit" value="@ref"/>
      <sch:assert id="STOP0011" role="error" test="//tekst:ExtIoRef[@wId = $doelwit]"> {"code": "STOP0011", "element": "<sch:name/>", "ref": "<sch:value-of select="$doelwit"
        />", "melding": "De @ref van element <sch:name/> met waarde <sch:value-of select="$doelwit"
        /> verwijst niet naar een wId van een ExtIoRef binnen hetzelfde bestand. Controleer de referentie, corrigeer of de referentie of de wId identificatie van het element waarnaar wordt verwezen", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_007" see="tekst:ExtIoRef">
    <sch:title>Referentie extern informatieobject</sch:title>
    <sch:rule context="tekst:ExtIoRef">
      <sch:let name="ref" value="normalize-space(@ref)"/>
      <sch:assert id="STOP0012" role="error" test="normalize-space(.) = $ref"> {"code": "STOP0012", "eId": "<sch:value-of select="@eId"/>", "melding": "De JOIN identifier van ExtIoRef <sch:value-of select="@eId"/> in de tekst is niet gelijk aan de als referentie opgenomen JOIN-identificatie. Controleer de gebruikte JOIN-identicatie en plaats de juiste verwijzing als zowel de @ref als de tekst van het element ExtIoRef", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_008" see="tekst:agAKN">
    <sch:title>Identificatie - correct gebruik wId, eId </sch:title>
    <sch:rule context="//*[@eId]">
      <sch:let name="doelwitE" value="@eId"/>
      <sch:let name="doelwitW" value="@wId"/>
      <sch:report id="STOP0013" role="error" test="ends-with($doelwitE, '.')"> {"code": "STOP0013", "eId": "<sch:value-of select="@eId"/>", "element": "<sch:name/>", "melding": "Het attribuut @eId of een deel van de eId <sch:value-of select="@eId"/> van element <sch:name/> eindigt op een '.', dit is niet toegestaan. Verwijder de laatste punt(en) '.' voor deze eId", "ernst": "fout"},</sch:report>
      <sch:report id="STOP0043" role="error" test="contains($doelwitE, '.__')"> {"code": "STOP0043", "eId": "<sch:value-of select="@eId"/>", "element": "<sch:name/>", "melding": "Het attribuut @eId of een deel van de eId <sch:value-of select="@eId"/> van element <sch:name/> eindigt op '.__', dit is niet toegestaan. Verwijder deze punt '.' binnen deze eId", "ernst": "fout"},</sch:report>
      <sch:report id="STOP0014" role="error" test="ends-with($doelwitW, '.')"> {"code": "STOP0014", "wId": "<sch:value-of select="@wId"/>", "element": "<sch:name/>", "melding": "Het attribuut @wId <sch:value-of select="@wId"/> van element <sch:name/> eindigt op een '.', dit is niet toegestaan. Verwijder de laatste punt '.' van deze wId", "ernst": "fout"},</sch:report>
      <sch:report id="STOP0044" role="error" test="contains($doelwitW, '.__')"> {"code": "STOP0044", "wId": "<sch:value-of select="@wId"/>", "element": "<sch:name/>", "melding": "Het attribuut @wId <sch:value-of select="@wId"/> van element <sch:name/> eindigt op een '.__', dit is niet toegestaan. Verwijder deze punt '.' binnen deze wId", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_023" see="tekst:RegelingTijdelijkdeel tekst:WijzigArtikel">
    <sch:title>RegelingTijdelijkdeel - WijzigArtikel niet toegestaan</sch:title>
    <sch:rule context="tekst:RegelingTijdelijkdeel//tekst:WijzigArtikel">
      <sch:report id="STOP0015" test="self::tekst:WijzigArtikel"> {"code": "STOP0015", "eId": "<sch:value-of select="@eId"/>", "melding": "Het WijzigArtikel <sch:value-of select="@eId"/> is in een RegelingTijdelijkdeel niet toegestaan. Verwijder het WijzigArtikel of pas dit aan naar een Artikel indien dit mogelijk is", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_026" see="tekst:RegelingCompact tekst:WijzigArtikel">
    <sch:title>RegelingCompact - WijzigArtikel niet toegestaan</sch:title>
    <sch:rule context="tekst:RegelingCompact//tekst:WijzigArtikel">
      <sch:report id="STOP0016" test="self::tekst:WijzigArtikel"> {"code": "STOP0016", "eId": "<sch:value-of select="@eId"/>", "melding": "Het WijzigArtikel <sch:value-of select="@eId"/> is in een RegelingCompact niet toegestaan. Verwijder het WijzigArtikel of pas dit aan naar een Artikel indien dit mogelijk is", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!-- 
    Renvooi markering alleen toegestaan binnen een tekst:RegelingMutatie
  -->
  <sch:pattern id="sch_tekst_009"
    see="tekst:RegelingMutatie tekst:NieuweTekst
    tekst:VerwijderdeTekst">
    <sch:title>RegelingMutatie - Wijzigingen tekstueel</sch:title>
    <sch:rule context="//tekst:NieuweTekst | //tekst:VerwijderdeTekst">
      <sch:p>Een tekstuele mutatie ten behoeve van renvooi MAG NIET buiten een RegelingMutatie
        voorkomen</sch:p>
      <sch:assert id="STOP0017" role="error" test="ancestor::tekst:RegelingMutatie"> {"code": "STOP0017", "ouder": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "element": "<sch:name/>", "melding": "Tekstuele wijziging is niet toegestaan buiten de context van een tekst:RegelingMutatie. element <sch:value-of select="local-name(parent::tekst:*)"/> met id \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>\" bevat een <sch:name/>. Verwijder het element <sch:name/>", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_010" see="tekst:RegelingMutatie tekst:agWijzigacties">
    <sch:title>RegelingMutatie - Wijzigingen structuur</sch:title>
    <sch:rule context="//tekst:*[@wijzigactie]">
      <sch:p>Een structuur wijziging MAG NIET buiten een RegelingMutatie voorkomen</sch:p>
      <sch:assert id="STOP0018" role="error" test="ancestor::tekst:RegelingMutatie"> {"code": "STOP0018", "element": "<sch:value-of select="local-name()"/>", "eId": "<sch:value-of
          select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>", "melding": "Een attribuut @wijzigactie is niet toegestaan op element <sch:value-of select="local-name()"/> met id \"<sch:value-of
          select="ancestor-or-self::tekst:*[@eId][1]/@eId"/>\" buiten de context van een tekst:RegelingMutatie. Verwijder het attribuut @wijzigactie", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--
    Unieke eId en wId's voor Besluiten en Regelingen
  -->
  <xsl:key
    match="tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleEIDs" use="@eId"/>
  <xsl:key
    match="tekst:*[@wId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]"
    name="alleWIDs" use="@wId"/>
  <sch:pattern id="sch_tekst_011" see="tekst:agAKN">
    <sch:title>Identificatie - Alle wId en eId buiten een AKN-component zijn uniek</sch:title>
    <sch:rule
      context="tekst:*[@eId][not(ancestor-or-self::tekst:*[@componentnaam])][not(ancestor-or-self::tekst:WijzigInstructies)]">
      <sch:assert id="STOP0020" role="error" test="count(key('alleEIDs', @eId)) = 1"> {"code": "STOP0020", "eId": "<sch:value-of select="@eId"/>", "melding": "De eId '<sch:value-of select="@eId"/>' binnen het bereik is niet uniek. Controleer de opbouw van de eId en corrigeer deze", "ernst": "fout"},</sch:assert>
      <sch:assert id="STOP0021" role="error" test="count(key('alleWIDs', @wId)) = 1"> {"code": "STOP0021", "wId": "<sch:value-of select="@wId"/>", "melding": "De wId '<sch:value-of select="@wId"/>' binnen het bereik is niet uniek. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_020" see="tekst:agAKN">
    <sch:title>Identificatie - AKN-naamgeving voor eId en wId</sch:title>
    <sch:rule context="*[@eId]">
      <sch:let name="AKNnaam">
        <xsl:choose>
          <xsl:when test="matches(local-name(), 'Lichaam')">body</xsl:when>
          <xsl:when test="matches(local-name(), 'RegelingOpschrift')">longTitle</xsl:when>
          <xsl:when test="matches(local-name(), 'AlgemeneToelichting')">genrecital</xsl:when>
          <xsl:when test="matches(local-name(), '^ArtikelgewijzeToelichting$')"
            >artrecital</xsl:when>
          <xsl:when test="matches(local-name(), 'Artikel|WijzigArtikel')">art</xsl:when>
          <xsl:when test="matches(local-name(), 'WijzigLid|Lid')">para</xsl:when>
          <xsl:when test="matches(local-name(), 'Divisietekst')">content</xsl:when>
          <xsl:when test="matches(local-name(), 'Divisie')">div</xsl:when>
          <xsl:when test="matches(local-name(), 'Boek')">book</xsl:when>
          <xsl:when test="matches(local-name(), 'Titel')">title</xsl:when>
          <xsl:when test="matches(local-name(), 'Deel')">part</xsl:when>
          <xsl:when test="matches(local-name(), 'Hoofdstuk')">chp</xsl:when>
          <xsl:when test="matches(local-name(), 'Afdeling')">subchp</xsl:when>
          <xsl:when test="matches(local-name(), 'Paragraaf|Subparagraaf|Subsubparagraaf')"
            >subsec</xsl:when>
          <xsl:when test="matches(local-name(), 'WijzigBijlage|Bijlage')">cmp</xsl:when>
          <xsl:when test="matches(local-name(), 'Inhoudsopgave')">toc</xsl:when>
          <xsl:when test="matches(local-name(), 'Motivering')">acc</xsl:when>
          <xsl:when test="matches(local-name(), 'Toelichting')">recital</xsl:when>
          <xsl:when test="matches(local-name(), 'InleidendeTekst')">intro</xsl:when>
          <xsl:when test="matches(local-name(), 'Aanhef')">formula_1</xsl:when>
          <xsl:when test="matches(local-name(), 'Kadertekst')">recital</xsl:when>
          <xsl:when test="matches(local-name(), 'Sluiting')">formula_2</xsl:when>
          <xsl:when test="matches(local-name(), 'table')">table</xsl:when>
          <xsl:when test="matches(local-name(), 'Figuur')">img</xsl:when>
          <xsl:when test="matches(local-name(), 'Formule')">math</xsl:when>
          <xsl:when test="matches(local-name(), 'Citaat')">cit</xsl:when>
          <xsl:when test="matches(local-name(), 'Begrippenlijst|Lijst')">list</xsl:when>
          <xsl:when test="matches(local-name(), 'Li|Begrip')">item</xsl:when>
          <xsl:when test="matches(local-name(), 'IntIoRef|ExtIoRef')">ref</xsl:when>
          <xsl:otherwise>X</xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:let name="mijnEID">
        <xsl:choose>
          <xsl:when test="contains(@eId, '__')">
            <xsl:value-of select="tokenize(@eId, '__')[last()]"/>
          </xsl:when>
          <xsl:otherwise>
            <xsl:value-of select="@eId"/>
          </xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:let name="mijnWID">
        <xsl:value-of select="tokenize(@wId, '__')[last()]"/>
      </sch:let>
      <sch:assert id="STOP0022" test="starts-with($mijnEID, $AKNnaam)"> {"code": "STOP0022", "AKNdeel": "<sch:value-of select="$mijnEID"/>", "element": "<sch:name/>", "waarde": "<sch:value-of select="$AKNnaam"/>", "wId": "<sch:value-of select="@wId"/>", "melding": "De AKN-naamgeving voor eId '<sch:value-of select="$mijnEID"/>' is niet correct voor element <sch:name/> met id '<sch:value-of select="@wId"/>', Dit moet zijn: '<sch:value-of select="$AKNnaam"/>'. Pas de naamgeving voor dit element en alle onderliggende elementen aan. Controleer ook de naamgeving van de bijbehorende wId en onderliggende elementen.", "ernst": "fout"},</sch:assert>
      <sch:p>Een wId MOET voldoen aan de AKN-naamgevingsconventie</sch:p>
      <sch:assert id="STOP0023" test="starts-with($mijnWID, $AKNnaam)"> {"code": "STOP0023", "AKNdeel": "<sch:value-of select="$mijnWID"/>", "element": "<sch:name/>", "waarde": "<sch:value-of select="$AKNnaam"/>", "wId": "<sch:value-of select="@wId"/>", "melding": "De AKN-naamgeving voor wId '<sch:value-of select="$mijnWID"/>' is niet correct voor element <sch:name/> met id '<sch:value-of select="@wId"/>', Dit moet zijn: '<sch:value-of select="$AKNnaam"/>'. Pas de naamgeving voor dit element en alle onderliggende elementen aan. Controleer ook de naamgeving van de bijbehorende eId en onderliggende elementen.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <!-- VOOR TABELLEN EEN REEKS CONTROLES OP CALS REGELS -->
  <!--  -->
  <sch:pattern id="sch_tekst_014" see="tekst:table tekst:tgroup">
    <sch:title>Tabel - minimale opbouw</sch:title>
    <sch:rule context="tekst:table">
      <sch:assert id="STOP0029" role="error" test="number(tekst:tgroup/@cols) >= 2"> {"code": "STOP0029", "eId": "<sch:value-of select="@eId"/>", "melding": "De tabel met <sch:value-of select="@eId"/> heeft slechts 1 kolom, dit is niet toegestaan. Pas de tabel aan, of plaats de inhoud van de tabel naar bijvoorbeeld een element Kadertekst", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_016" see="tekst:table tekst:entry">
    <sch:title>Tabel - positie en identificatie van een tabelcel</sch:title>
    <sch:rule context="tekst:entry[@namest and @colname]">
      <sch:let name="start" value="@namest"/>
      <sch:let name="col" value="@colname"/>
      <sch:p>Bij horizontale overspanning MOET de eerste cel ook de start van de overspanning
        zijn</sch:p>
      <sch:assert id="STOP0033" role="error" test="$col = $start"> {"code": "STOP0033", "naam": "<sch:value-of select="@namest"/>", "nummer": "<sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder": "<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "melding": "De start van de overspanning (@namest) van de cel <sch:value-of select="@namest"/>, in de <sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>e rij, van de <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/> van tabel <sch:value-of select="ancestor::tekst:table/@eId"/> is niet gelijk aan de @colname van de cel.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:rule context="tekst:entry[@namest][@nameend]">
      <sch:p>Bij horizontale overspanning MOET de positie van @nameend groter zijn dan de positie
        van @namest</sch:p>
      <sch:let name="start" value="@namest"/>
      <sch:let name="end" value="@nameend"/>
      <sch:assert id="STOP0032" role="error"
        test="xs:integer(ancestor::tekst:tgroup/tekst:colspec[@colname = $start]/@colnum) &lt;= xs:integer(ancestor::tekst:tgroup/tekst:colspec[@colname = $end]/@colnum)"
        > {"code": "STOP0032", "naam": "<sch:value-of select="@namest"/>", "nummer": "<sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder": "<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "melding": "De entry met @namest \"<sch:value-of select="@namest"/>\", van de <sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>e rij, van de <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>, in de tabel met eId: <sch:value-of select="ancestor::tekst:table/@eId"/>, heeft een positie bepaling groter dan de positie van de als @nameend genoemde cel. Corrigeer de gegevens voor de overspanning.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern>
    <sch:rule context="tekst:entry[@colname]">
      <sch:p>De referentie van een cel MOET correct verwijzen naar een kolom</sch:p>
      <sch:let name="id" value="@colname"/>
      <sch:report id="STOP0036" role="error"
        test="not(ancestor::tekst:tgroup/tekst:colspec[@colname = $id])"> {"code": "STOP0036", "naam": "colname", "nummer": "<sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>", "ouder": "<sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "melding": "De entry met @colname van de <sch:value-of
          select="count(parent::tekst:row/preceding-sibling::tekst:row) + 1"/>e rij, van <sch:value-of select="local-name(ancestor::tekst:thead | ancestor::tekst:tbody)"/>, van de tabel met id: <sch:value-of select="ancestor::tekst:table/@eId"/> , verwijst niet naar een bestaande kolom. Controleer en corrigeer de identifier voor de kolom (@colname)", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_017" see="tekst:table">
    <sch:title>Tabel - het aantal cellen is correct</sch:title>
    <sch:rule context="tekst:tgroup/tekst:thead | tekst:tgroup/tekst:tbody">
      <sch:let name="totaalCellen" value="count(tekst:row) * number(parent::tekst:tgroup/@cols)"/>
      <sch:let name="colPosities">
        <xsl:for-each select="parent::tekst:tgroup/tekst:colspec">
          <col colnum="{@colnum}" name="{@colname}"/>
        </xsl:for-each>
      </sch:let>
      <sch:let name="cellen" value="count(//tekst:entry[not(@wijzigactie = 'verwijder')])"/>
      <sch:let name="spanEinde">
        <xsl:for-each
          select="self::tekst:tbody//tekst:entry[not(@wijzigactie = 'verwijder')] | self::tekst:thead//tekst:entry[not(@wijzigactie = 'verwijder')]">
          <xsl:variable as="xs:string?" name="namest" select="@namest"/>
          <xsl:variable as="xs:string?" name="nameend" select="@nameend"/>
          <xsl:variable as="xs:integer?" name="numend"
            select="$colPosities/*[@name = $nameend]/@colnum"/>
          <xsl:variable as="xs:integer?" name="numst"
            select="$colPosities/*[@name = $namest]/@colnum"/>
          <nr>
            <xsl:choose>
              <xsl:when test="$numend and $numst and @morerows">
                <xsl:value-of select="($numend - $numst + 1) * (@morerows + 1)"/>
              </xsl:when>
              <xsl:when test="$numend and $numst">
                <xsl:value-of select="$numend - $numst + 1"/>
              </xsl:when>
              <xsl:when test="@morerows">
                <xsl:value-of select="1 + @morerows"/>
              </xsl:when>
              <xsl:otherwise>1</xsl:otherwise>
            </xsl:choose>
          </nr>
        </xsl:for-each>
      </sch:let>
      <sch:let name="spannend" value="sum($spanEinde/*)"/>
      <sch:p>Het aantal colspec's MOET gelijk zijn aan het opgegeven aantal kolommen.</sch:p>
      <sch:assert id="STOP0037" role="error"
        test="number(parent::tekst:tgroup/@cols) = count(parent::tekst:tgroup/tekst:colspec)"> {"code": "STOP0037", "nummer": "<sch:value-of
          select="count(parent::tekst:tgroup/tekst:colspec)"/>", "naam": "<sch:name/>", "eId": "<sch:value-of select="ancestor::tekst:table/@eId"/>", "aantal": "<sch:value-of
          select="parent::tekst:tgroup/@cols"/>", "melding": "Het aantal colspec's (<sch:value-of
          select="count(parent::tekst:tgroup/tekst:colspec)"/>) voor <sch:name/> in tabel <sch:value-of select="ancestor::tekst:table/@eId"/> komt niet overeen met het aantal kolommen (<sch:value-of
          select="parent::tekst:tgroup/@cols"/>).", "ernst": "fout"},</sch:assert>
      <sch:p>Het totale aantal cellen MOET overeenkomen met het aantal mogelijke cellen</sch:p>
      <sch:assert id="STOP0038" role="error" test="$totaalCellen = $spannend"> {"code": "STOP0038", "aantal": "<sch:value-of select="$spannend"/>", "naam": "<sch:name/>", "eId": "<sch:value-of
          select="ancestor::tekst:table/@eId"/>", "nummer": "<sch:value-of select="$totaalCellen"
        />", "melding": "Het aantal cellen in <sch:name/> van tabel \"<sch:value-of
          select="ancestor::tekst:table/@eId"/>\" komt niet overeen met de verwachting (resultaat: <sch:value-of select="$spannend"/> van verwachting <sch:value-of select="$totaalCellen"
        />).", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_033" see="tekst:Extref">
    <sch:title>Externe referentie, notatie</sch:title>
    <sch:rule context="tekst:ExtRef">
      <sch:let name="notatie">
        <xsl:choose>
          <xsl:when test="@soort = 'AKN'">/akn/</xsl:when>
          <xsl:when test="@soort = 'JCI'">jci1</xsl:when>
          <xsl:when test="@soort = 'URL'">http</xsl:when>
          <xsl:when test="@soort = 'JOIN'">/join/</xsl:when>
          <xsl:when test="@soort = 'document'"/>
        </xsl:choose>
      </sch:let>
      <sch:p>Een externe referentie MOET de juiste notatie gebruiken</sch:p>
      <sch:assert id="STOP0050" role="error" test="starts-with(@ref, $notatie)">{"code": "STOP0050", "type": "<sch:value-of select="@soort"/>", "ref": "<sch:value-of select="@ref"
        />", "melding": "De ExtRef van het type <sch:value-of select="@soort"/> met referentie <sch:value-of select="@ref"
        /> heeft niet de juiste notatie.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_037">
    <sch:title>Gereserveerd zonder opvolgende elementen</sch:title>
    <sch:rule context="tekst:Gereserveerd[not(ancestor::tekst:Vervang)]">
      <sch:p>Het element Gereserveerd MAG GEEN opvolgende elementen op hetzelfde niveau
        hebben</sch:p>
      <sch:assert id="STOP0055" role="error" test="not(following-sibling::tekst:*)"> {"code": "STOP0055", "naam": "<sch:value-of select="local-name(following-sibling::tekst:*[1])"/>", "element": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of
          select="parent::tekst:*/@eId"/>", "melding": "Het element <sch:value-of select="local-name(following-sibling::tekst:*[1])"/> binnen <sch:value-of select="local-name(parent::tekst:*)"/> met eId: \"<sch:value-of
          select="parent::tekst:*/@eId"/>\" is niet toegestaan na een element Gereserveerd. Verwijder het element Gereserveerd of verplaats dit element naar een eigen structuur of tekst.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_038">
    <sch:title>Vervallen zonder opvolgende elementen</sch:title>
    <sch:rule context="tekst:Vervallen[not(ancestor::tekst:Vervang)]">
      <sch:p>Het element Vervallen MAG GEEN opvolgende elementen met inhoud op hetzelfde niveau
        hebben</sch:p>
      <sch:assert id="STOP0057" role="error"
        test="not(following-sibling::tekst:Inhoud | following-sibling::tekst:Lid)"> {"code": "STOP0057", "naam": "<sch:value-of select="local-name(following-sibling::tekst:*[1])"/>", "element": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of
          select="parent::tekst:*/@eId"/>", "melding": "Het element <sch:value-of select="local-name(following-sibling::tekst:*[1])"/> binnen <sch:value-of select="local-name(parent::tekst:*)"/> met eId: \"<sch:value-of
          select="parent::tekst:*/@eId"/>\" is niet toegestaan na een element Vervallen. Verwijder het element Vervallen of verplaats dit element naar een eigen structuur of tekst.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_039">
    <sch:title>Structuur compleet</sch:title>
    <sch:rule
      context="tekst:Afdeling | tekst:Bijlage | tekst:Boek | tekst:Deel | tekst:Divisie | tekst:Hoofdstuk | tekst:Paragraaf | tekst:Subparagraaf | tekst:Subsubparagraaf | tekst:Titel">
      <sch:p>Een structuur-element MOET altijd ten minste een element na de Kop bevatten</sch:p>
      <sch:assert id="STOP0058" role="error" test="child::tekst:*[not(self::tekst:Kop)]"> {"code": "STOP0058", "naam": "<sch:name/>", "eId": "<sch:value-of select="@eId"/>", "melding": "Het element <sch:name/> met eId: \"<sch:value-of select="@eId"/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit structuur-element.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_040">
    <sch:title>Artikel compleet</sch:title>
    <sch:rule context="tekst:Artikel">
      <sch:p>Een Artikel MOET altijd tenminste een element na de Kop bevatten</sch:p>
      <sch:assert id="STOP0059" role="error" test="child::tekst:*[not(self::tekst:Kop)]"> {"code": "STOP0059", "naam": "<sch:name/>", "eId": "<sch:value-of select="@eId"/>", "melding": "Het element <sch:name/> met eId: \"<sch:value-of select="@eId"/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit element.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_041">
    <sch:title>Divisietekst compleet</sch:title>
    <sch:rule context="tekst:Divisietekst">
      <sch:p>Een Divisietekst MOET altijd een element anders dan een Kop bevatten</sch:p>
      <sch:assert id="STOP0060" role="error" test="child::tekst:*[not(self::tekst:Kop)]"> {"code": "STOP0060", "naam": "<sch:name/>", "eId": "<sch:value-of select="@eId"/>", "melding": "Het element <sch:name/> met eId: \"<sch:value-of select="@eId"/> is niet compleet, een kind-element anders dan een Kop is verplicht. Completeer of verwijder dit element.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_043">
    <sch:title>Kennisgeving zonder divisie</sch:title>
    <sch:rule context="tekst:Divisie[ancestor::tekst:Kennisgeving]">
      <sch:report id="STOP0061" role="error" test=".">{"code": "STOP0061", "eId": "<sch:value-of
          select="@eId"/>", "melding": "De kennisgeving bevat een Divisie met eId <sch:value-of
          select="@eId"/>. Dit is niet toegestaan. Gebruik alleen Divisietekst.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_044">
    <sch:title>Vervallen structuur</sch:title>
    <sch:rule
      context="tekst:Vervallen[not(ancestor::tekst:Vervang)][not(parent::tekst:Artikel)][not(parent::tekst:Divisietekst)]">
      <sch:p>Indien een structuur-element vervallen is dan moeten ook alle onderliggende delen
        (structuur en tekst) vervallen zijn</sch:p>
      <sch:report id="STOP0062" role="error"
        test="following-sibling::tekst:*[not(child::tekst:Vervallen)]">{"code": "STOP0062", "naam": "<sch:value-of select="local-name(parent::tekst:*)"/>", "eId": "<sch:value-of
          select="parent::tekst:*/@eId"/>", "element": "<sch:value-of
          select="local-name(following-sibling::tekst:*[not(child::tekst:Vervallen)][1])"/>", "id": "<sch:value-of select="following-sibling::tekst:*[not(child::tekst:Vervallen)][1]/@eId"
        />", "melding": "Het element <sch:value-of select="local-name(parent::tekst:*)"/> met eId: \"<sch:value-of
          select="parent::tekst:*/@eId"/>\" is vervallen, maar heeft minstens nog een niet vervallen element\". Controleer vanaf element <sch:value-of
          select="local-name(following-sibling::tekst:*[not(child::tekst:Vervallen)][1])"/> met eId \"<sch:value-of select="following-sibling::tekst:*[not(child::tekst:Vervallen)][1]/@eId"
        /> of alle onderliggende elementen als vervallen zijn aangemerkt.", "ernst": "fout"},</sch:report>
    </sch:rule>
  </sch:pattern>
  <!--  -->
  <sch:pattern id="sch_tekst_045">
    <sch:rule context="tekst:Contact">
      <sch:let name="adres" value="@adres"/>
      <sch:let name="pattern">
        <xsl:choose>
          <xsl:when test="@soort = 'e-mail'">[^@]+@[^\.]+\..+</xsl:when>
          <xsl:otherwise>X</xsl:otherwise>
        </xsl:choose>
      </sch:let>
      <sch:p>Als het element tekst:Contact een attribuut @adres heeft, moet de inhoud van het
        attribuut een adres zijn dat is geformatteerd volgens de specificaties van de waarde van
        attribuut @soort.</sch:p>
      <sch:assert id="STOP0064" role="error" test="matches(@adres, $pattern)">{"code": "STOP0064", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/>", "melding": "Het adres zoals genoemd in het element Contact binnen element met eId <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId"/> heeft een attribuut \"adres\"; de waarde van @adres moet een correct geformatteerd adres zijn. Corrigeer het adres.", "ernst": "fout"},</sch:assert>
    </sch:rule>
  </sch:pattern>
    
    <!-- ================================================================================================================================= -->
    
    <sch:ns prefix="tekst" uri="https://standaarden.overheid.nl/stop/imop/tekst/" />
    <sch:ns prefix="xsl" uri="http://www.w3.org/1999/XSL/Transform" />
    <sch:p>Versie 1.0.4</sch:p>
    <sch:p>Schematron voor aanvullende validatie voor tekstmutaties</sch:p>
    <!--
    Initiële regelingen
  -->
    <sch:pattern id="sch_tekst_024" see="tekst:RegelingKlassiek tekst:BesluitKlassiek
        tekst:WijzigBijlage tekst:RegelingCompact tekst:RegelingVrijetekst
        tekst:RegelingTijdelijkdeel agComponentNieuweRegeling">
        <sch:title>Regelingen - initieel met componentnaam</sch:title>
        <sch:rule
            context="tekst:BesluitKlassiek/tekst:RegelingKlassiek | tekst:WijzigBijlage/tekst:RegelingCompact | tekst:WijzigBijlage/tekst:RegelingVrijetekst | tekst:WijzigBijlage/tekst:RegelingTijdelijkdeel">
            <sch:let name="regeling">
                <xsl:choose>
                    <xsl:when test="child::tekst:RegelingOpschrift">
                        <xsl:value-of select="normalize-space(child::tekst:RegelingOpschrift/.)" />
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="normalize-space(/tekst:*/tekst:RegelingOpschrift/.)" />
                    </xsl:otherwise>
                </xsl:choose>
            </sch:let>
            <sch:assert id="STOP0024" test="@componentnaam"> {"code": "STOP0024", "regeling": "<sch:value-of select="$regeling" />", "melding": "De initiële regeling \"<sch:value-of select="$regeling" />\" heeft geen attribuut @componentnaam, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe bij voorbeeld met als waarde \"main\"", "ernst": "fout"},</sch:assert>
            <sch:assert id="STOP0025" test="@wordt"> {"code": "STOP0025", "regeling": "<sch:value-of select="$regeling" />", "melding": "De initiële regeling \"<sch:value-of select="$regeling" />\" heeft geen attribuut @wordt, dit attribuut is voor een initiële regeling verplicht. Voeg het attribuut toe met als waarde de juiste AKN versie-identifier", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--
    Unieke componentnamen
  -->
    <sch:pattern id="sch_tekst_031" see="tekst:agComponentMutatie agComponentNieuweRegeling">
        <sch:title>Identificatie - componentnaam uniek</sch:title>
        <sch:rule context="tekst:*[@componentnaam]">
            <sch:let name="mijnComponent" value="@componentnaam" />
            <sch:assert id="STOP0026" role="error" test="count(//tekst:*[@componentnaam = $mijnComponent]) = 1"> {"code": "STOP0026", "component": "<sch:value-of select="$mijnComponent" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "De componentnaam \"<sch:value-of select="$mijnComponent" /> binnen <sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" /> is niet uniek. Pas de componentnaam aan om deze uniek te maken", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--
    Unieke ID's binnen componenten
  -->
    <sch:pattern id="sch_tekst_012" see="tekst:agAKN">
        <sch:title>Identificatie - eId, wId binnen een AKN-component</sch:title>
        <sch:rule context="tekst:*[@componentnaam]">
            <sch:let name="component" value="@componentnaam" />
            <sch:let name="index">
                <xsl:for-each
                    select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
                    <xsl:sort select="@eId" />
                    <e>
                        <xsl:value-of select="@eId" />
                    </e>
                </xsl:for-each>
                <xsl:for-each
                    select="//tekst:*[@eId][ancestor::tekst:*[@componentnaam][1][@componentnaam = $component]][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijder'])][not(ancestor-or-self::tekst:*[@wijzigactie = 'verwijderContainer'])]">
                    <xsl:sort select="@wId" />
                    <w>
                        <xsl:value-of select="@wId" />
                    </w>
                </xsl:for-each>
            </sch:let>
            <sch:let name="eId-fout">
                <xsl:for-each select="$index/e[preceding-sibling::e = .]">
                    <xsl:value-of select="." />
                    <xsl:if test="not(position() = last())">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </sch:let>
            <sch:let name="wId-fout">
                <xsl:for-each select="$index/w[preceding-sibling::w = .]">
                    <xsl:value-of select="self::w/." />
                    <xsl:if test="not(position() = last())">
                        <xsl:text>; </xsl:text>
                    </xsl:if>
                </xsl:for-each>
            </sch:let>
            <sch:assert id="STOP0027" role="error" test="$eId-fout = ''"> {"code": "STOP0027", "eId": "<sch:value-of select="$eId-fout" />", "component": "<sch:value-of select="$component" />", "melding": "De eId '<sch:value-of select="$eId-fout" />' binnen component <sch:value-of select="$component" /> moet uniek zijn. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},</sch:assert>
            <sch:assert id="STOP0028" role="error" test="$wId-fout = ''"> {"code": "STOP0028", "wId": "<sch:value-of select="$wId-fout" />", "component": "<sch:value-of select="$component" />", "melding": "De wId '<sch:value-of select="$wId-fout" />' binnen component <sch:value-of select="$component" /> moet uniek zijn. Controleer de opbouw van de wId en corrigeer deze", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--  -->
    <sch:pattern id="sch_tekst_018" see="tekst:WijzigArtikel tekst:WijzigLid tekst:WijzigInstructies">
        <sch:title>RegelingMutatie - WijzigInstructies in een WijzigArtikel</sch:title>
        <sch:rule context="tekst:WijzigArtikel/descendant::tekst:WijzigInstructies">
            <sch:assert id="STOP0039" test="ancestor::tekst:BesluitKlassiek"> {"code": "STOP0039", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element WijzigInstructies binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" is niet toegestaan. Verwijder de WijzigInstructies, of verplaats deze naar een RegelingMutatie binnen een WijzigBijlage.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--  -->
    <sch:pattern id="sch_tekst_048" see="tekst:WijzigArtikel tekst:WijzigLid tekst:WijzigInstructies">
        <sch:title>RegelingMutatie - OpmerkingVersie in een WijzigArtikel</sch:title>
        <sch:rule context="tekst:WijzigArtikel/descendant::tekst:OpmerkingVersie">
            <sch:assert id="STOP0051" test="ancestor::tekst:BesluitKlassiek"> {"code": "STOP0051", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element OpmerkingVersie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" is allen toegestaan in een BesluitCompact. Verwijder de OpmerkingVersie.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--  -->
    <sch:pattern id="sch_tekst_019" see="tekst:WijzigArtikel tekst:WijzigLid tekst:RegelingMutatie">
        <sch:title>RegelingMutatie - in een WijzigArtikel</sch:title>
        <sch:rule context="tekst:WijzigArtikel/descendant::tekst:RegelingMutatie">
            <sch:assert id="STOP0040" test="ancestor::tekst:Lichaam/parent::tekst:BesluitKlassiek | ancestor::tekst:Lichaam/parent::tekst:RegelingKlassiek"> {"code": "STOP0040", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element RegelingMutatie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" is niet toegestaan. Neem de RegelingMutatie op in een WijzigBijlage.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    <!--  -->
    <sch:pattern id="sch_tekst_020" see="tekst:Wat">
        <sch:title>renvooi in Wat</sch:title>
        <sch:rule context="tekst:Wat">
            <sch:report test="tekst:VerwijderdeTekst | tekst:NieuweTekst"> {"code": "STOP0047", "naam": "<sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" />", "eId": "<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />", "melding": "Het element Wat van de RegelingMutatie binnen element <sch:value-of select="local-name(ancestor::tekst:*[@eId][1])" /> met eId \"<sch:value-of select="ancestor::tekst:*[@eId][1]/@eId" />\" bevat renvooimarkeringen. Verwijder de element(en) NieuweTekst en VerwijderdeTekst.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    <sch:pattern id="sch_tekst_021" see="tekst:Al tekst:Begrip tekst:Begrippenlijst tekst:Citaat
        tekst:Definitie tekst:Figuur tekst:Figuur:Titel tekst:Formule tekst:Groep
        tekst:InlineTekstAfbeelding tekst:Kadertekst tekst:Li tekst:Lijst tekst:Lijstaanhef
        tekst:Lijstsluiting ekst:Noot tekst:Nootref tekst:Nummer tekst:Opschrift tekst:Samenvatting
        tekst:Subtitel tekst:Term tekst:Titelregel tekst:Tussenkop tekst:colspec tekst:row
        tekst:table tekst:title">
        <sch:title>wijzigactie nieuweContainer verwijderContainer op andere inhouds-element dan
            Groep</sch:title>
        <sch:rule context="tekst:Inhoud//tekst:*[@wijzigactie][local-name() != 'Groep']">
            <sch:report test="(@wijzigactie = 'nieuweContainer' or @wijzigactie = 'verwijderContainer')">
                {"code": "STOP0048", "naam": "<sch:value-of select="local-name(.)" />", "eId": "<sch:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId" />", "melding": "Op element <sch:value-of select="local-name(.)" /> met (bovenliggend) eId <sch:value-of select="ancestor-or-self::tekst:*[@eId][1]/@eId" /> is de wijzigactie \"nieuweContainer\" en \"verwijderContainer\" toegepast. Dit kan leiden tot invalide XML of informatieverlies. Verwijder de @wijzigactie.", "ernst": "fout"},</sch:report>
        </sch:rule>
    </sch:pattern>
    <!--  -->
    <sch:pattern id="sch_tekst_0045">
        <sch:title>@Wijzigactie voor Inhoud</sch:title>
        <sch:rule context="tekst:Vervang//tekst:Inhoud[@wijzigactie]">
            <sch:p>tekst:Inhoud mag uitsluitend een @wijzigactie hebben gecombineerd met tekst:Vervallen
                of tekst:Gereserveerd</sch:p>
            <sch:assert id="STOP0063" role="error" test="parent::tekst:*/tekst:Gereserveerd | parent::tekst:*/tekst:Vervallen">{"code": "STOP0063", "naam": "<sch:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])" />", "wat": "<sch:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat" />", "melding": "Het element Inhoud van <sch:value-of select="local-name(ancestor::tekst:Vervang[@wat][1])" /> met het attribuut @wat \"<sch:value-of select="ancestor::tekst:Vervang[@wat][1]/@wat" />\" heeft ten onrechte een attribuut @wijzigactie. Dit is alleen toegestaan indien gecombineerd met een Gereserveerd of Vervallen. Verwijder het attribuut @wijzigactie.", "ernst": "fout"},</sch:assert>
        </sch:rule>
    </sch:pattern>
    
    
    <!-- ================================================================================================================================= -->
</sch:schema>