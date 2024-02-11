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
    return (enemy.x, enemy.y)

proc moveEnemy*(loc: (int, int), enemy: var Enemy) =
    enemy.x = loc[0]
    enemy.y = loc[1]

proc generateGoblin*(dungeon: var seq[seq[int]]): Enemy =
    var loc = spawnItem(11, dungeon)
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

