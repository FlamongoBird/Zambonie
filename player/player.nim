import std/strformat
import "../util_functions/util_functions"

type
    Player* = object
        hp: int
        hp_max: int

proc hurtPlayer*(player: var Player) =
    player.hp -= 1

proc playerDead*(player: Player): bool = 
    if player.hp <= 0:
        return true
    return false

proc playerStats*(player: Player): string =
    var bar = buildBar(player.hp / player.hp_max, 15)
    return fmt"HP: {bar} [{player.hp}/{player.hp_max}]"


proc newPlayer*(): Player =
    var p = Player(
        hp: 20,
        hp_max: 20
    )
    return p