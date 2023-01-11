<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo= "http://www.w3.org/1999/XSL/Format"
    xmlns:mtg="https://vrba.dev/mtg"
    exclude-result-prefixes="mtg"
    version="3.0">
    
    <xsl:output method="xml"/>
    
    <xsl:param name="root">/</xsl:param>
    <xsl:param name="commit">dev</xsl:param>
    
    <xsl:template match="/">
        <fo:root>
            <fo:layout-master-set>
                <fo:simple-page-master master-name="first-page" page-height="297mm" page-width="210mm" margin="1.5in">
                    <fo:region-body />
                    <fo:region-after extent="10mm"/>
                </fo:simple-page-master>
                
                <fo:simple-page-master master-name="deck-page" page-height="297mm" page-width="210mm" margin="1in">
                    <fo:region-body margin-bottom="15mm"/>
                    <fo:region-after extent="10mm"/>
                </fo:simple-page-master>
            </fo:layout-master-set>
            <fo:page-sequence master-reference="first-page">
                <fo:static-content flow-name="xsl-region-after">
                    <fo:block font-size="10pt">
                        Version 
                        <fo:basic-link external-destination="https://gitlab.com/jirkavrba/semestralni-prace-4iz238/-/commit/{$commit}">
                            <fo:inline font-family="monospace" font-weight="bold"><xsl:value-of select="$commit"/></fo:inline>
                        </fo:basic-link>
                    </fo:block>
                </fo:static-content>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block font-size="24pt" font-weight="bold">Magic: The Gathering decks</fo:block>
                    <fo:block font-size="20pt" font-family="Noto Sans" font-weight="bold" space-before="6pt" space-after="4pt">Jiří Vrba</fo:block>
                    
                    <fo:block font-size="12pt" space-before="60pt" space-after="8pt" font-weight="bold">
                        This export contains <xsl:value-of select="count(/mtg:decks/deck)"/> decks
                    </fo:block>
                    
                    <xsl:for-each select="/mtg:decks/deck">
                        <fo:block font-size="14pt">
                            <fo:basic-link internal-destination="deck-{./@id}">
                                <fo:page-number-citation ref-id="deck-{./@id}"/>:
                                <fo:inline font-weight="bold">
                                    <xsl:value-of select="./name/text()"/>
                                </fo:inline>
                            </fo:basic-link>
                        </fo:block>
                    </xsl:for-each>
                </fo:flow>
            </fo:page-sequence>
            <xsl:for-each select="/mtg:decks/deck">
                <fo:page-sequence master-reference="deck-page">
                    <fo:title>
                        <xsl:value-of select="./name/text()"/>
                    </fo:title>
                    <fo:static-content flow-name="xsl-region-after">
                        <fo:block text-align="left">
                            Page <fo:page-number/>
                        </fo:block>
                    </fo:static-content>
                    <fo:flow flow-name="xsl-region-body" id="deck-{./@id}">
                        <fo:block text-align="left" space-before="20pt" space-after="14pt" font-family="sans-serif">
                            <fo:block font-size="24pt" font-weight="bold" space-before="6pt" space-after="4pt">
                                <xsl:value-of select="./name/text()"/>
                            </fo:block>
                            <fo:block font-size="12pt" font-weight="bold" space-before="4pt" space-after="4pt">
                                <xsl:value-of select="./format/text()"/>
                            </fo:block>
                        </fo:block>
                        <fo:table table-layout="fixed" width="100%">
                            <fo:table-column column-width="10%"/>
                            <fo:table-column column-width="80%"/>
                            <fo:table-column column-width="10%"/>
                            
                            <fo:table-header>
                                <fo:table-row>
                                    <fo:table-cell>
                                        <fo:block font-weight="bold">Count</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block font-weight="bold">Card</fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell>
                                        <fo:block font-weight="bold">Mana cost</fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-header>
                            
                            <fo:table-body>
                                <xsl:for-each select="./cards/card">
                                    <xsl:sort select="sum(./cost/*/text())"/>
                                    <fo:table-row>
                                        <fo:table-cell>
                                            <fo:block text-align="right" font-family="monospace">
                                                <xsl:value-of select="@count"/> x 
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block>
                                                <xsl:value-of select="name/text()"/>
                                            </fo:block>
                                        </fo:table-cell>
                                        <fo:table-cell>
                                            <fo:block font-family="sans-serif">
                                                <xsl:if test="sum(./cost/*/text()) = 0">
                                                    -
                                                </xsl:if>
                                                
                                                <xsl:if test="./cost/colorless/text() > 0">
                                                    <xsl:value-of select="./cost/colorless/text()" />
                                                </xsl:if>
                                                
                                                <xsl:variable name="green" select="./cost/green/text()"/>
                                                <fo:inline>
                                                    <xsl:for-each select="(//*)[position()&lt;=$green]">
                                                        <fo:external-graphic src="{$root}/img/g.png" content-height="scale-to-fit" height="12pt"  content-width="12pt" scaling="non-uniform"/>
                                                    </xsl:for-each>
                                                </fo:inline>
                                                
                                                <xsl:variable name="red" select="./cost/red/text()"/>
                                                <fo:inline>
                                                    <xsl:for-each select="(//*)[position()&lt;=$red]">
                                                        <fo:external-graphic src="{$root}/img/r.png" content-height="scale-to-fit" height="12pt"  content-width="12pt" scaling="non-uniform"/>
                                                    </xsl:for-each>
                                                </fo:inline>
                                                
                                                <xsl:variable name="blue" select="./cost/blue/text()"/>
                                                <xsl:for-each select="(//*)[position()&lt;=$blue]">
                                                    <fo:external-graphic src="{$root}/img/u.png" content-height="scale-to-fit" height="12pt"  content-width="12pt" scaling="non-uniform"/>
                                                </xsl:for-each>
                                                
                                                <xsl:variable name="black" select="./cost/black/text()"/>
                                                <xsl:for-each select="(//*)[position()&lt;=$black]">
                                                    <fo:external-graphic src="{$root}/img/b.png" content-height="scale-to-fit" height="12pt"  content-width="12pt" scaling="non-uniform"/>
                                                </xsl:for-each>
                                                
                                                <xsl:variable name="white" select="./cost/white/text()"/>
                                                <xsl:for-each select="(//*)[position()&lt;=$white]">
                                                    <fo:external-graphic src="{$root}/img/w.png" content-height="scale-to-fit" height="12pt"  content-width="12pt" scaling="non-uniform"/>
                                                </xsl:for-each>
                                            </fo:block>
                                        </fo:table-cell>
                                    </fo:table-row>
                                </xsl:for-each>
                            </fo:table-body>
                        </fo:table>
                    </fo:flow>
                </fo:page-sequence>
            </xsl:for-each>
        </fo:root>
    </xsl:template>
    
</xsl:stylesheet>