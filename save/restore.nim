import std/json
import "../save/save"

proc restoreGameData*(): GameSave =
    let raw = readFile("./game_saves/save.json")
    let game_json = parseJson(raw)
    let game_data = to(game_json, GameSave)
    return game_data
