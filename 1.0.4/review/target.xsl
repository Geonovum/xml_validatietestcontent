<?xml version="1.0" encoding="utf-8"?>
<?mso-application progid="Excel.Sheet"?>
<xsl:stylesheet version="1.0"
    xmlns:html="http://www.w3.org/TR/REC-html40"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns="urn:schemas-microsoft-com:office:spreadsheet"
    xmlns:o="urn:schemas-microsoft-com:office:office"
    xmlns:x="urn:schemas-microsoft-com:office:excel"
    xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet">
    
    <xsl:template match="/">
        
        <Workbook>
            <Styles>
                <Style ss:ID="Default" ss:Name="Normal">
                    <Alignment ss:Vertical="Bottom" />
                        <Borders />
                        <Font />
                        <Interior />
                        <NumberFormat />
                        <Protection />
                </Style>
                <Style ss:ID="s21">
                    <Font ss:Size="22" ss:Bold="1" />
                </Style>
                <Style ss:ID="s22">
                    <Font ss:Size="14" ss:Bold="1" />
                </Style>
                <Style ss:ID="s23">
                    <Font ss:Size="12" ss:Bold="1" />
                </Style>
                <Style ss:ID="s24">
                    <Font ss:Size="10" ss:Bold="1" />
                </Style>
            </Styles>
            
            <Worksheet ss:Name="Page1">
                <Table>
                    <xsl:call-template name="XMLToXSL" />
                </Table>
            </Worksheet>
        </Workbook>
        
    </xsl:template>
    
    <xsl:template name="XMLToXSL">
        
        <Row>
            <Cell>
                <Data ss:Type="String">Name</Data>
            </Cell>
            <Cell>
                <Data ss:Type="String">Age</Data>
            </Cell>
        </Row>
        <xsl:for-each
            select="//RECORD">
            
            <Row>
                <Cell>
                    <Data ss:Type="String">
                        <xsl:value-of select="NAME" />
                    </Data>
                </Cell>
                <Cell>
                    <Data ss:Type="String">
                        <xsl:value-of select="AGE" />
                    </Data>
                </Cell>
            </Row>
        </xsl:for-each>
    </xsl:template>
    <xsl:template match="MT_TEST_IN">
    </xsl:template>
</xsl:stylesheet>