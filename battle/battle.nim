import "../weapons/weapons"
import "../weapons/armor"
import random
import math

randomize()


proc calcDamage*(weapon: Weapon, armor: Armor): int =
    var raw = rand(weapon.dmg_max - weapon.dmg_min) + weapon.dmg_max
    var b = armor.armor
    var r = raw - b
    if r < 0:
        return 0
    else:
        return r


