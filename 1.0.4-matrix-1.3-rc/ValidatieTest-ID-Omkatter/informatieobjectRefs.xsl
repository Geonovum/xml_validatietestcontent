<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0"
    xmlns:ow-dc="http://www.geostandaarden.nl/imow/bestanden/deelbestand" xmlns:ow="http://www.geostandaarden.nl/imow/owobject"
    xmlns:sl="http://www.geostandaarden.nl/bestanden-ow/standlevering-generiek" xmlns:ga="http://www.geostandaarden.nl/imow/gebiedsaanwijzing" xmlns:k="http://www.geostandaarden.nl/imow/kaart"
    xmlns:l="http://www.geostandaarden.nl/imow/locatie" xmlns:p="http://www.geostandaarden.nl/imow/pons" xmlns:r="http://www.geostandaarden.nl/imow/regels"
    xmlns:rg="http://www.geostandaarden.nl/imow/regelingsgebied" xmlns:rol="http://www.geostandaarden.nl/imow/regelsoplocatie" xmlns:vt="http://www.geostandaarden.nl/imow/vrijetekst"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:geo="https://standaarden.overheid.nl/stop/imop/geo/" xmlns:gml="http://www.opengis.net/gml/3.2"
    xmlns:basisgeo="http://www.geostandaarden.nl/basisgeometrie/1.0" xmlns:lvbb="http://www.overheid.nl/2017/lvbb" xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/"
    xmlns:data="https://standaarden.overheid.nl/stop/imop/data/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/"
    xmlns:manifest-ow="http://www.geostandaarden.nl/bestanden-ow/manifest-ow" xmlns:gio="https://standaarden.overheid.nl/stop/imop/gio/" xmlns:foo="http://whatever">
    <xsl:output method="xml" version="1.0" indent="yes" encoding="utf-8"/>

    <xsl:param name="alreadyRetrievedDateTime"/>
    <!-- The orgfiledir bevat het test-validatie-bestand dat wordt aangeboden. Bijvoorbeeld LVBB1013 -->
    <xsl:param name="org.file.dir"/>
    <xsl:param name="inclusiefAfbreek"/>
    <xsl:param name="oldIoRefId"/>
    <xsl:param name="oldIoWorkId"/>

    <xsl:variable name="dateAfterTomorrow" select="format-dateTime(current-dateTime() + xs:dayTimeDuration('P3D'), '[Y0001]-[M01]-[D01]')"/>


    <xsl:template match="@* | node()">
        <xsl:copy>
            <xsl:apply-templates select="@* | node()"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="tekst:ExtIoRef[text() = $oldIoRefId]">
        <xsl:element name="tekst:ExtIoRef">
            <xsl:attribute name="wId">
                <xsl:value-of select="@wId"/>
            </xsl:attribute>
            <xsl:attribute name="eId">
                <xsl:value-of select="@eId"/>
            </xsl:attribute>
            <xsl:attribute name="ref">
                <xsl:value-of select="foo:replaceFRBRExpression(text())"/>
            </xsl:attribute>
            <xsl:value-of select="foo:replaceFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="data:BeoogdInformatieobject/data:instrumentVersie[text() = $oldIoRefId]">
        <xsl:element name="data:instrumentVersie">
            <xsl:value-of select="foo:replaceFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="data:informatieobjectRefs/data:informatieobjectRef[text() = $oldIoRefId]">
        <xsl:element name="data:informatieobjectRef">
            <xsl:value-of select="foo:replaceFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="geo:FRBRExpression[text() = $oldIoRefId]">
        <xsl:element name="geo:FRBRExpression">
            <xsl:value-of select="foo:replaceFRBRExpression(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="aanlevering:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRExpression">
        <xsl:if test="not(contains(text(), $oldIoRefId))">
            <xsl:element name="data:FRBRExpression">
                <xsl:value-of select="foo:replaceFRBRExpression(text())"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="aanlevering:InformatieObjectVersie/data:ExpressionIdentificatie/data:FRBRWork">
        <xsl:if test="not(contains(text(), $oldIoWorkId))">
            <xsl:element name="data:FRBRWork">
                <xsl:value-of select="foo:replaceFRBRWork(text())"/>
            </xsl:element>
        </xsl:if>
    </xsl:template>

    <xsl:template match="data:InformatieObjectMetadata/data:officieleTitel[text() = $oldIoWorkId]">
        <xsl:element name="data:officieleTitel">
            <xsl:value-of select="foo:replaceFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="geo:FRBRWork[text() = $oldIoWorkId]">
        <xsl:element name="geo:FRBRWork">
            <xsl:value-of select="foo:replaceFRBRWork(text())"/>
        </xsl:element>
    </xsl:template>

    <xsl:function name="foo:generateFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:value-of
            select="concat('/', tokenize($oldId, '/')[2], '/', tokenize($oldId, '/')[3], '/', tokenize($oldId, '/')[4], '/', tokenize($oldId, '/')[5], '/', tokenize($oldId, '/')[6], '/', concat(tokenize($oldId, '/')[7], '-', foo:changePart($org.file.dir)))"
        />
    </xsl:function>

    <xsl:function name="foo:generateFRBRExpression">
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
                <xsl:variable name="third" select="tokenize(tokenize($lastPart, '@')[2], ';')[2]"/>
                <xsl:value-of select="concat($first, '@', $second, ';', $third)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>


    <xsl:function name="foo:replaceFRBRWork">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:variable name="newId" as="xs:string" select="foo:generateFRBRWork($oldId)"/>
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
                        foo:replacePart(tokenize($oldId, '/')[7], tokenize($newId, '/')[7])
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
                        foo:replacePart(tokenize($oldId, '/')[6], tokenize($newId, '/')[6])
                        )"
                />
            </xsl:when>
        </xsl:choose>
    </xsl:function>

    <xsl:function name="foo:replaceFRBRExpression">
        <xsl:param name="oldId" as="xs:string"/>
        <xsl:variable name="newId" as="xs:string" select="foo:generateFRBRExpression($oldId)"/>
        <xsl:choose>
            <xsl:when test="$inclusiefAfbreek = '1'">
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
                                foo:replacePart(tokenize($oldId, '/')[7], tokenize($newId, '/')[7]), '/',
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
                                foo:replacePart(tokenize($oldId, '/')[6], tokenize($newId, '/')[6]), '/',
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
                                foo:replacePart(tokenize($oldId, '/')[7], tokenize($newId, '/')[7]), '/',
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
                                foo:replacePart(tokenize($oldId, '/')[6], tokenize($newId, '/')[6]), '/',
                                foo:replacePart(tokenize($oldId, '/')[7], tokenize($newId, '/')[7])
                                )"
                        />
                    </xsl:when>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:function>

</xsl:stylesheet>
