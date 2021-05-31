<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml"/>


    <xsl:template match="/">
        <xsl:variable name="fileUrl" select="'samenvatting.xml'"/>
        <xsl:message select="$fileUrl"/>
        <xsl:result-document href="{$fileUrl}" method="xml" indent="yes">
            <xsl:call-template name="samenvatting"/>
        </xsl:result-document>
    </xsl:template>


    <xsl:template name="samenvatting">
        <xsl:element name="samenvatting">
            <xsl:for-each select="//aanlevering:AanleveringBesluit/aanlevering:BesluitVersie">
                <xsl:element name="Besluitversie">
                    <xsl:if test="data:ExpressionIdentificatie/data:FRBRWork">
                        <xsl:element name="FRBRWork">
                            <xsl:value-of select="data:ExpressionIdentificatie/data:FRBRWork/text()"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:if test="data:ExpressionIdentificatie/data:FRBRExpression">
                        <xsl:element name="FRBRExpression">
                            <xsl:value-of select="data:ExpressionIdentificatie/data:FRBRExpression/text()"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                <xsl:element name="io-construct">
                    <xsl:if test="count(data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef)>0">
                        <xsl:element name="io-construct">
                            <xsl:value-of select="data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef[1]/text()"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
                <xsl:for-each select="tekst:BesluitCompact"></xsl:for-each>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>





</xsl:stylesheet>
