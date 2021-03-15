<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:do="http://whatever" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:stop="http://www.overheid.nl/2017/stop" exclude-result-prefixes="xs"
    xmlns:saxon="http://saxon.sf.net/" extension-element-prefixes="saxon" version="3.0">

    <xsl:output omit-xml-declaration="no"/>
    <xsl:output method="xml"/>
    <xsl:variable name="defNS" select="string('urn:schemas-microsoft-com:office:spreadsheet')"/>
    <xsl:variable name="counter" select="1" saxon:assignable="yes"/>
    <xsl:variable name="subCounter" select="0" saxon:assignable="yes"/>


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
            </xsl:element>
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
                                <xsl:when test="(count(lvbb:validatieVerzoekResultaat/lvbb:verslag/lvbb:meldingen/lvbb:melding)>0)
                                    or (count(lvbb:validatieVerzoekResultaat/lvbb:verslag)=0 and count(lvbb:validatieVerzoekResultaat/lvbb:meldingen/lvbb:melding)>0)">
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
                                            <xsl:variable name="meldingColor">
                                                <xsl:choose>
                                                    <xsl:when test="stop:code/text() = do:returnTestId(../../../../test/text())">
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
                                                    <xsl:with-param name="data" select="concat(stop:code/text(), ',&#x09;', stop:ernst, ',&#x09;', stop:soort)"/>
                                                </xsl:call-template>
                                            </xsl:element>
                                            <xsl:if test="stop:categorie">
                                                <xsl:element name="Row" namespace="{$defNS}">
                                                    <xsl:call-template name="doDrawCell">
                                                        <xsl:with-param name="column" select="5"/>
                                                        <xsl:with-param name="data" select="stop:categorie/text()"/>
                                                    </xsl:call-template>
                                                </xsl:element>
                                            </xsl:if>
                                            <xsl:if test="stop:beschrijving">
                                                <xsl:element name="Row" namespace="{$defNS}">
                                                    <xsl:call-template name="doDrawCell">
                                                        <xsl:with-param name="column" select="5"/>
                                                        <xsl:with-param name="data" select="stop:beschrijving/text()"/>
                                                    </xsl:call-template>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:if test="lvbb:meldingen">
                                        <xsl:for-each select="lvbb:meldingen/lvbb:melding">
                                            <xsl:variable name="meldingColor">
                                                <xsl:choose>
                                                    <xsl:when test="stop:code/text() = do:returnTestId(../../../test/text())">
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
                                                    <xsl:with-param name="data" select="concat(stop:code/text(), ',&#x09;', stop:ernst, ',&#x09;', stop:soort)"/>
                                                </xsl:call-template>
                                                <xsl:if test="stop:categorie">
                                                    <xsl:call-template name="doDrawCell">
                                                        <xsl:with-param name="column" select="5"/>
                                                        <xsl:with-param name="data" select="stop:categorie/text()"/>
                                                    </xsl:call-template>
                                                </xsl:if>
                                            </xsl:element>
                                            <xsl:if test="stop:beschrijving">
                                                <xsl:element name="Row" namespace="{$defNS}">
                                                    <xsl:call-template name="doDrawCell">
                                                        <xsl:with-param name="column" select="5"/>
                                                        <xsl:with-param name="data" select="stop:beschrijving/text()"/>
                                                    </xsl:call-template>
                                                </xsl:element>
                                            </xsl:if>
                                        </xsl:for-each>
                                    </xsl:if>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
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
                            <xsl:with-param name="data" select="'ValidatieVerzoek'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="3"/>
                            <xsl:with-param name="data" select="'Fout Gedetecteerd'"/>
                        </xsl:call-template>
                        <xsl:call-template name="doDrawCell">
                            <xsl:with-param name="column" select="7"/>
                            <xsl:with-param name="data" select="'Melding'"/>
                        </xsl:call-template>
                    </xsl:element>
                    <xsl:for-each select="envelop">
                        <saxon:assign name="subCounter" select="0"/>
                        <xsl:variable name="testId" select="do:returnTestId(test/text())"/>
                        <xsl:for-each select="lvbb:validatieVerzoekResultaat">
                            <xsl:for-each select="lvbb:verslag/lvbb:meldingen/lvbb:melding">
                                <saxon:assign name="counter" select="$counter + 1"/>
                                <saxon:assign name="subCounter" select="$subCounter + 1"/>
                                <xsl:element name="Row" namespace="{$defNS}">
                                    <xsl:attribute name="ss:Index">
                                        <xsl:value-of select="$counter"/>
                                    </xsl:attribute>
                                    <!-- VALIDATIE KENMERK -->
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <xsl:call-template name="doDrawStyledCell">
                                                <xsl:with-param name="column" select="1"/>
                                                <xsl:with-param name="data" select="$testId"/>
                                                <xsl:with-param name="style" select="'id'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="doDrawCell">
                                                <xsl:with-param name="column" select="1"/>
                                                <xsl:with-param name="data" select="$testId"/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <!-- TEST NUMMER BINNEN VALIDATIE -->
                                    <xsl:call-template name="doDrawNumericCell">
                                        <xsl:with-param name="column" select="2"/>
                                        <xsl:with-param name="data" select="$subCounter"/>
                                    </xsl:call-template>
                                    <xsl:variable name="meldingColor">
                                        <xsl:choose>
                                            <xsl:when test="stop:code/text() = do:returnTestId(../../../../test/text())">
                                                <xsl:value-of select="'green'"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'yellow'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:call-template name="doDrawStyledCell">
                                        <xsl:with-param name="column" select="3"/>
                                        <xsl:with-param name="data" select="stop:code/text()"/>
                                        <xsl:with-param name="style" select="$meldingColor"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="doDrawCell">
                                        <xsl:with-param name="column" select="4"/>
                                        <xsl:with-param name="data" select="stop:ernst"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="doDrawCell">
                                        <xsl:with-param name="column" select="5"/>
                                        <xsl:with-param name="data" select="stop:soort"/>
                                    </xsl:call-template>
                                    <xsl:if test="stop:categorie">
                                        <xsl:call-template name="doDrawCell">
                                            <xsl:with-param name="column" select="6"/>
                                            <xsl:with-param name="data" select="stop:categorie/text()"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                    <xsl:if test="stop:beschrijving">
                                        <xsl:call-template name="doDrawCell">
                                            <xsl:with-param name="column" select="7"/>
                                            <xsl:with-param name="data" select="stop:beschrijving/text()"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="lvbb:meldingen/lvbb:melding">
                                <saxon:assign name="counter" select="$counter + 1"/>
                                <saxon:assign name="subCounter" select="$subCounter + 1"/>
                                <xsl:element name="Row" namespace="{$defNS}">
                                    <xsl:attribute name="ss:Index">
                                        <xsl:value-of select="$counter"/>
                                    </xsl:attribute>
                                    <!-- VALIDATIE KENMERK -->
                                    <xsl:choose>
                                        <xsl:when test="position() = 1">
                                            <xsl:call-template name="doDrawStyledCell">
                                                <xsl:with-param name="column" select="1"/>
                                                <xsl:with-param name="data" select="$testId"/>
                                                <xsl:with-param name="style" select="'id'"/>
                                            </xsl:call-template>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:call-template name="doDrawCell">
                                                <xsl:with-param name="column" select="1"/>
                                                <xsl:with-param name="data" select="$testId"/>
                                            </xsl:call-template>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <!-- TEST NUMMER BINNEN VALIDATIE -->
                                    <xsl:call-template name="doDrawNumericCell">
                                        <xsl:with-param name="column" select="2"/>
                                        <xsl:with-param name="data" select="$subCounter"/>
                                    </xsl:call-template>
                                    <xsl:variable name="meldingColor">
                                        <xsl:choose>
                                            <xsl:when test="stop:code/text() = do:returnTestId(../../../test/text())">
                                                <xsl:value-of select="'green'"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of select="'yellow'"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:variable>
                                    <xsl:call-template name="doDrawStyledCell">
                                        <xsl:with-param name="column" select="3"/>
                                        <xsl:with-param name="data" select="stop:code/text()"/>
                                        <xsl:with-param name="style" select="$meldingColor"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="doDrawCell">
                                        <xsl:with-param name="column" select="4"/>
                                        <xsl:with-param name="data" select="stop:ernst"/>
                                    </xsl:call-template>
                                    <xsl:call-template name="doDrawCell">
                                        <xsl:with-param name="column" select="5"/>
                                        <xsl:with-param name="data" select="stop:soort"/>
                                    </xsl:call-template>
                                    <xsl:if test="stop:categorie">
                                        <xsl:call-template name="doDrawCell">
                                            <xsl:with-param name="column" select="6"/>
                                            <xsl:with-param name="data" select="stop:categorie/text()"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                    <xsl:if test="stop:beschrijving">
                                        <xsl:call-template name="doDrawCell">
                                            <xsl:with-param name="column" select="7"/>
                                            <xsl:with-param name="data" select="stop:beschrijving/text()"/>
                                        </xsl:call-template>
                                    </xsl:if>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

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

    <xsl:function name="do:counter">
        <xsl:param name="initial" as="xs:integer"/>
        <xsl:value-of select="$initial + 1"/>
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

    <xsl:template name="doDrawHeaderCell">
        <xsl:param name="column" as="xs:integer"/>
        <xsl:param name="data" as="xs:string"/>
        <xsl:element name="Cell" namespace="{$defNS}">
            <xsl:attribute name="ss:Index">
                <xsl:value-of select="$column"/>
            </xsl:attribute>
            <xsl:attribute name="ss:StyleID">
                <xsl:value-of select="'header'"/>
            </xsl:attribute>
            <xsl:element name="Data" namespace="{$defNS}">
                <xsl:attribute name="ss:Type">
                    <xsl:value-of select="'String'"/>
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

    <xsl:template name="doDrawStyledNumericCell">
        <xsl:param name="column" as="xs:integer"/>
        <xsl:param name="data" as="xs:integer"/>
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
                    <xsl:value-of select="'Number'"/>
                </xsl:attribute>
                <xsl:value-of select="$data"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template name="doDrawNumericCell">
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

</xsl:stylesheet>
