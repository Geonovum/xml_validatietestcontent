<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:do="http://whatever" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:stop="http://www.overheid.nl/2017/stop" exclude-result-prefixes="xs"
    xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" version="3.0">

    <xsl:output omit-xml-declaration="no"/>
    <xsl:output method="xml"/>
    <xsl:variable name="defNS" select="string('urn:schemas-microsoft-com:office:spreadsheet')"/>

    <xsl:variable name="alleTests" select="0" saxon:assignable="yes"/>
    <xsl:variable name="testsMetEenResultaat" select="0" saxon:assignable="yes"/>
    <xsl:variable name="testsMetEenFoutResultaat" select="0" saxon:assignable="yes"/>
    <xsl:variable name="testsMetMeerdereResultaten" select="0" saxon:assignable="yes"/>
    <xsl:variable name="testsMetGeenResultaten" select="0" saxon:assignable="yes"/>
    <xsl:variable name="resultaten" select="0" saxon:assignable="yes"/>
    <xsl:variable name="found" select="false()" saxon:assignable="yes"/>
    <xsl:variable name="datum" select="''" saxon:assignable="yes"/>


    <xsl:template match="/">
        <xsl:variable name="fileUrl" select="replace(tokenize(document-uri(), '/')[last()], '.xml', '_excel.xls')"/>
        <xsl:message select="$fileUrl"/>
        <xsl:result-document href="{$fileUrl}" method="xml" indent="yes">
            <xsl:apply-templates/>
        </xsl:result-document>
    </xsl:template>

    <xsl:template match="result">

        <xsl:element name="Workbook" namespace="urn:schemas-microsoft-com:office:spreadsheet">
            <xsl:namespace name="html" select="string('http://www.w3.org/TR/REC-html40')"/>
            <xsl:namespace name="o" select="string('urn:schemas-microsoft-com:office:office')"/>
            <xsl:namespace name="x" select="string('urn:schemas-microsoft-com:office:excel')"/>
            <xsl:namespace name="ss" select="string('urn:schemas-microsoft-com:office:spreadsheet')"/>
            <!-- STYLES -->
            <xsl:element name="Styles" namespace="{$defNS}">
                <!-- HEADER -->
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">header</xsl:attribute>
                    <xsl:element name="Font" namespace="{$defNS}">
                        <xsl:attribute name="ss:FontName">Verdana</xsl:attribute>
                        <xsl:attribute name="ss:Bold">1</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <!-- ID -->
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">id</xsl:attribute>
                    <xsl:element name="Interior" namespace="{$defNS}">
                        <xsl:attribute name="ss:Color">#2DFF96</xsl:attribute>
                        <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <!-- VALIDATIE -->
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">validatie</xsl:attribute>
                    <xsl:element name="Font" namespace="{$defNS}">
                        <xsl:attribute name="ss:FontName">Verdana</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="Interior" namespace="{$defNS}">
                        <xsl:attribute name="ss:Color">#9FFFCF</xsl:attribute>
                        <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">red</xsl:attribute>
                    <xsl:element name="Interior" namespace="{$defNS}">
                        <xsl:attribute name="ss:Color">#F6403C</xsl:attribute>
                        <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">green</xsl:attribute>
                    <xsl:element name="Interior" namespace="{$defNS}">
                        <xsl:attribute name="ss:Color">#52E070</xsl:attribute>
                        <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">yellow</xsl:attribute>
                    <xsl:element name="Interior" namespace="{$defNS}">
                        <xsl:attribute name="ss:Color">#F5F53D</xsl:attribute>
                        <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">grey</xsl:attribute>
                    <xsl:element name="Interior" namespace="{$defNS}">
                        <xsl:attribute name="ss:Color">#DDDDDD</xsl:attribute>
                        <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
            <!-- WORKSHEET: Validatie-terugmeldingen -->
            <xsl:element name="Worksheet" namespace="{$defNS}">
                <xsl:attribute name="ss:Name">Validatie-terugmeldingen</xsl:attribute>
                <!-- HEADER -->
                <xsl:element name="Table" namespace="{$defNS}">
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:attribute name="ss:Index">
                            <xsl:value-of select="1"/>
                        </xsl:attribute>
                        <xsl:call-template name="doDrawStyledCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="'ID'"/>
                            <xsl:with-param name="style" select="'header'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawStyledCell">
                            <xsl:with-param name="column" select="2"/>
                            <xsl:with-param name="data" select="'ValidatieVerzoek'"/>
                            <xsl:with-param name="style" select="'header'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawStyledCell">
                            <xsl:with-param name="column" select="3"/>
                            <xsl:with-param name="data" select="'Uitkomst'"/>
                            <xsl:with-param name="style" select="'header'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawStyledCell">
                            <xsl:with-param name="column" select="4"/>
                            <xsl:with-param name="data" select="'Melding'"/>
                            <xsl:with-param name="style" select="'header'"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Row" namespace="{$defNS}"/>
                    <xsl:element name="Row" namespace="{$defNS}"/>
                    <xsl:for-each select="envelop">
                        <xsl:element name="Row" namespace="{$defNS}">
                            <xsl:choose>
                                <xsl:when
                                    test="
                                        (count(lvbb:validatieVerzoekResultaat/lvbb:verslag/lvbb:meldingen/lvbb:melding) > 0)
                                        or (count(lvbb:validatieVerzoekResultaat/lvbb:verslag) = 0 and count(lvbb:validatieVerzoekResultaat/lvbb:meldingen/lvbb:melding) > 0)">
                                    <xsl:attribute name="ss:StyleID">
                                        <xsl:value-of select="'id'"/>
                                    </xsl:attribute>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:attribute name="ss:StyleID">
                                        <xsl:value-of select="'yellow'"/>
                                    </xsl:attribute>
                                </xsl:otherwise>
                            </xsl:choose>
                            <xsl:variable name="testId" select="do:returnTestId(test/text())"/>
                            <xsl:call-template name="doDrawCell">
                                <xsl:with-param name="column" select="1"/>
                                <xsl:with-param name="data" select="$testId"/>
                            </xsl:call-template>
                            <xsl:call-template name="doDrawCell">
                                <xsl:with-param name="column" select="3"/>
                                <xsl:with-param name="data" select="lvbb:validatieVerzoekResultaat[1]/lvbb:uitkomst/text()"/>
                            </xsl:call-template>
                        </xsl:element>
                        <xsl:for-each select="lvbb:validatieVerzoekResultaat">
                            <xsl:choose>
                                <!-- ALS ER VERSLAG IS WORDEN MELDINGEN NIET UIT VERSLAG OVERGESLAGEN -->
                                <xsl:when test="lvbb:verslag">
                                    <xsl:if test="lvbb:verslag/lvbb:meldingen">
                                        <xsl:for-each select="lvbb:verslag/lvbb:meldingen/lvbb:melding">
                                            <xsl:call-template name="doWerkblad1Item">
                                                <xsl:with-param name="testId" select="do:returnTestId(../../../../test/text())"/>
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="lvbb:meldingen">
                                        <xsl:for-each select="lvbb:meldingen/lvbb:melding">
                                            <xsl:call-template name="doWerkblad1Item">
                                                <xsl:with-param name="testId" select="do:returnTestId(../../../test/text())"/>
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            <!-- WORKSHEET: Filterbaar Validatie-Resultaat  -->
            <xsl:element name="Worksheet" namespace="{$defNS}">
                <xsl:attribute name="ss:Name">Filterbaar Validatie-Resultaat</xsl:attribute>
                <xsl:element name="Table" namespace="{$defNS}">
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:attribute name="ss:Index">
                            <xsl:value-of select="1"/>
                        </xsl:attribute>
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="'ID'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="2"/>
                            <xsl:with-param name="data" select="'Fout Gedetecteerd'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="3"/>
                            <xsl:with-param name="data" select="'Inhoudelijk of technisch'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="4"/>
                            <xsl:with-param name="data" select="'Categorie'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="5"/>
                            <xsl:with-param name="data" select="'Beschrijving'"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:for-each select="envelop">
                        <xsl:variable name="testId" select="do:returnTestId(test/text())"/>
                        <xsl:for-each select="lvbb:validatieVerzoekResultaat">
                            <xsl:choose>
                                <!-- ALS ER VERSLAG IS WORDEN MELDINGEN NIET UIT VERSLAG OVERGESLAGEN -->
                                <xsl:when test="count(lvbb:verslag/lvbb:meldingen/lvbb:melding) = 0 and count(lvbb:meldingen/lvbb:melding) = 0">
                                    <xsl:element name="Row" namespace="{$defNS}">
                                        <xsl:call-template name="doDrawStyledCell">
                                            <xsl:with-param name="column" select="1"/>
                                            <xsl:with-param name="data" select="$testId"/>
                                            <xsl:with-param name="style" select="'yellow'"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:when test="lvbb:verslag">
                                    <xsl:if test="lvbb:verslag/lvbb:meldingen">
                                        <xsl:for-each select="lvbb:verslag/lvbb:meldingen/lvbb:melding">
                                            <xsl:call-template name="doWerkblad2Rij">
                                                <xsl:with-param name="testId" select="$testId"/>
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="lvbb:meldingen">
                                        <xsl:for-each select="lvbb:meldingen/lvbb:melding">
                                            <xsl:call-template name="doWerkblad2Rij">
                                                <xsl:with-param name="testId" select="$testId"/>
                                                <xsl:with-param name="node" select="."/>
                                            </xsl:call-template>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
            <!-- WORKSHEET: Filterbaar Validatie-Resultaat  -->
            <!--<xsl:variable name="alleTests" select="0" saxon:assignable="yes"/>
            <xsl:variable name="testsMetEenResultaat" select="0" saxon:assignable="yes"/>
            <xsl:variable name="testsMetMeerdereResultaten" select="0" saxon:assignable="yes"/>
            <xsl:variable name="testsMetGeenResultaten" select="0" saxon:assignable="yes"/>
            <xsl:variable name="resultaten" select="0" saxon:assignable="yes"/>
            -->
            <xsl:for-each select="envelop">
                <xsl:if test="position()=1">
                    <saxon:assign name="datum" 
                        select="replace(substring-before(lvbb:validatieVerzoekResultaat[1]/lvbb:verslag/lvbb:tijdstipVerslag/text(), '.'),'T',' ')" 
                        saxon:assignable="yes"/>
                </xsl:if>
                <xsl:variable name="error" select="do:returnTestId(test/text())"/>
                <saxon:assign name="found" select="false()" saxon:assignable="yes"/>
                <xsl:for-each select="lvbb:validatieVerzoekResultaat/lvbb:verslag/lvbb:meldingen/lvbb:melding">
                    <xsl:if test="$error=stop:code/text()">
                        <saxon:assign name="found" select="true()" saxon:assignable="yes"/>
                    </xsl:if>
                </xsl:for-each>
                <xsl:for-each select="lvbb:validatieVerzoekResultaat/lvbb:meldingen/lvbb:melding">
                    <xsl:if test="$error=stop:code/text()">
                        <saxon:assign name="found" select="true()" saxon:assignable="yes"/>
                    </xsl:if>
                </xsl:for-each>
                <saxon:assign name="alleTests" select="$alleTests+1"></saxon:assign>
                <xsl:variable name="aantalVerslagMeldingen" select="count(lvbb:validatieVerzoekResultaat/lvbb:verslag/lvbb:meldingen/lvbb:melding/stop:code)"/>
                <xsl:variable name="aantalMeldingen" select="do:aantalMeldingen(.)"/>
                <xsl:if test="($aantalVerslagMeldingen=1 or $aantalMeldingen=1) and $found=true()">
                    <saxon:assign name="testsMetEenResultaat" select="$testsMetEenResultaat+1" saxon:assignable="yes"/>
                </xsl:if>
                <xsl:if test="($aantalVerslagMeldingen=1 or $aantalMeldingen=1) and $found=false()">
                    <saxon:assign name="testsMetEenFoutResultaat" select="$testsMetEenFoutResultaat+1" saxon:assignable="yes"/>
                </xsl:if>
                <xsl:if test="($aantalVerslagMeldingen>1 or $aantalMeldingen>1)">
                    <saxon:assign name="testsMetMeerdereResultaten" select="$testsMetMeerdereResultaten+1" saxon:assignable="yes"/>
                </xsl:if>
                <xsl:if test="($aantalVerslagMeldingen=0 and $aantalMeldingen=0)">
                    <saxon:assign name="testsMetGeenResultaten" select="$testsMetGeenResultaten+1" saxon:assignable="yes"/>
                </xsl:if>
            </xsl:for-each>
            <xsl:element name="Worksheet" namespace="{$defNS}">
                <xsl:attribute name="ss:Name">Validatie-rapport</xsl:attribute>
                <xsl:element name="Table" namespace="{$defNS}">
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:call-template name="doDrawStyledCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="concat('Resultaat:   ', $datum)"/>
                            <xsl:with-param name="style" select="'header'"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="'Het aantal testgevallen is:'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawIntegerCell">
                            <xsl:with-param name="column" select="5"/>
                            <xsl:with-param name="data" select="$alleTests"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="'Gezochte fout was de enige terugmelding:'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawIntegerCell">
                            <xsl:with-param name="column" select="5"/>
                            <xsl:with-param name="data" select="$testsMetEenResultaat"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="'Andere fout was de enige terugmelding:'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawIntegerCell">
                            <xsl:with-param name="column" select="5"/>
                            <xsl:with-param name="data" select="$testsMetEenFoutResultaat"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="'Meerdere fouten teruggegeven in de keten:'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawIntegerCell">
                            <xsl:with-param name="column" select="5"/>
                            <xsl:with-param name="data" select="$testsMetMeerdereResultaten"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:element name="Row" namespace="{$defNS}">
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="1"/>
                            <xsl:with-param name="data" select="'Geen fouten gevonden vanuit de keten:'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawIntegerCell">
                            <xsl:with-param name="column" select="5"/>
                            <xsl:with-param name="data" select="$testsMetGeenResultaten"/>
                        </xsl:call-template>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="doWerkblad1Item">
        <xsl:param name="testId" as="xs:string"/>
        <xsl:param name="node" as="node()"/>
        <xsl:variable name="meldingColor">
            <xsl:choose>
                <xsl:when test="$node/stop:code/text() = $testId">
                    <xsl:value-of select="'green'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'yellow'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="Row" namespace="{$defNS}">
            <xsl:call-template name="doDrawStyledCell">
                <xsl:with-param name="column" select="4"/>
                <xsl:with-param name="data" select="'melding'"/>
                <xsl:with-param name="style" select="$meldingColor"/>
            </xsl:call-template>
            <xsl:call-template name="doDrawCell">
                <xsl:with-param name="column" select="5"/>
                <xsl:with-param name="data" select="concat($node/stop:code/text(), ',&#x09;', $node/stop:ernst, ',&#x09;', $node/stop:soort)"/>
            </xsl:call-template>
        </xsl:element>
        <xsl:if test="$node/stop:categorie">
            <xsl:element name="Row" namespace="{$defNS}">
                <xsl:call-template name="doDrawCell">
                    <xsl:with-param name="column" select="5"/>
                    <xsl:with-param name="data" select="$node/stop:categorie/text()"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:if>
        <xsl:if test="$node/stop:beschrijving">
            <xsl:element name="Row" namespace="{$defNS}">
                <xsl:call-template name="doDrawCell">
                    <xsl:with-param name="column" select="5"/>
                    <xsl:with-param name="data" select="$node/stop:beschrijving/text()"/>
                </xsl:call-template>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template name="doWerkblad2Rij">
        <xsl:param name="testId" as="xs:string"/>
        <xsl:param name="node" as="node()"/>
        <xsl:element name="Row" namespace="{$defNS}">
            <xsl:choose>
                <xsl:when test="position() = 1">
                    <xsl:call-template name="doDrawStyledCell">
                        <xsl:with-param name="column" select="1"/>
                        <xsl:with-param name="data" select="$testId"/>
                        <xsl:with-param name="style" select="'grey'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="doDrawCell">
                        <xsl:with-param name="column" select="1"/>
                        <xsl:with-param name="data" select="$testId"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:choose>
                <xsl:when test="$node/stop:code/text() = $testId">
                    <xsl:call-template name="doDrawStyledCell">
                        <xsl:with-param name="column" select="2"/>
                        <xsl:with-param name="data" select="$node/stop:code/text()"/>
                        <xsl:with-param name="style" select="'id'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="doDrawCell">
                        <xsl:with-param name="column" select="2"/>
                        <xsl:with-param name="data" select="$node/stop:code/text()"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:call-template name="doDrawCell">
                <xsl:with-param name="column" select="3"/>
                <xsl:with-param name="data" select="$node/stop:soort"/>
            </xsl:call-template>
            <xsl:if test="$node/stop:categorie">
                <xsl:call-template name="doDrawCell">
                    <xsl:with-param name="column" select="4"/>
                    <xsl:with-param name="data" select="$node/stop:categorie/text()"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:if test="$node/stop:beschrijving">
                <xsl:call-template name="doDrawCell">
                    <xsl:with-param name="column" select="5"/>
                    <xsl:with-param name="data" select="$node/stop:beschrijving/text()"/>
                </xsl:call-template>
            </xsl:if>
        </xsl:element>

    </xsl:template>
    
    <xsl:function name="do:aantalMeldingen">
        <xsl:param name="envelop" as="node()"/>
        <xsl:choose>
            <xsl:when test="
                count($envelop/lvbb:validatieVerzoekResultaat/lvbb:verslag/lvbb:meldingen/lvbb:melding/stop:code)=0
                and not($envelop/lvbb:validatieVerzoekResultaat/lvbb:meldingen/lvbb:melding/stop:ernst/text()='informatie')
                ">
                <xsl:value-of select="count($envelop/lvbb:validatieVerzoekResultaat/lvbb:meldingen/lvbb:melding/stop:code)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="do:colorTheCode">
        <xsl:param name="meldingen" as="node()"/>
        <xsl:param name="testString" as="node()"/>
        <xsl:variable name="meldingenList">
            <xsl:sequence>
                <xsl:value-of select="$meldingen/lvbb:melding/stop:code/text()"/>
            </xsl:sequence>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($meldingenList, $testString)">
                <xsl:choose>
                    <xsl:when test="count($meldingen/lvbb:melding) > 1">
                        <xsl:value-of select="'yellow'"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="'green'"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'red'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="do:returnTestIdPlusSetId">
        <xsl:param name="testId" as="xs:string"/>
        <xsl:value-of select="concat(substring-before($testId, '-'), ' (', $testId, ')')"/>
    </xsl:function>

    <xsl:function name="do:returnTestId">
        <xsl:param name="testId" as="xs:string"/>
        <xsl:value-of select="substring-before($testId, '-')"/>
    </xsl:function>

    <xsl:template name="doDrawCell">
        <xsl:param name="column" as="xs:integer"/>
        <xsl:param name="data" as="xs:string"/>
        <xsl:element name="Cell" namespace="{$defNS}">
            <xsl:attribute name="ss:Index">
                <xsl:value-of select="$column"/>
            </xsl:attribute>
            <xsl:element name="Data" namespace="{$defNS}">
                <xsl:attribute name="ss:Type">
                    <xsl:value-of select="'String'"/>
                </xsl:attribute>
                <xsl:value-of select="$data"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="doDrawIntegerCell">
        <xsl:param name="column" as="xs:integer"/>
        <xsl:param name="data" as="xs:integer"/>
        <xsl:element name="Cell" namespace="{$defNS}">
            <xsl:attribute name="ss:Index">
                <xsl:value-of select="$column"/>
            </xsl:attribute>
            <xsl:element name="Data" namespace="{$defNS}">
                <xsl:attribute name="ss:Type">
                    <xsl:value-of select="'Number'"/>
                </xsl:attribute>
                <xsl:value-of select="$data"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="doDrawStyledCell">
        <xsl:param name="column" as="xs:integer"/>
        <xsl:param name="data" as="xs:string"/>
        <xsl:param name="style" as="xs:string"/>
        <xsl:element name="Cell" namespace="{$defNS}">
            <xsl:attribute name="ss:Index">
                <xsl:value-of select="$column"/>
            </xsl:attribute>
            <xsl:attribute name="ss:StyleID">
                <xsl:value-of select="$style"/>
            </xsl:attribute>
            <xsl:element name="Data" namespace="{$defNS}">
                <xsl:attribute name="ss:Type">
                    <xsl:value-of select="'String'"/>
                </xsl:attribute>
                <xsl:value-of select="$data"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

</xsl:stylesheet>
