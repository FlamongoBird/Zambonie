import "../terminal/terminal"
import sequtils
import std/strformat


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


proc colorString(str: string, fg: array[3, int], bg: array[3, int]): string =
    return &"\x1b[38;2;{fg[0]};{fg[1]};{fg[2]}m\x1b[48;2;{bg[0]};{bg[1]};{bg[2]}m{str}\x1b[0m"



proc printDungeonMap*(dungeon_map: seq[seq[int]]) =
    var final = newSeq[string](0) 
    for row in dungeon_map:
        var line = ""
        for item in row:
            var output: string
            case item:
                of 0:
                    output = "   " 
                of 1:
                    output = colorString("   ", [0, 0, 0], [50, 50, 50])
                of 69:
                    output = colorString(" X ", [255, 255, 255], [100, 100, 100])
                else:
                    output = " . "
            line = line & output
        final.add(line)
    display(final) 
