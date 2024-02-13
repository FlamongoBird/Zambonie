import "../weapons/weapons"
import "../weapons/armor"
import "../dungeon/dungeon_handler"
import "../player/player"
import "../terminal/terminal"
import "../battle/battle"
import "../colors/colors"
import "../colors/color"
import std/strformat
import random


randomize()

type Enemy* = object
    name*: string
    hp: int
    weapon*: Weapon
    armor*: Armor
    symbol: int
    x*: int
    y*: int
    r: int


proc enemyAlive*(enemy: Enemy): bool =
    if enemy.hp > 0:
        return true
    return false

proc enemyDeflectAttack*(enemy: Enemy): bool =
    var d = rand(100)
    if enemy.armor.deflect > d:
        return true
    return false

proc lootEnemy*(player: var Player, enemy: Enemy) =
    # TODO: Implement this later
    discard

proc hurtEnemy*(enemy: var Enemy, dmg: int) =
    enemy.hp -= dmg

proc enemyLoc*(enemy: Enemy): (int, int) =
    return (enemy.x, enemy.y)

proc moveEnemy*(loc: (int, int), enemy: var Enemy) =
    enemy.x = loc[0]
    enemy.y = loc[1]

proc enemyInRange*(enemy: Enemy, x, y: int): bool =
    var distance = abs(enemy.x - x) + abs(enemy.y - y)
    if distance <= enemy.r and distance > enemy.weapon.r:
        return true
    return false

proc enemyInAttackRange*(enemy: Enemy, x, y: int): bool =
    var distance = abs(enemy.x - x) + abs(enemy.y - y)
    if distance <= enemy.weapon.r:
        return true
    return false

proc enemyAttack*(enemy: var Enemy, player: var Player) =
    if playerDeflectAttack(player):
        popup(&"{enemy.name}'s attack is " & colorString("deflected", GOOD_FG))
        moveOn()
    else:
        var dmg = calcDamage(enemy.weapon, player.armor)
        popup(&"{enemy.name} attacks you! -{colorString($dmg, BAD_FG)}hp")
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
    )
proc generateGoblin*(): Enemy =
    return Enemy(
        name: "Goblin",
        hp: 15,
        weapon: getWeapon("sword"),
        armor: getArmor("leather"),
        symbol: 11,
        x: 0,
        y: 0,
        r: 5,
    )

proc enemySymbol*(enemy: Enemy): int =
    return enemy.symbol

