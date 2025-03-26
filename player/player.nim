import std/strformat
import "../util_functions/util_functions"
import "../terminal/terminal"
import "../game/treasure"
import "../weapons/weapons"
import "../weapons/armor"
import random


randomize()

type
    Player* = object
        hp: int
        hp_max: int
        inventory: seq[int]
        armor*: Armor
        weapon*: Weapon

proc newPlayer*(): Player =
    var p = Player(
        hp: 20,
        hp_max: 20,
        inventory: newSeq[int](0),
        armor: getArmor("player_armor"),
        weapon: getWeapon("player_weapon"),
    )
    return p

proc playerDeflectAttack*(player: Player): bool =
    var d = rand(100)
    if player.armor.deflect > d:
        return true
    return false


proc showPlayerInventory*(player: Player) =
    var message = @["You have: "]
    var output = ""
    for item in player.inventory:
        output = output & getTreasureName(item)
    message.add(output)
    display(message)
    moveOn()

proc givePlayerTreasure*(player: var Player, treasure: int) =
    player.inventory.add(treasure)

proc hurtPlayer*(player: var Player, dmg: int) =
    player.hp -= dmg

proc playerDead*(player: Player): bool =
    if player.hp <= 0:
        return true
    return false

proc playerStats*(player: Player): string =
    var bar = buildBar(player.hp / player.hp_max, 15)
    return fmt"HP: {bar} [{player.hp}/{player.hp_max}]"

proc bigStats*(player: Player): seq[string] =
    var output: seq[string]

    output.add("")
    output.add("")
    output.add("")

    output.add(playerStats(player))

    output.add("")

    output.add(fmt"ARMOR: {buildBar(player.armor.armor/20, 15)}")
    output.add(fmt"ARMOR DEFLECT: {player.armor.deflect}%")

    output.add("")

    output.add(fmt"WEAPON DAMAGE: {buildBar(((player.weapon.dmg_min+player.weapon.dmg_max) / 2) / 100, 15)}")
    output.add(fmt"WEAPON RANGE: {player.weapon.r}")

    return output
