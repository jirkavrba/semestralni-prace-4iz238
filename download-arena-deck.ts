#!/usr/bin/env -S deno run --allow-read --allow-net
import process from "https://deno.land/std@0.165.0/node/process.ts" 

const capitalize = (input: string): string => input.charAt(0).toUpperCase() + input.slice(1);

const source = Deno.readTextFileSync("./source.txt");
const parsed = source.split("\n")
  .map((line) => line.trim())
  .filter((line) => line.length > 0)
  .map((line) => line.split(/\s+/))
  .map(([count, ...name]) => {
    return {
      count: Number(count),
      name: name.join(" "),
    };
  });
const data = await Promise.all(
  parsed.map(({ count, name }) => {
    return fetch(
      "https://api.scryfall.com/cards/named?exact=" +
      name.replace(/\s+/g, "+").toLowerCase(),
    )
      .then((response) => response.json())
      .then((response) => {
        const source = response.layout === "transform" ? response.card_faces[0] : response;

        return {
          count,
          data: {
            id: response.oracle_id,
            name: source.name,
            cost: source.mana_cost,
            rarity: response.rarity,
            set: response.set,
            type: source.type_line,
            colors: source.colors,
            text: source.oracle_text,
            image: {
              card: source.image_uris.large,
              art: source.image_uris.art_crop,
            },
            artist: source.artist,
            power: source.power,
            toughness: source.toughness,
            legalities: response.legalities,
          },
        };
      });
  }),
);
type Symbol = "G" | "R" | "W" | "U" | "B";
type Color = "colorless" | "green" | "red" | "white" | "blue" | "black";
const colors: Record<Symbol, Color> = {
  "G": "green",
  "R": "red",
  "W": "white",
  "U": "blue",
  "B": "black",
};
const processCost = (source: string): string => {
  const cost: Record<Color, number> = [
    ...source.matchAll(/\{([0-9]+|G|R|B|U|W)\}/g),
  ].reduce((accumulator, match) => {
    if (match[1].match(/\d+/)) {
      return { ...accumulator, colorless: Number(match[1]) };
    }
    const symbol: Symbol = match[1] as Symbol;
    const color: Color = colors[symbol];
    return { ...accumulator, [color]: accumulator[color] + 1 };
  }, {
    colorless: 0,
    green: 0,
    red: 0,
    white: 0,
    blue: 0,
    black: 0,
  });
  return Object.entries(cost)
    .filter(([_color, value]) => value > 0)
    .map(([color, value]) => "<" + color + ">" + value + "</" + color + ">")
    .join("\n");
};
const processType = (source: string): { type: string; subtype: string } => {
  const [type, subtype] = (source)
    .split(" — ")
    .map((item) => item.trim());
  return {
    type,
    subtype,
  };
};
const processColors = (source: Array<Symbol>): string => {
  return source
    .map((symbol) => colors[symbol])
    .map((color) => `<color>${capitalize(color)}</color>`)
    .join("\n");
};
const processLegality = (source: Record<string, string>): string => {
  return Object.entries(source)
    .filter(([_format, legality]) => legality === "legal")
    .map(([format]) => `<format>${capitalize(format)}</format>`)
    .join("\n");
};
const transformed = data.map((card) => {
  const cost = processCost(card.data.cost);
  const colors = processColors(card.data.colors);
  const legality = processLegality(card.data.legalities);
  const { type, subtype } = processType(card.data.type);
  return `
        <card count="${card.count}" id="${card.data.id}">
            <name>${card.data.name}</name>
            <colors>${colors}</colors>
            <rarity>${capitalize(card.data.rarity)}</rarity>
            <cost>${cost}</cost>
            <type>${type}</type>
            <images>
              <card>${card.data.image.card}</card>
              <art>${card.data.image.art}</art>
            </images>
            ${subtype !== undefined ? ("<subtype>" + subtype + "</subtype>") : ""
    }
            ${card.data.power ? ("<power>" + card.data.power + "</power>") : ""}
            ${card.data.toughness
      ? ("<toughness>" + card.data.toughness + "</toughness>")
      : ""
    }
            <text>${card.data.text?.replace("\n", " ")}</text>
            <set>${card.data.set}</set>
            <legality>${legality}</legality>
            <artist>${card.data.artist}</artist>
        </card>
    `;
})
  .join("\n");
process.stdout.write(transformed);
