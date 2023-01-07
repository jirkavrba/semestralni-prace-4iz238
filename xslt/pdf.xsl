<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo= "http://www.w3.org/1999/XSL/Format"
    xmlns:mtg="https://vrba.dev/mtg"
    exclude-result-prefixes="mtg"
    version="3.0">
    
    <xsl:output method="xml"/>
    
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="default-page" page-height="297mm" page-width="210mm" margin="1in">
                    <fo:region-body margin-bottom="15mm"/>
                    <fo:region-after extent="10mm"/>my
                </fo:simple-page-master>
            </fo:layout-master-set>
            <xsl:for-each select="/mtg:decks/deck">
                <fo:page-sequence master-reference="default-page">
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block>
                            <xsl:text>Page </xsl:text>
                            <fo:page-number/>
                        </fo:block>
                    </fo:static-content>
                    <fo:flow flow-name="xsl-region-body">
                        <fo:block text-align="left" space-before="20pt" space-after="14pt" font-family="Helvetica">
                            <fo:block font-size="12pt" font-weight="bold">Magic: The Gathering decks</fo:block>
                            <fo:block font-size="24pt" font-weight="bold" space-before="6pt" space-after="4pt">
                                <xsl:value-of select="./name/text()"/>
                            </fo:block>
                            <fo:block font-size="12pt" font-weight="bold" space-before="4pt" space-after="4pt">
                                <xsl:value-of select="./format/text()"/>
                            </fo:block>
                        </fo:block>
                    </fo:flow>
                </fo:page-sequence>
            </xsl:for-each>
        </fo:root>
    </xsl:template>
    
</xsl:stylesheet>