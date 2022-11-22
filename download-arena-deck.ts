#!/usr/bin/env -S deno run --allow-read --allow-net

import fs from "https://deno.land/std@0.165.0/node/fs.ts";
import process from "https://deno.land/std@0.165.0/node/process.ts";
import { copyFilePromise } from "https://deno.land/std@0.165.0/node/_fs/_fs_copy.ts";

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
                        power: response.power,
                        toughness: response.toughness,
                        legalities: response.legalities
                    }
                }
            });
    })
);

const processCost = (source: string): string => {
    type Symbol = "G" | "R" | "W" | "U" | "B";
    type Color = "colorless" | "green" | "red" | "white" | "blue" | "black";

    const cost: Record<Color, number> = [...source.matchAll(/\{([0-9]+|G|R|B|U|W)\}/g)].reduce((accumulator, match) => {
        if (match[1].match(/\d+/)) {
            return { ...accumulator, colorless: Number(match[1]) };
        }

        const symbol: Symbol = match[1] as Symbol;
        const colors: Record<Symbol, Color> = {
            "G": "green",
            "R": "red",
            "W": "white",
            "U": "blue",
            "B": "black"
        };

        const color: Color = colors[symbol];

        return { ...accumulator, [color]: accumulator[color] + 1 }
    }, {
        colorless: 0,
        green: 0,
        red: 0,
        white: 0,
        blue: 0,
        black: 0
    });

    return Object.entries(cost)
        .filter(([_color, value]) => value > 0)
        .map(([color, value]) => "<" + color + ">" + value + "</" + color + ">")
        .join("\n")
}

const transformed = data.map(card => {
    return `
        <card count="${card.count}">
            <name>${card.data.name}</name>
            <cost>${processCost(card.data.cost)}</cost>
        </card>
    `;
})
    .join("\n");

process.stdout.write(transformed);