<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:mtg="https://vrba.dev/mtg" queryBinding="xslt2" 
            xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
            <sch:pattern>
                <sch:title>Validate number of cards based on the deck format</sch:title>

                <!-- All formats require at least 60 cards -->
                <sch:rule context="//deck[./format/text() != 'Commander']">
                    <sch:assert test="sum(./cards/card/@count) &gt; 59">
                        The number of cards in the deck "<sch:value-of select="./name/text()"/>" must be at least 60
                    </sch:assert>
                </sch:rule>

                <!-- Commander (EDH) requires at least 100 cards -->
                <sch:rule context="//deck[./format/text() = 'Commander']">
                    <sch:assert test="sum(./cards/card/@count) &gt; 99">
                        The number of cards in the deck "<sch:value-of select="./name/text()"/>" must be at least 99
                    </sch:assert>
                </sch:rule>
            </sch:pattern>

            <sch:pattern>
                <sch:title>Validate number of unique cards based on the deck format</sch:title>

                <!-- All formats at most 4 cards with the same name (except for basic lands) -->
                <sch:rule context="//deck[./format/text() != 'Commander']/cards/card[type != 'Basic Land']">
                    <sch:report test="@count &gt; 4">
                        The card <sch:value-of select="./name/text()"/> is contained more than 4 times in the deck "<sch:value-of select="../../name/text()"/>".
                    </sch:report>
                </sch:rule>

                <!-- Commander (EDH) requires all 100 cards to be unique (except for basic lands) -->
                <sch:rule context="//deck[./format/text() = 'Commander']/cards/card[type != 'Basic Land']">
                    <sch:report test="@count &gt; 1">
                        The card <sch:value-of select="./name/text()"/> is contained more than once in the deck "<sch:value-of select="../../name/text()"/>".
                    </sch:report>
                </sch:rule>
            </sch:pattern>

            <sch:pattern>
                <sch:title>The deck cannot contain cards that are illegal in the given format</sch:title>
                <sch:rule context="deck/cards/card">
                    <sch:let name="format" value="../../lower-case(./format/text())"/>
                    <sch:let name="card" value="./name/text()"/>
                    <sch:report test="empty(./legality/format[lower-case(text()) = $format])">
                        The card <sch:value-of select="$card"/> is not legal in the deck format (<sch:value-of select="$format"/>).
                    </sch:report>
                </sch:rule>
            </sch:pattern>
    
</sch:schema>