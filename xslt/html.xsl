<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mtg="https://vrba.dev/mtg"
    exclude-result-prefixes="mtg"
    version="3.0">
    
    <xsl:output method="html" version="5" indent="true"/>
    <xsl:output method="html" version="5" indent="true" name="html5" />
    
    <xsl:template match="/" mode="#default">
        <html lang="en">
            <head>
                <title>Magic: The Gathering decks</title>
                <meta name="og:title" content="Magic: The Gathering decks" />
                <meta name="og:description" value="This page contains {count(/mtg:decks/deck)} decks"/>
                <link rel="stylesheet" href="./css/style.css"/>
            </head>
            <body>
                <xsl:for-each select="/mtg:decks/deck">
                    <a class="deck deck--{lower-case(./colors/color/text())}" href="./deck-{position()}.html">
                        <div class="deck-header">
                            <div class="deck-info">
                                <h1 class="deck-name">
                                    <xsl:value-of select="./name"/>
                                </h1>
                                <h2 class="deck-format colored-text">
                                    <xsl:value-of select="./format/text()"/>
                                </h2>
                            </div>
                            <div class="deck-colors">
                                <xsl:for-each select="./colors/color">
                                    <div class="mana mana--large mana--{lower-case(text())}"></div>
                                </xsl:for-each>
                            </div>
                        </div>
                        
                        <div class="deck-rarity">
                            <div class="deck-rarity--common" title="Common"><xsl:value-of select="sum(./cards/card[rarity/text() = 'Common']/@count)"/></div>
                            <div class="deck-rarity--uncommon" title="Uncommon"><xsl:value-of select="sum(./cards/card[rarity/text() = 'Uncommon']/@count)"/></div>
                            <div class="deck-rarity--rare" title="Rare"><xsl:value-of select="sum(./cards/card[rarity/text() = 'Rare']/@count)"/></div>
                            <div class="deck-rarity--mythic" title="Mythic"><xsl:value-of select="sum(./cards/card[rarity/text() = 'Mythic']/@count)"/></div>
                        </div>
                        <div class="deck-cards">
                            <xsl:for-each select="./cards/card">
                                <xsl:sort select="sum(./cost/*/text())"/>
                                <div class="deck-card">
                                    <div class="card-top">
                                        <div class="card-name">
                                            <span class="card-count colored-text">
                                                <xsl:value-of select="[@count]"/>x 
                                            </span>
                                            <xsl:value-of select="./name/text()"/>
                                            
                                        </div>
                                        <div class="card-cost">
                                            <xsl:if test="./cost/colorless/text() > 0">
                                                <div class="mana mana--colorless">
                                                    <xsl:value-of select="./cost/colorless/text()"/>
                                                </div>
                                            </xsl:if>
                                            
                                            <xsl:variable name="count" select="./cost/green/text()"/>
                                            <xsl:for-each select="(//*)[position()&lt;=$count]">
                                                <div class="mana mana--green"/>
                                            </xsl:for-each>
                                            
                                            <xsl:variable name="count" select="./cost/red/text()"/>
                                            <xsl:for-each select="(//*)[position()&lt;=$count]">
                                                <div class="mana mana--red"/>
                                            </xsl:for-each>
                                            
                                            <xsl:variable name="count" select="./cost/blue/text()"/>
                                            <xsl:for-each select="(//*)[position()&lt;=$count]">
                                                <div class="mana mana--blue"/>
                                            </xsl:for-each>
                                            
                                            <xsl:variable name="count" select="./cost/black/text()"/>
                                            <xsl:for-each select="(//*)[position()&lt;=$count]">
                                                <div class="mana mana--black"/>
                                            </xsl:for-each>
                                            
                                            <xsl:variable name="count" select="./cost/white/text()"/>
                                            <xsl:for-each select="(//*)[position()&lt;=$count]">
                                                <div class="mana mana--white"/>
                                            </xsl:for-each>
                                        </div>
                                    </div>
                                    <div class="card-details">
                                        <div class="card-information">
                                            <div class="card-subtype">
                                                <xsl:value-of select="./type/text()"/>
                                                <xsl:if test="./subtype/text()">
                                                    -    
                                                    <xsl:value-of select="./subtype/text()"/>
                                                </xsl:if>
                                            </div>
                                            <p class="card-text">
                                                <xsl:value-of select="./text/text()"/>
                                            </p>
                                            <xsl:if test="contains(./type/text(), 'Creature')">
                                                <div class="card-creature">
                                                    <xsl:value-of select="./power/text()"/> 
                                                    /
                                                    <xsl:value-of select="./toughness/text()"/>
                                                </div>
                                            </xsl:if>
                                        </div>
                                        <img class="card-image" src="{./images/art/text()}" alt="{./name/text()} image" title="{./artist/text()}"/>
                                    </div>
                                </div> 
                            </xsl:for-each>
                        </div>
                    </a>

                    <xsl:result-document href="deck-{position()}.html">
                        <html leng="en">
                            <body>
                                <xsl:value-of select="./name/text()"/>
                            </body>
                        </html> 
                    </xsl:result-document>
                </xsl:for-each> 
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>