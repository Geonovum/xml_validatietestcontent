<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:do="http://whatever" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:stop="http://www.overheid.nl/2017/stop" exclude-result-prefixes="xs" version="2.0">

    <xsl:output omit-xml-declaration="no"/>
    <xsl:output method="xml"/>
    <xsl:variable name="defNS" select="string('urn:schemas-microsoft-com:office:spreadsheet')"/>

    <xsl:template match="/">
        <xsl:variable name="fileUrl" select="replace(tokenize(document-uri(), '/')[last()], '.xml', '_excel.xml')"/>
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
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">header</xsl:attribute>
                    <xsl:element name="Font" namespace="{$defNS}">
                        <xsl:attribute name="ss:FontName">Verdana</xsl:attribute>
                        <xsl:attribute name="ss:Bold">1</xsl:attribute>
                    </xsl:element>
                </xsl:element>
                <xsl:element name="Style" namespace="{$defNS}">
                    <xsl:attribute name="ss:ID">id</xsl:attribute>
                    <xsl:element name="Font" namespace="{$defNS}">
                        <xsl:attribute name="ss:FontName">Verdana</xsl:attribute>
                    </xsl:element>
                    <xsl:element name="Interior" namespace="{$defNS}">
                        <xsl:attribute name="ss:Color">#2DFF96</xsl:attribute>
                        <xsl:attribute name="ss:Pattern">Solid</xsl:attribute>
                    </xsl:element>
                </xsl:element>
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
            </xsl:element>
            <xsl:element name="Worksheet" namespace="{$defNS}">
                <xsl:attribute name="ss:Name">Validatie-Resultaat</xsl:attribute>
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
                    <xsl:variable name="nodeSequence" as="node()*">
                        <xsl:variable name="startPos" select="1"/>
                        <xsl:for-each select="envelop">
                            <xsl:variable name="envelopCounter" select="position() + $startPos"/>
                            <xsl:variable name="testId" select="do:returnTestId(test)"/>
                            <xsl:sequence>
                                <xsl:call-template name="doDrawStyledCell">
                                    <xsl:with-param name="column" select="1"/>
                                    <xsl:with-param name="data" select="$testId"/>
                                    <xsl:with-param name="style" select="'id'"/>
                                </xsl:call-template>
                            </xsl:sequence>
                            <xsl:for-each select="lvbb:validatieVerzoekResultaat">
                                <xsl:sequence>
                                    <xsl:call-template name="doDrawStyledNumericCell">
                                        <xsl:with-param name="column" select="2"/>
                                        <xsl:with-param name="data" select="position()"/>
                                        <xsl:with-param name="style" select="'validatie'"/>
                                    </xsl:call-template>
                                </xsl:sequence>
                                <xsl:sequence>
                                    <xsl:call-template name="doDrawCell">
                                        <xsl:with-param name="column" select="3"/>
                                        <xsl:with-param name="data" select="lvbb:uitkomst"/>
                                    </xsl:call-template>
                                </xsl:sequence>
                                <xsl:for-each select="lvbb:verslag/lvbb:meldingen/lvbb:melding">
                                    <xsl:sequence>
                                        <xsl:call-template name="doDrawCell">
                                            <xsl:with-param name="column" select="4"/>
                                            <xsl:with-param name="data" select="'melding'"/>
                                        </xsl:call-template>
                                    </xsl:sequence>
                                </xsl:for-each>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:message select="count($nodeSequence)"/>
                    <xsl:for-each select="$nodeSequence">
                        <xsl:element name="Row" namespace="{$defNS}">
                            <xsl:attribute name="ss:Index">
                                <xsl:value-of select="position() + 2"/>
                            </xsl:attribute>
                            <xsl:attribute name="ss:StyleID">
                                <xsl:value-of select="./@ss:StyleID"/>
                            </xsl:attribute>
                            <xsl:copy-of select="."/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:function name="do:returnTestId">
        <xsl:param name="testId" as="node()"/>
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

</xsl:stylesheet>
