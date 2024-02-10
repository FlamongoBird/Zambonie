import "../terminal/terminal"
import std/random
import std/strformat
import std/tables

randomize()

var treasure_values = {
    0 : "gold",
    1 : "silver",
    2 : "diamond"
}.toTable

proc openTreasure*(): int =
    var treasure = rand(2)

    var name = treasure_values[treasure]

    popup(&"You found {name}")
    moveOn()

    return treasure


proc getTreasureName*(treasure: int): string =
    return treasure_values[treasure]


    