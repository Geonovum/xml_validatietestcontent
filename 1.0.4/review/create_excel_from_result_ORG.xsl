<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:output omit-xml-declaration="no"/>
    <xsl:output method="xml"></xsl:output>
    
    <xsl:template match="/">
        
    </xsl:template>
    
    <xsl:template match="/">
        <xsl:processing-instruction name="mso-application">progid="Excel.Sheet"</xsl:processing-instruction>
        <Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet" xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
            <Styles>
                <Style ss:ID="header" ss:Name="Normal">
                    <Font ss:FontName="Verdana" ss:Bold="1" />
                </Style>
            </Styles>
            <Worksheet ss:Name="Identificacao">
                <Table>
                    <Row ss:Index="1">
                        <Cell ss:Index="1" ss:StyleID="header">
                            <Data ss:Type="String">Nome</Data>
                        </Cell>
                        <Cell ss:Index="2" ss:StyleID="header">
                            <Data ss:Type="String">Nº Sine</Data>
                        </Cell>
                        <Cell ss:Index="3" ss:StyleID="header">
                            <Data ss:Type="String">Nº Contribuinte</Data>
                        </Cell>
                        <Cell ss:Index="4" ss:StyleID="header">
                            <Data ss:Type="String">Distrito</Data>
                        </Cell>
                        <Cell ss:Index="5" ss:StyleID="header">
                            <Data ss:Type="String">Concelho</Data>
                        </Cell>
                        <Cell ss:Index="6" ss:StyleID="header">
                            <Data ss:Type="String">Código Postal</Data>
                        </Cell>
                        <Cell ss:Index="7" ss:StyleID="header">
                            <Data ss:Type="String">Morada</Data>
                        </Cell>
                        <Cell ss:Index="8" ss:StyleID="header">
                            <Data ss:Type="String">Telefone</Data>
                        </Cell>
                        <Cell ss:Index="9" ss:StyleID="header">
                            <Data ss:Type="String">Email</Data>
                        </Cell>
                        <Cell ss:Index="10" ss:StyleID="header">
                            <Data ss:Type="String">Fax</Data>
                        </Cell>
                        <Cell ss:Index="11" ss:StyleID="header">
                            <Data ss:Type="String">Pais</Data>
                        </Cell>
                    </Row>
                    <Row ss:Index="{position()+1}">
                        <Cell ss:Index="1">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/Nome"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="2">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/NumeroSine"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="3">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/NumeroContribuinte"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="4">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/Distrito"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="5">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/Concelho"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="6">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/CodCP"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="7">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/Morada"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="8">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/Telefone1"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="9">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/Email"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="10">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/Fax1"/>
                            </Data>
                        </Cell>
                        <Cell ss:Index="11">
                            <Data ss:Type="String">
                                <xsl:value-of select="//VALUES/ROW/pais"/>
                            </Data>
                        </Cell>
                    </Row>
                </Table>
            </Worksheet>
        </Workbook>
    </xsl:template>
</xsl:stylesheet>