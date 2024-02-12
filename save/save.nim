import std/json
import "../player/player"
import "../enemies/enemy"

type
    GameSave* = object
        player*: Player
        dungeon*: seq[seq[int]]
        enemies*: seq[Enemy]


proc saveGameData*(player: Player, dungeon: seq[seq[int]], enemies: seq[Enemy]) = 
    var game_save = %* GameSave(
        player: player,
        dungeon: dungeon,
        enemies: enemies
    )
    writeFile("./game_saves/save.json", $game_save)
    