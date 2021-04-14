<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow" xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <!-- file.list bevat alle te verwerken bestanden -->

    <xsl:param name="file.list" as="xs:string*"/>
    <xsl:param name="base.dir"/>
    <xsl:param name="org.file.dir"/>

    <xsl:variable name="dateTime" select="format-dateTime(current-dateTime(), '[Y0001][M01][D01][h01][m01][s01]')"/>

    <xsl:template match="/">
        <xsl:call-template name="index"/>
    </xsl:template>

    <!-- maak manifest-bestand waarin is aangegeven wat de functie van een bestand is -->

    <xsl:template name="index">
        <xsl:element name="index">
            <xsl:for-each select="$index/*">
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <!-- stel index-bestand samen -->
    <xsl:param name="index">
        <xsl:message select="$file.list"/>
        <xsl:for-each select="tokenize($file.list, ';')">
            <xsl:variable name="fullname" select="."/>
            <xsl:variable name="pos1" select="position()"/>
            <!-- Doel Id -->
            <!-- Haal oorspronkelijk uit manifest-ow -->
            <xsl:if test="document($fullname)//manifest-ow:Aanleveringen">
                <xsl:element name="doelId">
                    <xsl:element name="old">
                        <xsl:value-of select="document($fullname)//manifest-ow:Aanlevering/manifest-ow:DoelID/text()"/> 
                    </xsl:element>
                    <xsl:element name="new">
                    <xsl:value-of select="foo:generateDoelId(document($fullname)//manifest-ow:Aanlevering/manifest-ow:DoelID/text())"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <!-- BesluitID/RegelingID -->
            <xsl:if test="document($fullname)/aanlevering:AanleveringBesluit">
                <xsl:element name="besluitId">
                    <xsl:element name="oldFRBRWork">
                        <xsl:value-of select="document($fullname)//aanlevering:BesluitVersie/data:ExpressionIdentificatie/data:FRBRWork/text()"/>
                    </xsl:element>
                    <xsl:element name="FRBRWork">
                        <xsl:value-of select="foo:generateAKNFRBRWork(document($fullname)//aanlevering:BesluitVersie/data:ExpressionIdentificatie/data:FRBRWork/text())"/>
                    </xsl:element>
                    <xsl:element name="oldFRBRExpression">
                        <xsl:value-of select="document($fullname)//aanlevering:BesluitVersie/data:ExpressionIdentificatie/data:FRBRExpression/text()"/>
                    </xsl:element>
                    <xsl:element name="FRBRExpression">
                        <xsl:value-of select="foo:generateAKNFRBRExpression(document($fullname)//aanlevering:BesluitVersie/data:ExpressionIdentificatie/data:FRBRExpression/text())"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="regelingId">
                    <xsl:element name="oldFRBRWork">
                        <xsl:value-of select="document($fullname)//aanlevering:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRWork/text()"/>
                    </xsl:element>
                    <xsl:element name="FRBRWork">
                        <xsl:value-of select="foo:generateAKNFRBRWork(document($fullname)//aanlevering:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRWork/text())"/>
                    </xsl:element>
                    <xsl:element name="oldFRBRExpression">
                        <xsl:value-of select="document($fullname)//aanlevering:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRExpression/text()"/>
                    </xsl:element>
                    <xsl:element name="FRBRExpression">
                        <xsl:value-of select="foo:generateAKNFRBRExpression(document($fullname)//aanlevering:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRExpression/text())"/>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="besluit">
                    <xsl:element name="versies">
                        <xsl:element name="oldWordt">
                            <xsl:value-of select="document($fullname)//@wordt"/>
                        </xsl:element>
                        <xsl:element name="wordt">
                            <xsl:value-of select="foo:generateAKNFRBRExpression(document($fullname)//@wordt)"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:element name="oldInstrumentversie">
                        <xsl:value-of select="document($fullname)//data:ConsolidatieInformatie/data:BeoogdeRegelgeving/data:BeoogdeRegeling/data:instrumentVersie/text()"/>
                    </xsl:element>
                    <xsl:element name="instrumentversie">
                        <xsl:value-of select="foo:generateAKNFRBRExpression(document($fullname)//data:ConsolidatieInformatie/data:BeoogdeRegelgeving/data:BeoogdeRegeling/data:instrumentVersie/text())"
                        />
                    </xsl:element>
                    <xsl:for-each select="document($fullname)//data:informatieobjectRefs/data:informatieobjectRef">
                        <xsl:element name="informatieobjectRef">
                            <xsl:variable name="oldIoRefId" select="text()"/>
                            <xsl:variable name="oldIoWorkId"
                                select="concat('/', tokenize($oldIoRefId, '/')[2], '/', tokenize($oldIoRefId, '/')[3], '/', tokenize($oldIoRefId, '/')[4], '/', tokenize($oldIoRefId, '/')[5], '/', tokenize($oldIoRefId, '/')[6], '/', tokenize($oldIoRefId, '/')[7])"/>
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="giofullname" select="."/>
                                <xsl:for-each select="document($giofullname)//aanlevering:AanleveringInformatieObject">
                                    <xsl:if test="descendant::data:FRBRExpression/text() = $oldIoRefId">
                                        <xsl:element name="gio">
                                            <xsl:element name="file">
                                                <xsl:value-of select="tokenize($giofullname, '/')[last()]"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="gmlfullname" select="."/>
                                <xsl:for-each select="document($gmlfullname)//geo:GeoInformatieObjectVaststelling">
                                    <xsl:if test="descendant::geo:FRBRExpression/text() = $oldIoRefId">
                                        <xsl:element name="gml">
                                            <xsl:element name="file">
                                                <xsl:value-of select="tokenize($gmlfullname, '/')[last()]"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:if>
                                </xsl:for-each>
                            </xsl:for-each>
                            <xsl:element name="oldIoWorkId">
                                <xsl:value-of select="$oldIoWorkId"/>
                            </xsl:element>
                            <xsl:element name="newIoWorkId">
                                <xsl:value-of select="foo:generateFRBRWork($oldIoWorkId)"/>
                            </xsl:element>
                            <xsl:element name="oldIoRefId">
                                <xsl:value-of select="$oldIoRefId"/>
                            </xsl:element>
                            <xsl:element name="newIoRefId">
                                <xsl:value-of select="foo:generateFRBRExpression($oldIoRefId)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <!-- Levering Ids -->
            <xsl:if test="document($fullname)//lvbb:publicatieOpdracht or document($fullname)//lvbb:validatieOpdracht">
                <xsl:element name="leveringId">
                    <xsl:attribute name="sourcefile" select="tokenize($fullname, '/')[last()]"/>
                    <xsl:for-each select="tokenize($file.list, ';')">
                        <xsl:variable name="referencefullname" select="."/>
                        <xsl:if test="document($referencefullname)//sl:leveringsId">
                            <xsl:element name="referencefile">
                                <xsl:value-of select="tokenize($referencefullname, '/')[last()]"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:element name="org">
                        <xsl:value-of select="document($fullname)//lvbb:idLevering/text()"/>
                    </xsl:element>
                    <xsl:element name="new">
                        <xsl:value-of select="concat('id-publicatie-', $org.file.dir, '-', $dateTime)"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <!-- OW-Ids -->
            <xsl:element name="owids">
                <xsl:for-each select="document($fullname)//r:Regeltekst/r:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//vt:Divisie/vt:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//rol:Activiteit/rol:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//ga:Gebiedsaanwijzing/ga:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//rol:Normwaarde/rol:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//l:Gebied/l:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//l:Gebiedengroep/l:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//l:Lijn/l:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//l:Lijnengroep/l:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//l:Punt/l:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//l:Puntengroep/l:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//l:Locatie/l:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//p:Pons/p:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//k:Kaart/k:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//rg:Regelingsgebied/rg:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//vt:Hoofdlijn/vt:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//vt:Tekstdeel/vt:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//r:Instructieregel/r:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//r:JuridischeRegel/r:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//r:Omgevingswaarderegel/r:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
                <xsl:for-each select="document($fullname)//r:RegelVoorIedereen/r:identificatie">
                    <xsl:call-template name="owid">
                        <xsl:with-param name="seeder" select="fn:position()"/>
                        <xsl:with-param name="parent" select="."/>
                        <xsl:with-param name="fullname" select="$fullname"/>
                    </xsl:call-template>
                </xsl:for-each>
            </xsl:element>
            <!-- GUIDS -->
            <xsl:if test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                <xsl:element name="guids">
                    <xsl:for-each select="document($fullname)//geo:GeoInformatieObjectVaststelling/descendant::basisgeo:id">
                        <xsl:variable name="pos2" select="position()"/>
                        <xsl:element name="guid">
                            <xsl:attribute name="gmlfile" select="tokenize($fullname, '/')[last()]"/>
                            <xsl:variable name="orgGUID" select="text()"/>
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="locatiefullname" select="."/>
                                <xsl:choose>
                                    <xsl:when test="document($locatiefullname)//l:Gebied//l:GeometrieRef[@xlink:href = $orgGUID]">
                                        <xsl:attribute name="locatiefile" select="tokenize($locatiefullname, '/')[last()]"/>
                                    </xsl:when>
                                    <xsl:when test="document($locatiefullname)//l:Lijn//l:GeometrieRef[@xlink:href = $orgGUID]">
                                        <xsl:attribute name="locatiefile" select="tokenize($locatiefullname, '/')[last()]"/>
                                    </xsl:when>
                                    <xsl:when test="document($locatiefullname)//l:Punt//l:GeometrieRef[@xlink:href = $orgGUID]">
                                        <xsl:attribute name="locatiefile" select="tokenize($locatiefullname, '/')[last()]"/>
                                    </xsl:when>
                                    <xsl:when test="document($locatiefullname)//l:Locatie//l:GeometrieRef[@xlink:href = $orgGUID]">
                                        <xsl:attribute name="locatiefile" select="tokenize($locatiefullname, '/')[last()]"/>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:for-each>
                            <xsl:element name="org">
                                <xsl:value-of select="$orgGUID"/>
                            </xsl:element>
                            <xsl:element name="new">
                                <xsl:value-of select="foo:generateGuid($pos1 + $pos2, $orgGUID)"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <!-- BESLUIT -->
            <xsl:if test="document($fullname)/aanlevering:AanleveringBesluit">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'besluit.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- OPDRACHT -->
            <xsl:if test="document($fullname)/lvbb:publicatieOpdracht">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'opdracht.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- GML -->
            <xsl:if test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'gml.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- GIO -->
            <xsl:if test="document($fullname)//aanlevering:AanleveringInformatieObject">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'gio.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- OW       -->
            <xsl:if test="document($fullname)//r:Regeltekst">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:Instructieregel">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:JuridischeRegel">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:Omgevingswaarderegel">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:RegelVoorIedereen">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Divisie">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'vrijetekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Activiteit">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'activiteit.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//ga:Gebiedsaanwijzing">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'gebiedsaanwijzing.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Normwaarde">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'normwaarde.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Gebied">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Gebiedengroep">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Lijn">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Lijnengroep">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Punt">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Puntengroep">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Locatie">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//p:Pons">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'pons.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//k:Kaart">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'kaart.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rg:Regelingsgebied">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'regelingsgebied.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Hoofdlijn">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'hoofdlijn.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Tekstdeel">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'tekstdeel.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'manifest-ow.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:publicatieOpdracht">
                <xsl:element name="file">
                    <xsl:attribute name="type" select="'opdracht.xml'"/>
                    <xsl:attribute name="ow" select="'false'"/>
                    <xsl:element name="fullname">
                        <xsl:value-of select="$fullname"/>
                    </xsl:element>
                    <xsl:element name="name">
                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:validatieOpdracht">
                <xsl:element name="file">
                    <xsl:attribute name="type" select="'opdracht.xml'"/>
                    <xsl:attribute name="ow" select="'false'"/>
                    <xsl:element name="fullname">
                        <xsl:value-of select="$fullname"/>
                    </xsl:element>
                    <xsl:element name="name">
                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                    </xsl:element>
                </xsl:element>
            </xsl:if>
        </xsl:for-each>
    </xsl:param>

    <xsl:function name="foo:generateGuid">
        <xsl:param name="seed" as="xs:integer"/>
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:value-of select="$oldId"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="translate(translate(translate(unparsed-text(concat('https://uuidgen.org/api/v/4?x=', string($seed))), '[', ''), ']', ''), '&quot;', '')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="foo:generateDoelId">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:value-of select="$oldId"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat($org.file.dir, $dateTime))"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="foo:generateFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:value-of select="$oldId"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], $dateTime))"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="foo:generateFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:value-of select="$oldId"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], $dateTime), '/', tokenize($oldId, '/')[8])"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="foo:generateAKNFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:value-of select="$oldId"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat($org.file.dir, $dateTime))"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="foo:generateAKNFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:value-of select="$oldId"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat($org.file.dir, $dateTime), '/', tokenize($oldId, '/')[8])"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="foo:generateOWId">
        <xsl:param name="seeder"/>
        <xsl:param name="oldId" as="xs:string"/>
        <!-- max length 4th part of Id has a max-length of 32-->
        <xsl:variable name="maxLength" select="32 - string-length(tokenize($oldId, '\.')[4])"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:value-of select="$oldId"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="$maxLength > 13">
                        <xsl:variable name="dateString" select="$dateTime"/>
                        <xsl:value-of select="concat(tokenize($oldId, '\.')[1], '.', tokenize($oldId, '\.')[2], '.', tokenize($oldId, '\.')[3], '.', $seeder, $dateString)"/>
                    </xsl:when>
                    <xsl:when test="$maxLength > 0 and $maxLength &lt; 14">
                        <xsl:variable name="dateString" select="substring($dateTime, 14 - $maxLength)"/>
                        <xsl:value-of select="concat(tokenize($oldId, '\.')[1], '.', tokenize($oldId, '\.')[2], '.', tokenize($oldId, '\.')[3], '.', $seeder, $dateString)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(tokenize($oldId, '\.')[1], '.', tokenize($oldId, '\.')[2], '.', tokenize($oldId, '\.')[3], '.', $dateTime)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template name="references">
        <xsl:param name="orgOWId"/>
        <xsl:for-each select="tokenize($file.list, ';')">
            <xsl:variable name="referencefullname" select="."/>
            <xsl:for-each select="document($referencefullname)//@xlink:href">
                <xsl:if test="$orgOWId = string(.)">
                    <xsl:element name="referencefile">
                        <xsl:value-of select="tokenize($referencefullname, '/')[last()]"/>
                    </xsl:element>
                </xsl:if>
            </xsl:for-each>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="owid">
        <xsl:param name="seeder"/>
        <xsl:param name="parent" as="node()"/>
        <xsl:param name="fullname"/>
        <xsl:variable name="s" select="fn:format-number($seeder, '00000')"/>
        <xsl:element name="owid">
            <xsl:attribute name="sourcefile" select="tokenize($fullname, '/')[last()]"/>
            <xsl:variable name="orgOWId" select="$parent/text()"/>
            <xsl:call-template name="references">
                <xsl:with-param name="orgOWId" select="$orgOWId"/>
            </xsl:call-template>
            <xsl:element name="org">
                <xsl:value-of select="$orgOWId"/>
            </xsl:element>
            <xsl:element name="new">
                <xsl:value-of select="foo:generateOWId($s, $parent/text())"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="file">
        <xsl:param name="type" as="xs:string"/>
        <xsl:param name="fullname" as="xs:string"/>
        <xsl:param name="ow" as="xs:string"/>
        <xsl:element name="file">
            <xsl:attribute name="type" select="$type"/>
            <xsl:attribute name="ow" select="$ow"/>
            <xsl:element name="name">
                <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
