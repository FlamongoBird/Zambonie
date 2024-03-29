import std/tables

type Weapon* = object
    dmg_min*: int
    dmg_max*: int
    r*: int

let weapons = {
    "sword" : Weapon(
        dmg_min: 3,
        dmg_max: 5,
        r: 1,
    ),
    "player_weapon" : Weapon(
        dmg_min: 100,
        dmg_max: 100,
        r: 2,
    )
}.toTable



proc getWeapon*(name: string): Weapon =
    # prolly gunna have an issue with there only being a
    # single instance of each weapon getting reused but we'll
    # cross that bridge when it comes to it, not a hard fix 
    return weapons[name]

