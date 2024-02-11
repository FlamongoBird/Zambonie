import std/tables

type Armor* = object
    deflect*: int
    armor*: int

let armors = {
    "leather" : Armor(
        deflect: 90,
        armor: 1
    )
}.toTable



proc getArmor*(name: string): Armor =
    return armors[name]