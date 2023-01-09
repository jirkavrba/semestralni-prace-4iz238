<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:mtg="https://vrba.dev/mtg" queryBinding="xslt2" 
            xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
            <sch:pattern>
                <sch:title>Validate number of cards based on the deck format</sch:title>

                <!-- All formats require at least 60 cards -->
                <sch:rule context="//deck[./format/text() != 'Commander']">
                    <sch:assert test="sum(./cards/card/@count) &gt; 59">The number of cards must be at least 60</sch:assert>
                </sch:rule>

                <!-- Commander (EDH) requires at least 100 cards -->
                <sch:rule context="//deck[./format/text() = 'Commander']">
                    <sch:assert test="sum(./cards/card/@count) &gt; 99">The number of cards must be at least 99</sch:assert>
                </sch:rule>
            </sch:pattern>

            <sch:pattern>
                <sch:title>Validate number of unique cards based on the deck format</sch:title>

                <!-- All formats at most 4 cards with the same name (except for basic lands) -->
                <sch:rule context="//deck[./format/text() != 'Commander']/cards/card[type != 'Basic Land']">
                    <sch:assert test="@count &lt; 5">The can be at most 4 cards with the same name.</sch:assert>
                </sch:rule>

                <!-- Commander (EDH) requires all 100 cards to be unique (except for basic lands) -->
                <sch:rule context="//deck[./format/text() = 'Commander']/cards/card[type != 'Basic Land']">
                    <sch:assert test="@count &lt; 2">Every card in the deck needs to be unique.</sch:assert>
                </sch:rule>
            </sch:pattern>

            <sch:pattern>
                <sch:title>The deck cannot contain cards that are illegal in the given format</sch:title>
                <sch:rule context="//deck">
                    <sch:report test="count(./cards/card[not(contains(./legalities/format, lower-case(./format)))]) &gt; 0">
                        One or more cards are not legal in the deck format
                    </sch:report>
                </sch:rule>
            </sch:pattern>
    
</sch:schema>