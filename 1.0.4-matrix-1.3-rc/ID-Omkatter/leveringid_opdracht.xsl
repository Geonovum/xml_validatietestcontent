<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <xsl:param name="newId"/>
    
    <xsl:param name="alreadyRetrievedDateTime"/>
    <!-- The orgfiledir bevat het test-validatie-bestand dat wordt aangeboden. Bijvoorbeeld LVBB1013 -->
    <xsl:param name="org.file.dir"></xsl:param>

    <xsl:variable name="dateAfterTomorrow" select="format-dateTime(current-dateTime() + xs:dayTimeDuration('P3D'), '[Y0001]-[M01]-[D01]')"/>
    <xsl:variable name="dateYesterday" select="format-dateTime(current-dateTime() - xs:dayTimeDuration('P1D'), '[Y0001]-[M01]-[D01]')"/>


    <!-- ********   LET OP EN LEES DIT !!!!! ********** -->
    <!-- HAAL (indien nodig/gewenst) DE comment-tekens BIJ DE *CODE* WEG -->
    <!-- VUL DAN HIER UW ID's IN, LET OP DE QUOTES (EEN MAAL DUBBEL, EEN MAAL ENKEL, bijv: "'XXX'") -->
    <!-- Als u dit niet goed doet worden de strings gezien als een nummer en worden de voorloop-nullen weggehaald! -->
    <!-- ********   *CODE* (hieronder) ********** -->
    <!--
    <xsl:variable name="idBevoegdGezag" select="'00000001003214345000'"/>
    <xsl:variable name="idAanleveraar" select="'00000001003214345000'"/>
    
    <xsl:template match="lvbb:idAanleveraar">
        <xsl:element name="lvbb:idAanleveraar">
            <xsl:value-of select="$idAanleveraar"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="lvbb:idBevoegdGezag">
        <xsl:element name="lvbb:idBevoegdGezag">
            <xsl:value-of select="$idBevoegdGezag"/>
        </xsl:element>
    </xsl:template>
    -->


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="sl:leveringsId">
        <xsl:element name="sl:leveringsId">
            <xsl:value-of select="$newId"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="lvbb:datumBekendmaking">
        <!-- LET OP NIET IN STANDAARD UNIFICERING -->
        <xsl:element name="datumBekendmaking" namespace="{namespace-uri()}">
            <xsl:choose>
                <xsl:when test="contains($newId, 'LVBB4712')">
                    <xsl:value-of select="text()"/>
                </xsl:when>
                <xsl:when test="contains($newId, 'LVBB1501_1')">
                    <xsl:value-of select="$dateYesterday"/>
                </xsl:when>
                <xsl:when test="contains($newId, 'LVBB1501_2')">
                    <xsl:value-of select="substring($dateAfterTomorrow,2)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$dateAfterTomorrow"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:element>
    </xsl:template>

    <xsl:template match="lvbb:idLevering">
        <xsl:element name="idLevering" namespace="{namespace-uri()}">
            <xsl:value-of select="$newId"/>
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
    
    <xsl:function name="foo:generateAKNFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', foo:changePart($org.file.dir)))"
        />
    </xsl:function>
    
    <xsl:function name="foo:generateAKNFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', foo:changePart($org.file.dir)), '/', tokenize($oldId, '/')[8])"
        />
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
    
    
    <xsl:function name="foo:replaceFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:variable name="newId" as="xs:string" select="foo:generateAKNFRBRWork($oldId)"/>
        <xsl:choose>
            <xsl:when test="count(tokenize($oldId, '/'))=7">
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
            </xsl:when>
            <xsl:when test="count(tokenize($oldId, '/'))=6">
                <xsl:value-of
                    select="concat('/', 
                    foo:changePart(tokenize($oldId, '/')[2],tokenize($newId, '/')[2]),'/',
                    foo:changePart(tokenize($oldId, '/')[3],tokenize($newId, '/')[3]),'/',
                    foo:changePart(tokenize($oldId, '/')[4],tokenize($newId, '/')[4]),'/',
                    foo:changePart(tokenize($oldId, '/')[5],tokenize($newId, '/')[5]),'/',
                    foo:changePart(tokenize($oldId, '/')[6],tokenize($newId, '/')[6])
                    )"
                />
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="foo:replaceFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:variable name="newId" as="xs:string" select="foo:generateAKNFRBRExpression($oldId)"/>
        <xsl:choose>
            <xsl:when test="count(tokenize($oldId, '/'))=8">
                <xsl:value-of
                    select="concat('/', 
                    foo:changePart(tokenize($oldId, '/')[2],tokenize($newId, '/')[2]),'/',
                    foo:changePart(tokenize($oldId, '/')[3],tokenize($newId, '/')[3]),'/',
                    foo:changePart(tokenize($oldId, '/')[4],tokenize($newId, '/')[4]),'/',
                    foo:changePart(tokenize($oldId, '/')[5],tokenize($newId, '/')[5]),'/',
                    foo:changePart(tokenize($oldId, '/')[6],tokenize($newId, '/')[6]),'/',
                    foo:changePart(tokenize($oldId, '/')[7],tokenize($newId, '/')[7]),'/',
                    foo:changePart(tokenize($oldId, '/')[8],tokenize($newId, '/')[8])
                    )"
                />
            </xsl:when>
            <xsl:when test="count(tokenize($oldId, '/'))=7">
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
            </xsl:when>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
