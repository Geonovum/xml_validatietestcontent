<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow" xmlns:s="http://www.geostandaarden.nl/imow/symbolisatie"
    xmlns:foo="http://whatever" xmlns:uuid="java:java.util.UUID" exclude-result-prefixes="uuid">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <!-- file.list bevat alle te verwerken bestanden -->

    <xsl:param name="file.list" as="xs:string*"/>
    <xsl:param name="base.dir"/>
    <!-- LET OP NIET IN STANDAARD UNIFICERING -->
    <xsl:param name="org.file.dir"/>
    <xsl:param name="bronnummer" required="yes"/>

    <xsl:param name="alreadyRetrievedDateTime"/>

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
        <!-- LET OP NIET IN STANDAARD UNIFICERING -->
        <xsl:element name="testId">
            <xsl:value-of select="replace($org.file.dir, '\.', '_')"/>
        </xsl:element>
        <xsl:for-each select="tokenize($file.list, ';')">
            <xsl:variable name="fullname" select="."/>
            <xsl:variable name="pos1" select="position()"/>
            <!-- BesluitID/RegelingID -->
            <!-- ga directories af -->
            <xsl:variable name="sequence" select="(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15)"/>
            <xsl:for-each select="$sequence">
                <xsl:if test="$bronnummer >= position() - 1 and document($fullname)/aanlevering:AanleveringBesluit">
                    <xsl:choose>
                        <xsl:when test="position() - 1 = 0">
                            <!-- kijk of er bestanden bestaan in directory (of directory bestaat) -->
                            <xsl:if test="doc-available(concat($base.dir, '/bron/opdracht.xml'))">
                                <!-- scan alle bestanden -->
                                <xsl:variable name="directory" select="concat($base.dir, '/bron')"/>
                                <xsl:for-each select="collection(concat($directory, '?select=*.xml'))">
                                    <xsl:for-each select="document(base-uri(.))/aanlevering:AanleveringBesluit/aanlevering:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRWork">
                                        <xsl:element name="Regeling">
                                            <xsl:element name="OrigineleregelingsFBRWork">
                                                <xsl:value-of select="text()"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- kijk of er bestanden bestaan in directory (of directory bestaat) -->
                            <xsl:if test="doc-available(concat($base.dir, '/bron_', position() - 1, '/opdracht.xml'))">
                                <!-- scan alle bestanden -->
                                <xsl:variable name="directory" select="concat($base.dir, '/bron_', position() - 1)"/>
                                <xsl:for-each select="collection(concat($directory, '?select=*.xml'))">
                                    <xsl:for-each select="document(base-uri(.))/aanlevering:AanleveringBesluit/aanlevering:RegelingVersieInformatie/data:ExpressionIdentificatie/data:FRBRWork">
                                        <xsl:element name="Regeling">
                                            <xsl:element name="OrigineleregelingsFBRWork">
                                                <xsl:value-of select="text()"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
            <!-- historische informatieobjectRefs voor verwerking in extiorefs die geen informatieobjectRefs in actueel besluit hebben -->
            <!-- ga directories af -->
            <xsl:for-each select="$sequence">
                <xsl:if test="$bronnummer >= position() - 1 and document($fullname)/aanlevering:AanleveringBesluit">
                    <xsl:choose>
                        <xsl:when test="position() - 1 = 0">
                            <!-- kijk of er bestanden bestaan in directory (of directory bestaat) -->
                            <xsl:if test="doc-available(concat($base.dir, '/bron/opdracht.xml'))">
                                <!-- scan alle bestanden -->
                                <xsl:variable name="directory" select="concat($base.dir, '/bron')"/>
                                <xsl:for-each select="collection(concat($directory, '?select=*.xml'))">
                                    <xsl:for-each select="document(base-uri(.))//data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef">
                                        <xsl:element name="historischInformatieobjectRef">
                                            <xsl:variable name="oldIoRefId" select="text()"/>
                                            <xsl:variable name="oldIoWorkId"
                                                select="concat('/', tokenize($oldIoRefId, '/')[2], '/', tokenize($oldIoRefId, '/')[3], '/', tokenize($oldIoRefId, '/')[4], '/', tokenize($oldIoRefId, '/')[5], '/', tokenize($oldIoRefId, '/')[6], '/', tokenize($oldIoRefId, '/')[7])"/>
                                            <xsl:element name="oldIoWorkId">
                                                <xsl:value-of select="$oldIoWorkId"/>
                                            </xsl:element>
                                            <xsl:element name="oldIoRefId">
                                                <xsl:value-of select="$oldIoRefId"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- kijk of er bestanden bestaan in directory (of directory bestaat) -->
                            <xsl:if test="doc-available(concat($base.dir, '/bron_', position() - 1, '/opdracht.xml'))">
                                <!-- scan alle bestanden -->
                                <xsl:variable name="directory" select="concat($base.dir, '/bron_', position() - 1)"/>
                                <xsl:for-each select="collection(concat($directory, '?select=*.xml'))">
                                    <xsl:for-each select="document(base-uri(.))//data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef">
                                        <xsl:element name="historischInformatieobjectRef">
                                            <xsl:variable name="oldIoRefId" select="text()"/>
                                            <xsl:variable name="oldIoWorkId"
                                                select="concat('/', tokenize($oldIoRefId, '/')[2], '/', tokenize($oldIoRefId, '/')[3], '/', tokenize($oldIoRefId, '/')[4], '/', tokenize($oldIoRefId, '/')[5], '/', tokenize($oldIoRefId, '/')[6], '/', tokenize($oldIoRefId, '/')[7])"/>
                                            <xsl:element name="oldIoWorkId">
                                                <xsl:value-of select="$oldIoWorkId"/>
                                            </xsl:element>
                                            <xsl:element name="oldIoRefId">
                                                <xsl:value-of select="$oldIoRefId"/>
                                            </xsl:element>
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:for-each>
                            </xsl:if>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>
            </xsl:for-each>
            <!-- informatieobjectRefs, gerelateerde gml's, gio's -->
            <xsl:if test="document($fullname)/aanlevering:AanleveringBesluit">
                <xsl:element name="besluit">
                    <!-- InformatieRefs -->
                    <!-- doorloopt het besluit, sectie io-refs -->
                    <xsl:for-each select="document($fullname)//data:informatieobjectRefs/data:informatieobjectRef">
                        <xsl:element name="informatieobjectRef">
                            <xsl:variable name="oldIoRefId" select="text()"/>
                            <xsl:variable name="oldIoWorkId"
                                select="concat('/', tokenize($oldIoRefId, '/')[2], '/', tokenize($oldIoRefId, '/')[3], '/', tokenize($oldIoRefId, '/')[4], '/', tokenize($oldIoRefId, '/')[5], '/', tokenize($oldIoRefId, '/')[6], '/', tokenize($oldIoRefId, '/')[7])"/>
                            <xsl:choose>
                                <xsl:when test="$org.file.dir = 'LVBB3900'">
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'GoedeGebieden.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'GoedeGebieden.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'GoedeGebieden2.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'GoedeGebieden2.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'regelingsgebied.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'regelingsgebied.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="$org.file.dir = 'LVBB3901'">
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'GoedeGebieden.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'GoedeGebieden.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'GoedeGebieden2.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'GoedeGebieden2.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'regelingsgebied.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'regelingsgebied.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="
                                        $org.file.dir = 'STOP1007'
                                        or $org.file.dir = 'STOP1009'">
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'GoedeGebieden.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'GoedeGebieden.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="informatieobjectRef">
                                        <xsl:element name="gio">
                                            <xsl:value-of select="'regelingsgebied.xml'"/>
                                        </xsl:element>
                                        <xsl:element name="gml">
                                            <xsl:value-of select="'regelingsgebied.gml'"/>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:for-each select="tokenize($file.list, ';')">
                                        <xsl:variable name="giofullname" select="."/>
                                        <xsl:for-each select="document($giofullname)//aanlevering:AanleveringInformatieObject">
                                            <xsl:if test="descendant::data:FRBRExpression/text() = $oldIoRefId">
                                                <xsl:element name="gio">
                                                    <xsl:value-of select="tokenize($giofullname, '/')[last()]"/>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                    <xsl:for-each select="tokenize($file.list, ';')">
                                        <xsl:variable name="gmlfullname" select="."/>
                                        <xsl:for-each select="document($gmlfullname)//geo:GeoInformatieObjectVaststelling">
                                            <xsl:if test="descendant::geo:FRBRExpression/text() = $oldIoRefId">
                                                <xsl:element name="gml">
                                                    <xsl:value-of select="tokenize($gmlfullname, '/')[last()]"/>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:for-each>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:element name="oldIoWorkId">
                                <xsl:value-of select="$oldIoWorkId"/>
                            </xsl:element>
                            <xsl:element name="oldIoRefId">
                                <xsl:value-of select="$oldIoRefId"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <!-- Levering Ids -->
            <xsl:if test="document($fullname)//lvbb:publicatieOpdracht">
                <xsl:variable name="idLevering" select="document($fullname)//lvbb:publicatieOpdracht/lvbb:idLevering"/>
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
                </xsl:element>
                <xsl:element name="idLevering">
                    <xsl:value-of select="$idLevering"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:validatieOpdracht">
                <xsl:variable name="idLevering" select="document($fullname)//lvbb:validatieOpdracht/lvbb:idLevering"/>
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
                </xsl:element>
                <xsl:element name="idLevering">
                    <xsl:value-of select="$idLevering"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:directeMutatieOpdracht">
                <xsl:message select="'ERROR ERROR ERROR ERROR: lvbb:directeMutatieOpdracht'"/>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:validatieDirecteMutatieOpdracht">
                <xsl:variable name="idLevering" select="document($fullname)//lvbb:validatieDirecteMutatieOpdracht/lvbb:idLevering"/>
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
                </xsl:element>
                <xsl:element name="idLevering">
                    <xsl:value-of select="$idLevering"/>
                </xsl:element>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:breekPublicatieAfOpdracht">
                <xsl:variable name="idLevering" select="document($fullname)//lvbb:breekPublicatieAfOpdracht/lvbb:idLevering"/>
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
                </xsl:element>
                <xsl:element name="idLevering">
                    <xsl:value-of select="$idLevering"/>
                </xsl:element>
            </xsl:if>
            <!-- GUIDS -->
            <xsl:if test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                <xsl:element name="guids">
                    <xsl:for-each select="document($fullname)//geo:GeoInformatieObjectVaststelling/descendant::basisgeo:id">
                        <xsl:variable name="pos2" select="position()"/>
                        <xsl:variable name="orgGUID" select="text()"/>
                        <xsl:variable name="locatiefile">
                            <xsl:for-each select="tokenize($file.list, ';')">
                                <xsl:variable name="locatieFile" as="xs:string" select="."/>
                                <xsl:variable name="locatieFileOnly" as="xs:string" select="tokenize($locatieFile, '/')[last()]"/>
                                <xsl:if test="document($locatieFile)//l:GeometrieRef[@xlink:href = $orgGUID]">
                                    <xsl:value-of select="$locatieFileOnly"/>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:variable>
                        <xsl:variable name="org" select="$orgGUID"/>
			<xsl:variable name="new" select="uuid:randomUUID()"/>
                        <xsl:variable name="elementName">
                            <xsl:choose>
                                <xsl:when test="not($locatiefile = '')">
                                    <xsl:value-of select="'guidInOw'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'guid'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        <xsl:element name="{$elementName}">
                            <xsl:attribute name="gmlfile" select="tokenize($fullname, '/')[last()]"/>
                            <xsl:if test="not($locatiefile = '')">
                                <xsl:attribute name="locatiefile" select="$locatiefile"/>
                            </xsl:if>
                            <xsl:element name="org">
                                <xsl:value-of select="$org"/>
                            </xsl:element>
                            <xsl:element name="new">
                                <xsl:value-of select="$new"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:if>
            <!-- BESLUIT -->
            <xsl:if test="document($fullname)/aanlevering:AanleveringBesluit">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'besluit.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)/aanlevering:AanleveringKennisgeving">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'kennisgeving.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- OPDRACHT -->
            <xsl:if test="document($fullname)/lvbb:publicatieOpdracht">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'opdracht.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- GML -->
            <xsl:if test="document($fullname)//geo:GeoInformatieObjectVaststelling">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'gml.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- GIO -->
            <xsl:if test="document($fullname)//aanlevering:AanleveringInformatieObject">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'gio.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <!-- OW       -->
            <xsl:if test="document($fullname)//r:Regeltekst">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:Instructieregel">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:JuridischeRegel">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:Omgevingswaarderegel">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//r:RegelVoorIedereen">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'regeltekst.xml'"/>
                    <!-- -->
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Divisie">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'vrijetekst.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Activiteit">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'activiteit.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//ga:Gebiedsaanwijzing">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'gebiedsaanwijzing.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rol:Normwaarde">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'normwaarde.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Gebied">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Gebiedengroep">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Lijn">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Lijnengroep">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Punt">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Puntengroep">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//l:Locatie">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'locatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//p:Pons">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'pons.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//k:Kaart">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'kaart.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//rg:Regelingsgebied">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'regelingsgebied.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Hoofdlijn">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'hoofdlijn.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//vt:Tekstdeel">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'tekstdeel.xml'"/>
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
            <xsl:if test="document($fullname)//s:SymbolisatieItem">
                <xsl:call-template name="file">
                    <xsl:with-param name="type" select="'symbolisatie.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'true'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//Aanleveringen" xpath-default-namespace="http://www.geostandaarden.nl/bestanden-ow/manifest-ow">
                <xsl:call-template name="file">
                    <!-- -->
                    <xsl:with-param name="type" select="'manifest-ow.xml'"/>
                    <xsl:with-param name="fullname" select="$fullname"/>
                    <xsl:with-param name="ow" select="'false'"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="document($fullname)//lvbb:publicatieOpdracht">
                <xsl:element name="file">
                    <!-- -->
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
                    <!-- -->
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
            <xsl:if test="document($fullname)//rol:Activiteit/rol:bovenliggendeActiviteit or document($fullname)//rol:Activiteit/rol:gerelateerdeActiviteit">
                <xsl:for-each select="document($fullname)//rol:Activiteit">
                    <xsl:variable name="bovenligendeActiviteitId" select="rol:bovenliggendeActiviteit/rol:ActiviteitRef/@xlink:href"/>
                    <xsl:for-each select="tokenize($file.list, ';')">
                        <xsl:variable name="activiteitBestand" select="."/>
                        <xsl:for-each select="document($activiteitBestand)//rol:Activiteit">
                            <xsl:if test="$bovenligendeActiviteitId = rol:identificatie/text()">
                                <xsl:element name="bovenliggendeActiviteitRelatie">
                                    <xsl:element name="name">
                                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                                    </xsl:element>
                                    <xsl:element name="bovenliggendeActiviteitIdLokaalAanwezig">
                                        <xsl:value-of select="$bovenligendeActiviteitId"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                    <xsl:variable name="gerelateerdeActiviteitId" select="rol:gerelateerdeActiviteit/rol:ActiviteitRef/@xlink:href"/>
                    <xsl:for-each select="tokenize($file.list, ';')">
                        <xsl:variable name="activiteitBestand" select="."/>
                        <xsl:for-each select="document($activiteitBestand)//rol:Activiteit">
                            <xsl:if test="$gerelateerdeActiviteitId = rol:identificatie/text()">
                                <xsl:element name="gerelateerdeActiviteitRelatie">
                                    <xsl:element name="name">
                                        <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
                                    </xsl:element>
                                    <xsl:element name="gerelateerdeActiviteitIdLokaalAanwezig">
                                        <xsl:value-of select="$gerelateerdeActiviteitId"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:for-each>
            </xsl:if>
        </xsl:for-each>
    </xsl:param>

    <xsl:function name="foo:changePart">
        <xsl:param name="oldPart" as="xs:string"/>
        <xsl:choose>
            <!-- Indien het id het woordje FOUT bevat, dient wordt het woordje fout toegevoegd, hij is immers om een fout te triggeren -->
            <xsl:when test="contains($oldPart, 'FOUT')">
                <xsl:value-of select="$oldPart"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat(replace($oldPart, '\.', '_'), '-', $alreadyRetrievedDateTime)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:template name="file">
        <xsl:param name="type" as="xs:string"/>
        <xsl:param name="fullname" as="xs:string"/>
        <xsl:param name="ow" as="xs:string"/>
        <xsl:element name="file">
            <!-- -->
            <xsl:attribute name="type" select="$type"/>
            <!-- -->
            <xsl:attribute name="ow" select="$ow"/>
            <xsl:element name="name">
                <xsl:value-of select="tokenize($fullname, '/')[last()]"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>


</xsl:stylesheet>
