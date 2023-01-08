<?xml version="1.0" encoding="UTF-8"?>
<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron"
            xmlns:mtg="https://vrba.dev/mtg" queryBinding="xslt2" 
            xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
            <sch:pattern>
                <sch:title>Validate number of cards based on the deck format</sch:title>
                <sch:rule context="//deck">
                    <sch:assert test="./format/text() != 'Commander'">The format is not commander, where the limits are different</sch:assert>
                    <sch:report test="sum(./cards/card/@count) &gt; 59">The number of cards must be at least 60</sch:report>
                </sch:rule>
            </sch:pattern>
    
</sch:schema>