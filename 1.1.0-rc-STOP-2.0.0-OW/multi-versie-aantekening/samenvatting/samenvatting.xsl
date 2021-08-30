<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:data="https://standaarden.overheid.nl/stop/imop/data/"
    xmlns:aanlevering="https://standaarden.overheid.nl/lvbb/stop/aanlevering/" xmlns:tekst="https://standaarden.overheid.nl/stop/imop/tekst/" exclude-result-prefixes="xs" version="2.0">

    <xsl:output method="xml"/>


    <xsl:template match="/">
<!--        <xsl:variable name="fileUrl" select="'samenvatting.xml'"/>
        <xsl:message select="$fileUrl"/>
        <xsl:result-document href="{$fileUrl}" method="xml" indent="yes">
-->            <xsl:call-template name="samenvatting"/>
        <!--</xsl:result-document>-->
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
                    <xsl:element name="io-construct">
                        <xsl:if test="count(data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef) > 0">
                            <xsl:element name="io-construct">
                                <xsl:value-of select="data:BesluitMetadata/data:informatieobjectRefs/data:informatieobjectRef[1]/text()"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:element>
                    <xsl:element name="Besluit">
                        <xsl:for-each select="//tekst:BesluitCompact/tekst:Lichaam">
                            <xsl:for-each select="tekst:WijzigArtikel">
                                <xsl:element name="WijzigArtikel">
                                    <xsl:call-template name="eIdwId">
                                        <xsl:with-param name="current" select="."/>
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:for-each>
                            <xsl:for-each select="tekst:Artikel">
                                <xsl:element name="Artikel">
                                    <xsl:call-template name="eIdwId">
                                        <xsl:with-param name="current" select="."/>
                                    </xsl:call-template>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:for-each>
                        <xsl:element name="BesluitCompact">
                            <xsl:for-each select="//tekst:BesluitCompact/tekst:WijzigBijlage">
                                <xsl:if test="tekst:RegelingCompact">
                                    <xsl:element name="RegelingCompact">
                                        <xsl:if test="//@wordt">
                                            <xsl:element name="wordt">
                                                <xsl:value-of select="//@wordt"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="//@was">
                                            <xsl:element name="was">
                                                <xsl:value-of select="//@was"/>
                                            </xsl:element>
                                        </xsl:if>

                                        <xsl:call-template name="Lichaam">
                                            <xsl:with-param name="current" select="tekst:RegelingCompact/tekst:Lichaam"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:if>
                                <xsl:if test="tekst:RegelingMutatie">
                                    <xsl:element name="RegelingMutatie">
                                        <xsl:if test="//@wordt">
                                            <xsl:element name="wordt">
                                                <xsl:value-of select="//@wordt"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:if test="//@was">
                                            <xsl:element name="was">
                                                <xsl:value-of select="//@was"/>
                                            </xsl:element>
                                        </xsl:if>
                                        <xsl:call-template name="RegelingMutatie">
                                            <xsl:with-param name="current" select="tekst:RegelingMutatie"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:if>
                            </xsl:for-each>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:for-each>
            <xsl:for-each select="//aanlevering:AanleveringBesluit/aanlevering:RegelingVersieInformatie">
                <xsl:element name="RegelingVersie">
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
                    <xsl:if test="data:RegelingVersieMetadata/data:versienummer">
                        <xsl:element name="versie">
                            <xsl:value-of select="data:RegelingVersieMetadata/data:versienummer/text()"/>
                        </xsl:element>
                    </xsl:if>
                    <xsl:for-each select="data:RegelingMetadata/data:opvolging">
                        <xsl:if test="data:opvolgerVan">
                            <xsl:element name="opvolgerVan">
                                <xsl:value-of select="data:opvolgerVan/text()"/>
                            </xsl:element>
                        </xsl:if>
                    </xsl:for-each>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="RegelingMutatie">
        <xsl:param name="current" as="node()"/>
        <xsl:call-template name="eIdwId">
            <xsl:with-param name="current" select="$current"/>
        </xsl:call-template>
        <xsl:for-each select="$current/tekst:VoegToe">
            <xsl:call-template name="VoegToe">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:Vervang">
            <xsl:call-template name="Vervang">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:VervangKop">
            <xsl:call-template name="VervangKop">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:Verwijder">
            <xsl:call-template name="Verwijder">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="VoegToe">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="VoegToe">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Lichaam">
                <xsl:call-template name="Lichaam">
                    <xsl:with-param name="current" select="$current"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Boek">
                <xsl:call-template name="Boek">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Deel">
                <xsl:call-template name="Deel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Hoofdstuk">
                <xsl:call-template name="Hoofdstuk">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Paragraaf">
                <xsl:call-template name="Paragraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Afdeling">
                <xsl:call-template name="Afdeling">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$current/tekst:Titel">
                <xsl:call-template name="Titel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Vervang">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Vervang">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Lichaam">
                <xsl:call-template name="Lichaam">
                    <xsl:with-param name="current" select="$current"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Boek">
                <xsl:call-template name="Boek">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Deel">
                <xsl:call-template name="Deel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Hoofdstuk">
                <xsl:call-template name="Hoofdstuk">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Paragraaf">
                <xsl:call-template name="Paragraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Afdeling">
                <xsl:call-template name="Afdeling">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$current/tekst:Titel">
                <xsl:call-template name="Titel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="VervangKop">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="VervangKop">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Verwijder">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Verwijder">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Lichaam">
                <xsl:call-template name="Lichaam">
                    <xsl:with-param name="current" select="$current"/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Boek">
                <xsl:call-template name="Boek">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Deel">
                <xsl:call-template name="Deel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Hoofdstuk">
                <xsl:call-template name="Hoofdstuk">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Paragraaf">
                <xsl:call-template name="Paragraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Afdeling">
                <xsl:call-template name="Afdeling">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$current/tekst:Titel">
                <xsl:call-template name="Titel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Lichaam">
        <xsl:param name="current" as="node()"/>
        <xsl:call-template name="eIdwId">
            <xsl:with-param name="current" select="$current"/>
        </xsl:call-template>
        <xsl:for-each select="$current/tekst:Boek">
            <xsl:call-template name="Boek">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:Deel">
            <xsl:call-template name="Deel">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:Hoofdstuk">
            <xsl:call-template name="Hoofdstuk">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:Paragraaf">
            <xsl:call-template name="Paragraaf">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:Afdeling">
            <xsl:call-template name="Afdeling">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:if test="$current/tekst:Titel">
            <xsl:call-template name="Titel">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:if>
        <xsl:for-each select="$current/tekst:WijzigArtikel">
            <xsl:call-template name="WijzigArtikel">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
        <xsl:for-each select="$current/tekst:Artikel">
            <xsl:call-template name="Artikel">
                <xsl:with-param name="current" select="."/>
            </xsl:call-template>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="Boek">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Boek">
            <xsl:if test="$current/tekst:Kop/tekst:Nummer">
                <xsl:attribute name="Nummer" select="$current/tekst:Kop/tekst:Nummer"/>
            </xsl:if>
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Deel">
                <xsl:call-template name="Deel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Hoofdstuk">
                <xsl:call-template name="Hoofdstuk">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Paragraaf">
                <xsl:call-template name="Paragraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Afdeling">
                <xsl:call-template name="Afdeling">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$current/tekst:Titel">
                <xsl:call-template name="Titel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Redactioneel">
                <xsl:call-template name="Redactioneel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Deel">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Deel">
            <xsl:if test="$current/tekst:Kop/tekst:Nummer">
                <xsl:attribute name="Nummer" select="$current/tekst:Kop/tekst:Nummer"/>
            </xsl:if>
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Boek">
                <xsl:call-template name="Deel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Hoofdstuk">
                <xsl:call-template name="Hoofdstuk">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Paragraaf">
                <xsl:call-template name="Paragraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Afdeling">
                <xsl:call-template name="Afdeling">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$current/tekst:Titel">
                <xsl:call-template name="Titel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Redactioneel">
                <xsl:call-template name="Redactioneel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Hoofdstuk">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Hoofdstuk">
            <xsl:if test="$current/tekst:Kop/tekst:Nummer">
                <xsl:attribute name="Nummer" select="$current/tekst:Kop/tekst:Nummer"/>
            </xsl:if>
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Boek">
                <xsl:call-template name="Deel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Deel">
                <xsl:call-template name="Hoofdstuk">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Paragraaf">
                <xsl:call-template name="Paragraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Afdeling">
                <xsl:call-template name="Afdeling">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$current/tekst:Titel">
                <xsl:call-template name="Titel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Redactioneel">
                <xsl:call-template name="Redactioneel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Paragraaf">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Paragraaf">
            <xsl:if test="$current/tekst:Kop/tekst:Nummer">
                <xsl:attribute name="Nummer" select="$current/tekst:Kop/tekst:Nummer"/>
            </xsl:if>
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Subparagraaf">
                <xsl:call-template name="Subparagraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Redactioneel">
                <xsl:call-template name="Redactioneel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Subparagraaf">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Subparagraaf">
            <xsl:if test="$current/tekst:Kop/tekst:Nummer">
                <xsl:attribute name="Nummer" select="$current/tekst:Kop/tekst:Nummer"/>
            </xsl:if>
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Subparagraaf">
                <xsl:call-template name="Subparagraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Redactioneel">
                <xsl:call-template name="Redactioneel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Afdeling">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Afdeling">
            <xsl:if test="$current/tekst:Kop/tekst:Nummer">
                <xsl:attribute name="Nummer" select="$current/tekst:Kop/tekst:Nummer"/>
            </xsl:if>
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Boek">
                <xsl:call-template name="Deel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Deel">
                <xsl:call-template name="Hoofdstuk">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Paragraaf">
                <xsl:call-template name="Paragraaf">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Hoofdstuk">
                <xsl:call-template name="Afdeling">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:if test="$current/tekst:Titel">
                <xsl:call-template name="Titel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:if>
            <xsl:for-each select="$current/tekst:WijzigArtikel">
                <xsl:call-template name="WijzigArtikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Artikel">
                <xsl:call-template name="Artikel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
            <xsl:for-each select="$current/tekst:Redactioneel">
                <xsl:call-template name="Redactioneel">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Titel">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Titel">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="WijzigArtikel">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="WijzigArtikel">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Wijziglid">
                <xsl:call-template name="Wijziglid">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Artikel">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Artikel">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
            <xsl:for-each select="$current/tekst:Lid">
                <xsl:call-template name="Lid">
                    <xsl:with-param name="current" select="."/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Wijziglid">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Wijziglid">
            <xsl:attribute name="LidNummer" select="$current/tekst:LidNummer"/>
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Lid">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Lid">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="Redactioneel">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Redactioneel">
            <xsl:call-template name="eIdwId">
                <xsl:with-param name="current" select="$current"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="eIdwId">
        <xsl:param name="current" as="node()"/>
        <xsl:element name="Kop">
            <xsl:if test="$current/@eId">
                <xsl:attribute name="eId" select="$current/@eId"/>
            </xsl:if>
            <xsl:if test="$current/@wId">
                <xsl:attribute name="wId" select="$current/@wId"/>
            </xsl:if>
            <xsl:if test="$current/@positie">
                <xsl:attribute name="positie" select="$current/@positie"/>
            </xsl:if>
            <xsl:if test="$current/@context">
                <xsl:attribute name="context" select="$current/@context"/>
            </xsl:if>
            <xsl:if test="$current/tekst:Kop/tekst:Nummer/tekst:VerwijderdeTekst">
                <xsl:attribute name="VerwijderdeTekst" select="$current/tekst:Kop/tekst:Nummer/tekst:VerwijderdeTekst/text()"/>
            </xsl:if>
            <xsl:if test="$current/tekst:Kop/tekst:Nummer/tekst:NieuweTekst">
                <xsl:attribute name="NieuweTekst" select="$current/tekst:Kop/tekst:Nummer/tekst:NieuweTekst/text()"/>
            </xsl:if>
            <xsl:if test="$current/tekst:Kop/tekst:Nummer and not($current/tekst:Kop/tekst:Nummer/tekst:VerwijderdeTekst or $current/tekst:Kop/tekst:Nummer/tekst:NieuweTekst)">
                <xsl:attribute name="Nummer" select="$current/tekst:Kop/tekst:Nummer/text()"/>
            </xsl:if>
            <xsl:if test="$current/tekst:LidNummer/tekst:VerwijderdeTekst">
                <xsl:attribute name="VerwijderdeTekst" select="$current/tekst:LidNummer/tekst:VerwijderdeTekst/text()"/>
            </xsl:if>
            <xsl:if test="$current/tekst:LidNummer/tekst:NieuweTekst">
                <xsl:attribute name="NieuweTekst" select="$current/tekst:LidNummer/tekst:NieuweTekst/text()"/>
            </xsl:if>
            <xsl:if test="$current/tekst:LidNummer and not($current/tekst:LidNummer/tekst:VerwijderdeTekst or $current/tekst:LidNummer/tekst:NieuweTekst)">
                <xsl:attribute name="Nummer" select="$current/tekst:LidNummer/text()"/>
            </xsl:if>
        </xsl:element>
    </xsl:template>





</xsl:stylesheet>
