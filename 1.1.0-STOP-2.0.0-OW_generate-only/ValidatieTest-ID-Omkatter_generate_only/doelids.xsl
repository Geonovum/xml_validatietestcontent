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
    xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    
    xmlns:foo="http://whatever"
    >
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>
    
    <xsl:param name="alreadyRetrievedDateTime"/>
    <!-- The orgfiledir bevat het test-validatie-bestand dat wordt aangeboden. Bijvoorbeeld LVBB1013 -->
    <xsl:param name="org.file.dir"></xsl:param>
    
    <xsl:template match="@*|node()">
        <xsl:copy>
            <xsl:apply-templates select="@*|node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="manifest-ow:DoelID">
        <xsl:element name="manifest-ow:DoelID">
            <xsl:choose>
                <xsl:when test="$org.file.dir='LVBB1028'">
                    <xsl:value-of select="text()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="foo:replaceDoelID(text())"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="data:doelen/data:doel">
        <xsl:element name="data:doel">
            <xsl:value-of select="foo:replaceDoelID(text())"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="data:Tijdstempel/data:doel">
        <xsl:element name="data:doel">
            <xsl:value-of select="foo:replaceDoelID(text())"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:function name="foo:changePart">
        <xsl:param name="oldPart" as="xs:string"/>
        <xsl:param name="newPart" as="xs:string"></xsl:param>
        <xsl:choose>
            <!-- Indien het id het woordje FOUT bevat, dient wordt het woordje fout toegevoegd, hij is immers om een fout te triggeren -->
            <xsl:when test="contains($oldPart, 'FOUT')">
                <xsl:value-of select="$oldPart"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$newPart"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
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
    
    <xsl:function name="foo:generateDoelId">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="($org.file.dir = 'OZON0218') or ($org.file.dir = 'OZON0219') or ($org.file.dir = 'OZON1036')">
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7],'-',foo:changePart($org.file.dir)))"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', foo:changePart($org.file.dir))"
                />
            </xsl:otherwise>
        </xsl:choose>
<!--        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', foo:changePart($org.file.dir))"
        />
-->    </xsl:function>
    
    
    <xsl:function name="foo:replaceDoelID">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:variable name="newId" as="xs:string" select="foo:generateDoelId($oldId)"/>
        <xsl:value-of
            select="concat('/', 
            foo:changePart(tokenize($oldId, '/')[2],tokenize($newId, '/')[2]),'/',
            foo:changePart(tokenize($oldId, '/')[3],tokenize($newId, '/')[3]),'/',
            foo:changePart(tokenize($oldId, '/')[4],tokenize($newId, '/')[4]),'/',
            foo:changePart(tokenize($oldId, '/')[5],tokenize($newId, '/')[5]),'/',
            foo:changePart(tokenize($oldId, '/')[6],tokenize($newId, '/')[6]),'/',
            foo:changePart(tokenize($oldId, '/')[7],tokenize($newId, '/')[7])
            )"
        />
    </xsl:function>

</xsl:stylesheet>