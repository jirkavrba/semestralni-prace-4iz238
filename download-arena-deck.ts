#!/usr/bin/env -S deno run --allow-read --allow-net

import fs from "https://deno.land/std@0.165.0/node/fs.ts";
import process from "https://deno.land/std@0.165.0/node/process.ts";

const source = fs.readFileSync("./deck.txt").toString();
const parsed = source.split("\n")
    .map(line => line.trim())
    .filter(line => line.length > 0)
    .map(line => line.split(/\s+/))
    .map(([count, ...name]) => {
        return {
            count: Number(count),
            name: name.join(" ")
        }
    });

const data = await Promise.all(
    parsed.map(({ count, name }) => {
        return fetch("https://api.scryfall.com/cards/named?exact=" + name.replace(/\s+/g, "+").toLowerCase())
            .then(response => response.json())
            .then(response => {
                return {
                    count,
                    data: {
                        name: response.name,
                        cost: response.mana_cost,
                        rarity: response.rarity,
                        set: response.set,
                        type: response.type_line,
                        colors: response.colors,
                        text: response.oracle_text,
                        image: response.image_uris.art_crop,
                        artist: response.artist,
                        legalities: response.legalities
                    }
                }
            });
    })
);

process.stdout.write(JSON.stringify(data));