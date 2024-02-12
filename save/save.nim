import std/json
import "../player/player"
import "../enemies/enemy"
from os import fileExists

type
    GameSave* = object
        player*: Player
        dungeon*: seq[seq[int]]
        enemies*: seq[Enemy]
        x*: int
        y*: int


proc saveGameData*(player: Player, dungeon: seq[seq[int]], enemies: seq[Enemy], x, y: int) = 
    var game_save = %* GameSave(
        player: player,
        dungeon: dungeon,
        enemies: enemies,
        x: x,
        y: y
    )
    writeFile("./game_saves/save.json", $game_save)


proc saveExists*(): bool =
    if fileExists("./game_saves/save.json"):
        if readFile("./game_saves/save.json") != "":
            return true
    return false