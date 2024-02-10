import std/tables

type Armor* = object
    deflect: float
    armor: int

let armors = {
    "leather" : Armor(
        deflect: 0,
        armor: 1
    )
}.toTable



proc getArmor*(name: string): Armor =
    return armors[name]