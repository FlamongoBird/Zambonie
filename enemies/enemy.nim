import "../weapons/weapons"
import "../weapons/armor"

type Enemy* = object
    hp: int
    weapon: Weapon
    armor: Armor
    symbol: int


proc generateGoblin*(): Enemy =
    return Enemy(
        hp: 15,
        weapon: getWeapon("sword"),
        armor: getArmor("leather"),
        symbol: 11
    )

proc enemySymbol*(enemy: Enemy): int =
    return enemy.symbol

