import std/json
import std/jsonutils
import "../player/player"
import "../enemies/enemy"
import "../dungeon/dungeon_generator"
from os import fileExists

type
    GameSave* = object
        player*: Player
        dungeon*: Dungeon
        enemies*: seq[Enemy]
        x*: int
        y*: int


proc saveGameData*(player: Player, dungeon: Dungeon, enemies: seq[Enemy], x, y: int) = 
    var game_save = GameSave(
        player: player,
        dungeon: dungeon,
        enemies: enemies,
        x: x,
        y: y
    ).toJson()
    writeFile("./game_saves/save.json", $game_save)


proc saveExists*(): bool =
    return false
    #[
    if fileExists("./game_saves/save.json"):
        if readFile("./game_saves/save.json") != "":
            return true
    return false
    ]#
