import "../weapons/weapons"
import "../weapons/armor"
import "../dungeon/dungeon"

type Enemy* = object
    hp: int
    weapon: Weapon
    armor: Armor
    symbol: int
    x: int
    y: int

proc enemyLoc*(enemy: Enemy): (int, int) =
    echo (enemy.x, enemy.y)
    return (enemy.x, enemy.y)

proc generateGoblin*(dungeon: var seq[seq[int]]): Enemy =
    var loc = spawnItem(11, dungeon)
    echo loc
    return Enemy(
        hp: 15,
        weapon: getWeapon("sword"),
        armor: getArmor("leather"),
        symbol: 11,
        x: loc[0],
        y: loc[1]
    )

proc enemySymbol*(enemy: Enemy): int =
    return enemy.symbol

