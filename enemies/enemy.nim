import "../weapons/weapons"
import "../weapons/armor"
import "../dungeon/dungeon"
import "../player/player"
import "../terminal/terminal"
import "../battle/battle"
import std/strformat

type Enemy* = object
    name: string
    hp: int
    weapon: Weapon
    armor: Armor
    symbol: int
    x: int
    y: int
    r: int
    attack_r: int

proc enemyLoc*(enemy: Enemy): (int, int) =
    return (enemy.x, enemy.y)

proc moveEnemy*(loc: (int, int), enemy: var Enemy) =
    enemy.x = loc[0]
    enemy.y = loc[1]

proc enemyInRange*(enemy: Enemy, x, y: int): bool =
    var distance = abs(enemy.x - x) + abs(enemy.y - y)
    if distance <= enemy.r and distance > enemy.attack_r:
        return true
    return false

proc enemyInAttackRange*(enemy: Enemy, x, y: int): bool =
    var distance = abs(enemy.x - x) + abs(enemy.y - y)
    if distance <= enemy.attack_r:
        return true
    return false

proc enemyAttack*(enemy: var Enemy, player: var Player) =
    var dmg = calcDamage(enemy.weapon, player.armor)
    popup(&"{enemy.name} attacks you! -{dmg}hp")
    moveOn()
    hurtPlayer(player, dmg)


proc generateGoblin*(dungeon: var seq[seq[int]]): Enemy =
    var loc = findSpawn(dungeon)
    return Enemy(
        name: "Goblin",
        hp: 15,
        weapon: getWeapon("sword"),
        armor: getArmor("leather"),
        symbol: 11,
        x: loc[0],
        y: loc[1],
        r: 5,
        attack_r: 1,
    )

proc enemySymbol*(enemy: Enemy): int =
    return enemy.symbol

