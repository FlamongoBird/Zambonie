import std/json

proc saveGameData*(player: JsonNode, dungeon: seq[seq[int]], enemies: seq[JsonNode]) = 
    var save_data = %* {
        "player" : player,
        "dungeon" : dungeon,
        "enemies" : enemies
    }
    writeFile("./game_saves/save.json", $save_data)
    