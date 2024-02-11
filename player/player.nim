import std/strformat
import "../util_functions/util_functions"
import "../terminal/terminal"
import "../game/treasure"
import "../weapons/weapons"
import "../weapons/armor"

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
        armor: getArmor("leather"),
        weapon: getWeapon("sword"),
    )
    return p


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

