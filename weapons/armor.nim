import std/tables

type Armor* = object
    name*: string
    deflect*: int
    armor*: int

let armors = {
    "leather": Armor(
        name: "Leather",
        deflect: 5,
        armor: 1
    ),
    "player_armor": Armor(
        name: "Player Armor",
        deflect: 50,
        armor: 15,
    )
}.toTable




proc getArmor*(name: string): Armor =
    return armors[name]
