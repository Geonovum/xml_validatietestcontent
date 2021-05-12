<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    xmlns:fn="http://www.w3.org/2005/xpath-functions" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" 
    xmlns:ow="http://www.geostandaarden.nl/imow/owobject" 
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" 
    xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" 
    xmlns:k="http://www.geostandaarden.nl/imow/kaart" 
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" 
    xmlns:p="http://www.geostandaarden.nl/imow/pons" 
    xmlns:r="http://www.geostandaarden.nl/imow/regels" 
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" 
    xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" 
    xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst" 
    xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" 
    xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0"
    xmlns:lvbb="http://www.overheid.nl/2017/lvbb"
    xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    
    xmlns:foo="http://whatever"
    >
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
    
    <xsl:param name="dateTime"/>
    <xsl:param name="oldOWId"/>
    <xsl:param name="newOWId"/>


    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="r:identificatie[text()=$oldOWId]">
        <xsl:element name="r:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="vt:identificatie[text()=$oldOWId]">
        <xsl:element name="vt:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="rol:identificatie[text()=$oldOWId]">
        <xsl:element name="rol:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="ga:identificatie[text()=$oldOWId]">
        <xsl:element name="ga:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="l:identificatie[text()=$oldOWId]">
        <xsl:element name="l:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="p:identificatie[text()=$oldOWId]">
        <xsl:element name="p:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="k:identificatie[text()=$oldOWId]">
        <xsl:element name="k:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="rg:identificatie[text()=$oldOWId]">
        <xsl:element name="rg:identificatie">
            <xsl:value-of select="$newOWId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="@xlink:href[contains(.,$oldOWId)]">
        <xsl:attribute name="xlink:href">
            <xsl:value-of select="$newOWId"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:function name="foo:generateOWId">
        <xsl:param name="seeder"/>
        <xsl:param name="oldId" as="xs:string"/>
        <!-- max length 4th part of Id has a max-length of 32-->
        <xsl:variable name="maxLength" select="32 - string-length(tokenize($oldId, '\.')[4])"/>
        <xsl:choose>
            <xsl:when test="contains($oldId, 'FOUT')">
                <xsl:choose>
                    <xsl:when test="$maxLength > 13">
                        <xsl:variable name="dateString" select="concat($dateTime,'FOUT')"/>
                        <xsl:value-of select="concat(tokenize($oldId, '\.')[1], '.', tokenize($oldId, '\.')[2], '.', tokenize($oldId, '\.')[3], '.', $seeder, $dateString)"/>
                    </xsl:when>
                    <xsl:when test="$maxLength > 0 and $maxLength &lt; 14">
                        <xsl:variable name="dateString" select="substring(concat($dateTime,'FOUT'), 14 - $maxLength)"/>
                        <xsl:value-of select="concat(tokenize($oldId, '\.')[1], '.', tokenize($oldId, '\.')[2], '.', tokenize($oldId, '\.')[3], '.', $seeder, $dateString)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat(tokenize($oldId, '\.')[1], '.', tokenize($oldId, '\.')[2], '.', tokenize($oldId, '\.')[3], '.', concat($dateTime,'FOUT'))"/>
                    </xsl:otherwise>
                </xsl:choose>
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
    

</xsl:stylesheet>