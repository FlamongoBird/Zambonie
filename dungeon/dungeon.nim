import "../terminal/terminal"
import "../colors/colors"
import sequtils
import std/strformat
import std/random

randomize()

proc generateDungeon*(width, height: int): seq[seq[int]] =
    var dungeon_map = newSeqWith(height, newSeq[int](width))
    for y, row in dungeon_map:
        var wall = false
        if y == 0 or y == len(dungeon_map)-1:
            wall = true
        for x, item in row:
            if wall or x == 0 or x == len(row)-1:
                dungeon_map[y][x] = 1
            
    return dungeon_map


proc findSpawn*(dungeon: var seq[seq[int]]): (int, int) =
    while true:
        var y = rand(dungeon.len-2) + 1
        if count(dungeon[y], 0) > 0:
            while true:
                var x = rand(dungeon[y].len-2) + 1
                if dungeon[y][x] == 0:
                    return (x, y)

proc spawnItem*(item:int, dungeon: var seq[seq[int]]): (int, int) =
    var loc = findSpawn(dungeon)
    dungeon[loc[1]][loc[0]] = item
    return loc



proc colorString(str: string, fg: array[3, int], bg: array[3, int]): string =
    return &"\x1b[38;2;{fg[0]};{fg[1]};{fg[2]}m\x1b[48;2;{bg[0]};{bg[1]};{bg[2]}m{str}\x1b[0m"



proc printDungeonMap*(dungeon_map: seq[seq[int]], stats: string) =
    var final = newSeq[string](0) 
    final.add(stats)
    final.add(" ")
    for row in dungeon_map:
        var line = ""
        for item in row:
            var output: string
            case item:
                # 0-10 are map blocks
                of 0:
                    # floor
                    output = "   " 
                of 1:
                    # walls
                    output = colorString("   ", [0, 0, 0], [50, 50, 50])
                of 2:
                    # empty
                    output = " . "
                of 3:
                    # highlighted floor
                    output = colorString("   ", [0, 0, 0], [150, 150, 150])
                of 5:
                    # treasure
                    output = colorString("[T]", [255, 215, 0], [0,0,0])
                # 69 is player cause
                of 69:
                    output = " X "
                # 11-20 are monsters
                of 11:
                    # Goblin
                    output = " G "
                # 21-30 are monsters highlighed
                of 21:
                    # Goblin
                    output = colorString(" G ", HIGHLIGHT_FG, HIGHLIGHT_BG)
                else:
                    output = " . "
            line = line & output
        final.add(line)
    display(final)
