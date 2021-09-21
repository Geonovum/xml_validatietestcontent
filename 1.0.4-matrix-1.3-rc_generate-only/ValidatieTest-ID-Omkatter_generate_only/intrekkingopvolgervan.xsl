<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
    xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow" xmlns:consolidatie="https://standaarden.overheid.nl/stop/imop/consolidatie/"
    xmlns:lvbbu="https://standaarden.overheid.nl/lvbb/stop/uitlevering/" xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <xsl:param name="alreadyRetrievedDateTime"/>
    <!-- The orgfiledir bevat het test-validatie-bestand dat wordt aangeboden. Bijvoorbeeld LVBB1013 -->
    <xsl:param name="org.file.dir"/>
    <xsl:param name="inclusiefAfbreek"/>
    <xsl:param name="number"/>
    <xsl:param name="origineleregelingsFBRWork"/>
    
    <xsl:variable name="dateAfterTomorrow" select="format-dateTime(current-dateTime() + xs:dayTimeDuration('P3D'), '[Y0001]-[M01]-[D01]')"/>
    
    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="@was[. = $origineleregelingsFBRWork]">
        <xsl:attribute name="was">
            <xsl:value-of select="foo:generateAKNFRBRExpression(.)"/>
        </xsl:attribute>
    </xsl:template>
    
    <xsl:template match="data:opvolging/data:opvolgerVan[text() = $origineleregelingsFBRWork]">
        <xsl:element name="data:opvolgerVan">
            <xsl:value-of select="foo:generateAKNFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="data:Intrekkingen/data:Intrekking/data:instrument[text() = $origineleregelingsFBRWork]">
        <xsl:element name="data:instrument">
            <xsl:value-of select="foo:generateAKNFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:function name="foo:generateAKNFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="($org.file.dir = 'OZON0218') or ($org.file.dir = 'OZON0219') or ($org.file.dir = 'OZON1036') or ($org.file.dir = 'LVBB4701' and contains($oldId, 'kennisgeving01'))">
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', foo:changePart($org.file.dir)))"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', foo:changePart($org.file.dir))"
                />
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="foo:generateAKNFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:choose>
            <xsl:when
                test="($org.file.dir = 'OZON0218') or ($org.file.dir = 'OZON0219') or ($org.file.dir = 'OZON0219') or ($org.file.dir = 'OZON1036') or ($org.file.dir = 'LVBB4701' and contains($oldId, 'kennisgeving01'))">
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', foo:changePart($org.file.dir)), tokenize($oldId, '/')[8])"
                />
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of
                    select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', foo:changePart($org.file.dir), '/', tokenize($oldId, '/')[8])"
                />
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
                <xsl:variable name="leveringsId">
                    <xsl:choose>
                        <xsl:when test="$inclusiefAfbreek = 1">
                            <xsl:value-of select="concat(replace($oldPart, '\.', '_'), '-', 'AFBREEK', '-', $alreadyRetrievedDateTime)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(replace($oldPart, '\.', '_'), '-', $alreadyRetrievedDateTime)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:value-of select="$leveringsId"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="foo:replacePart">
        <xsl:param name="oldPart" as="xs:string"/>
        <xsl:param name="newPart" as="xs:string"/>
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
    
    <xsl:function name="foo:changeLastPart">
        <xsl:param name="lastPart" as="xs:string"/>
        <xsl:choose>
            <!-- Indien het id het woordje FOUT bevat, dient wordt het woordje fout toegevoegd, hij is immers om een fout te triggeren -->
            <xsl:when test="contains($lastPart, 'FOUT')">
                <xsl:value-of select="$lastPart"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="first" select="tokenize($lastPart, '@')[1]"/>
                <xsl:variable name="second" select="$dateAfterTomorrow"/>
                <xsl:variable name="third" select="tokenize(tokenize($lastPart, '@')[2], ';')[1]"/>
                <xsl:value-of select="concat($first, '@', $second, ';', $third)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>
    
    
    <xsl:function name="foo:replaceFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:variable name="newId" as="xs:string" select="foo:generateAKNFRBRWork($oldId)"/>
        <xsl:choose>
            <xsl:when test="count(tokenize($oldId, '/')) = 7">
                <xsl:value-of
                    select="
                    concat('/',
                    foo:replacePart(tokenize($oldId, '/')[2], tokenize($newId, '/')[2]), '/',
                    foo:replacePart(tokenize($oldId, '/')[3], tokenize($newId, '/')[3]), '/',
                    foo:replacePart(tokenize($oldId, '/')[4], tokenize($newId, '/')[4]), '/',
                    foo:replacePart(tokenize($oldId, '/')[5], tokenize($newId, '/')[5]), '/',
                    foo:replacePart(tokenize($oldId, '/')[6], tokenize($newId, '/')[6]), '/',
                    foo:replacePart(tokenize($oldId, '/')[7], concat(tokenize($newId, '/')[7],'_',$number))
                    )"
                />
            </xsl:when>
            <xsl:when test="count(tokenize($oldId, '/')) = 6">
                <xsl:value-of
                    select="
                    concat('/',
                    foo:replacePart(tokenize($oldId, '/')[2], tokenize($newId, '/')[2]), '/',
                    foo:replacePart(tokenize($oldId, '/')[3], tokenize($newId, '/')[3]), '/',
                    foo:replacePart(tokenize($oldId, '/')[4], tokenize($newId, '/')[4]), '/',
                    foo:replacePart(tokenize($oldId, '/')[5], tokenize($newId, '/')[5]), '/',
                    foo:replacePart(tokenize($oldId, '/')[6], concat(tokenize($newId, '/')[6],'_',$number))
                    )"
                />
            </xsl:when>
        </xsl:choose>
    </xsl:function>
    
    <xsl:function name="foo:replaceFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:variable name="newId" as="xs:string" select="foo:generateAKNFRBRExpression($oldId)"/>
        <xsl:choose>
            <xsl:when test="$inclusiefAfbreek = 1">
                <xsl:choose>
                    <xsl:when test="count(tokenize($oldId, '/')) = 8">
                        <xsl:value-of
                            select="
                            concat('/',
                            foo:replacePart(tokenize($oldId, '/')[2], tokenize($newId, '/')[2]), '/',
                            foo:replacePart(tokenize($oldId, '/')[3], tokenize($newId, '/')[3]), '/',
                            foo:replacePart(tokenize($oldId, '/')[4], tokenize($newId, '/')[4]), '/',
                            foo:replacePart(tokenize($oldId, '/')[5], tokenize($newId, '/')[5]), '/',
                            foo:replacePart(tokenize($oldId, '/')[6], tokenize($newId, '/')[6]), '/',
                            foo:replacePart(tokenize($oldId, '/')[7], concat(tokenize($newId, '/')[7],'_',$number)), '/',
                            foo:replacePart(tokenize($oldId, '/')[8], foo:changeLastPart(tokenize($oldId, '/')[8]))
                            )"
                        />
                    </xsl:when>
                    <xsl:when test="count(tokenize($oldId, '/')) = 7">
                        <xsl:value-of
                            select="
                            concat('/',
                            foo:replacePart(tokenize($oldId, '/')[2], tokenize($newId, '/')[2]), '/',
                            foo:replacePart(tokenize($oldId, '/')[3], tokenize($newId, '/')[3]), '/',
                            foo:replacePart(tokenize($oldId, '/')[4], tokenize($newId, '/')[4]), '/',
                            foo:replacePart(tokenize($oldId, '/')[5], tokenize($newId, '/')[5]), '/',
                            foo:replacePart(tokenize($oldId, '/')[6], concat(tokenize($newId, '/')[6],'_',$number)), '/',
                            foo:replacePart(tokenize($oldId, '/')[7], foo:changeLastPart(tokenize($oldId, '/')[7]))
                            )"
                        />
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <xsl:when test="count(tokenize($oldId, '/')) = 8">
                        <xsl:value-of
                            select="
                            concat('/',
                            foo:replacePart(tokenize($oldId, '/')[2], tokenize($newId, '/')[2]), '/',
                            foo:replacePart(tokenize($oldId, '/')[3], tokenize($newId, '/')[3]), '/',
                            foo:replacePart(tokenize($oldId, '/')[4], tokenize($newId, '/')[4]), '/',
                            foo:replacePart(tokenize($oldId, '/')[5], tokenize($newId, '/')[5]), '/',
                            foo:replacePart(tokenize($oldId, '/')[6], tokenize($newId, '/')[6]), '/',
                            foo:replacePart(tokenize($oldId, '/')[7], concat(tokenize($newId, '/')[7],'_',$number)), '/',
                            foo:replacePart(tokenize($oldId, '/')[8], tokenize($newId, '/')[8])
                            )"
                        />
                    </xsl:when>
                    <xsl:when test="count(tokenize($oldId, '/')) = 7">
                        <xsl:value-of
                            select="
                            concat('/',
                            foo:replacePart(tokenize($oldId, '/')[2], tokenize($newId, '/')[2]), '/',
                            foo:replacePart(tokenize($oldId, '/')[3], tokenize($newId, '/')[3]), '/',
                            foo:replacePart(tokenize($oldId, '/')[4], tokenize($newId, '/')[4]), '/',
                            foo:replacePart(tokenize($oldId, '/')[5], tokenize($newId, '/')[5]), '/',
                            foo:replacePart(tokenize($oldId, '/')[6], concat(tokenize($newId, '/')[6],'_',$number)), '/',
                            foo:replacePart(tokenize($oldId, '/')[7], tokenize($newId, '/')[7])
                            )"
                        />
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
