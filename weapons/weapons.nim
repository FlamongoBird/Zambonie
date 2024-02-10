import std/tables

type Weapon* = object
    dmg_min: int
    dmg_max: int

let weapons = {
    "sword" : Weapon(
        dmg_min: 3,
        dmg_max: 5
    )
}.toTable



proc getWeapon(name: string): Weapon =
    # prolly gunna have an issue with there only being a
    # single instance of each weapon getting reused but we'll
    # cross that bridge when it comes to it, not a hard fix 
    return weapons[name]

