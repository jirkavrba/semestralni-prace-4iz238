<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:mtg="https://vrba.dev/mtg"
    exclude-result-prefixes="mtg"
    version="3.0">
    
    <xsl:output method="html" version="5" indent="true"/>
    <xsl:output method="html" version="5" indent="true" name="html5" />
    
    <xsl:param name="commit">dev</xsl:param>
    
    <xsl:template match="/" mode="#default">
        <html lang="en">
            <head>
                <title>Magic: The Gathering decks</title>
                <meta name="og:title" content="Magic: The Gathering decks" />
                <meta name="og:description" content="This page contains {count(/mtg:decks/deck)} decks"/>
                <link rel="stylesheet" href="./css/style.css"/>
            </head>
            <body>
                <a class="back-button" href="./decks.pdf?v={$commit}">PDF Export</a>
                
                <main class="decks">
                    <xsl:for-each select="/mtg:decks/deck">
                        <xsl:apply-templates select="." mode="link"/>
                        <xsl:apply-templates select="." mode="page"/>
                    </xsl:for-each> 
                </main>
                
                <a class="version-link" href="https://gitlab.com/jirkavrba/semestralni-prace-4iz238/-/commit/{$commit}" target="_blank">Version <xsl:value-of select="$commit"/></a>
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="/mtg:decks/deck" mode="link">
        <xsl:variable name="color" select="if (count(./colors/color) > 1) then 'deck--multicolor' else concat('deck--', lower-case(./colors/color[1]/text()))" /> 
        <a class="deck {$color}" href="./deck-{./@id}.html">
            <div class="deck-header">
                <div class="deck-info">
                    <h1 class="deck-name">
                        <xsl:value-of select="./name/text()"/>
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
                <xsl:for-each-group select="./cards/card" group-by="rarity/text()">
                    <xsl:sort select="index-of(('Common', 'Uncommon', 'Rare', 'Mythic'), current-grouping-key()) "/>
                    
                    <div class="deck-rarity--{lower-case(current-grouping-key())}" title="{current-grouping-key()}">
                        <xsl:value-of select="sum(current-group()/@count)"/>
                    </div>
                </xsl:for-each-group>
            </div>
        </a>
    </xsl:template>
    
    <xsl:template match="/mtg:decks/deck" mode="page">
        <xsl:variable name="color" select="if (count(./colors/color) > 1) then 'deck--multicolor' else concat('deck--', lower-case(./colors/color[1]/text()))" /> 
        <xsl:result-document href="deck-{./@id}.html">
            <xsl:variable name="cards" select="sum(./cards/card/@count)"/>
            <html lang="en">
                <head>
                    <title><xsl:value-of select="./name/text()"/> | Magic: The Gathering decks</title>
                    <meta name="description" content="This deck contains {$cards} cards"/>
                    <meta name="og:title" content="{./name/text()} | Magic: The Gathering decks" />
                    <meta name="og:description" content="This deck contains {$cards} cards"/>
                    <link rel="stylesheet" href="./css/style.css"/>
                </head>
                <body>
                    <a class="back-button" href="./index.html">Return back to the decks listings</a>
                    
                    <main class="deck-page">
                        <div class="deck deck--large {$color}">
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
                                <xsl:for-each-group select="./cards/card" group-by="rarity/text()">
                                    <xsl:sort select="index-of(('Common', 'Uncommon', 'Rare', 'Mythic'), current-grouping-key()) "/>
                                    
                                    <div class="deck-rarity--{lower-case(current-grouping-key())}" title="{current-grouping-key()}">
                                        <xsl:value-of select="concat(sum(current-group()/@count), '× ')"/> 
                                        <xsl:value-of select="lower-case(current-grouping-key())"/>
                                    </div>
                                </xsl:for-each-group>
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
                        </div>
                        <aside class="deck-stats">
                            <xsl:variable name="total" select="sum(./stats/game/(wins|loses)/text())"/>
                            <xsl:variable name="wins" select="./stats/game/wins/text()"/>
                            <xsl:variable name="loses" select="./stats/game/loses/text()"/>
                            
                            <div class="deck-stat-title">Games played</div>
                            <div class="deck-stat">
                                <div class="deck-metric">
                                    <div class="deck-metric-title">Total</div>
                                    <div class="deck-metric-value">
                                        <xsl:value-of select="$total"/>
                                    </div>
                                </div>
                                
                                <div class="deck-metric">
                                    <div class="deck-metric-title">Wins</div>
                                    <div class="deck-metric-value">
                                        <xsl:value-of select="$wins"/>
                                    </div>
                                </div>
                                
                                <div class="deck-metric">
                                    <div class="deck-metric-title">Loses</div>
                                    <div class="deck-metric-value">
                                        <xsl:value-of select="$loses"/>
                                    </div>
                                </div>
                            </div>
                            
                            <div class="deck-stat">
                                <div class="progress-bar">
                                    <xsl:variable name="winrate" select="round(($wins div $total) * 100)"/>
                                    <xsl:variable name="loserate" select="round(100 - $winrate)"/>
                                    <xsl:choose>
                                        <xsl:when test="$winrate &lt; 25">
                                            <div class="progress-bar-item progress-bar-item--red" style="width: {$winrate}%" title="{$winrate}%"></div>
                                        </xsl:when>
                                        <xsl:when test="$winrate &lt; 50">
                                            <div class="progress-bar-item progress-bar-item--yellow" style="width: {$winrate}%" title="{$winrate}%"></div>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <div class="progress-bar-item progress-bar-item--green" style="width: {$winrate}%" title="{$winrate}%"></div>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                    <div class="progress-bar-item" style="width: {$loserate}%" title="{$loserate}%"></div>
                                </div>
                            </div>
                        </aside>
                    </main>
                    <script><![CDATA[
                        (function () {
                            document.querySelectorAll(".deck-card").forEach(card => {
                                card.addEventListener("click", () => card.classList.toggle("deck-card--selected"));
                            });
                        })();
                    ]]></script>
                </body>
            </html> 
        </xsl:result-document>
    </xsl:template>
    
</xsl:stylesheet>