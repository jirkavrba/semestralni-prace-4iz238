<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:mtg="urn:dev.vrba:xml:mtg"
    exclude-result-prefixes="xs mtg"
    version="3.0">
    
    <xsl:output method="html" version="5" />
    <xsl:output method="html" version="5" name="html5" />
    
    <xsl:template
        match="/" mode="#default">
        <html lang="en">
            <head>
                <title>Magic: The Gathering decks</title>
                <meta name="og:title" content="Magic: The Gathering decks" />
                <meta name="og:description">
                    <xsl:attribute name="content">This page contains <xsl:value-of
                            select="count(mtg:decks/mtg:deck)" /> decks</xsl:attribute>
                </meta>
            </head>
            <body>
                <xsl:apply-templates />
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="/mtg:deck" mode="#default">
        <xsl:variable name="name" select="mtg:name" />
        <section>
            <h1>
                <xsl:value-of select="$name" />
            </h1>
            <ul>
                <!-- <xsl:for-each select="/c:citaty/c:citat[c:autor=$autor]">
                     <xsl:sort select="c:text" />
                     <li>
                     <xsl:value-of select="c:text" />
                     </li>
                     </xsl:for-each> -->
             </ul>
        </section>
    </xsl:template>
    
</xsl:stylesheet>