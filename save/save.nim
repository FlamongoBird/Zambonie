import std/json

proc saveGameData*(player: string, dungeon: seq[seq[int]], enemies: seq[string]) = 
    var save_data = %* {
        "player" : player,
        "dungeon" : dungeon,
        "enemies" : enemies
    }
    writeFile("./game_saves/save.json", $save_data)
    