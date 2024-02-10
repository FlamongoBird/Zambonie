import "../terminal/terminal"
import sequtils


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
                    output = "###"
                of 69:
                    output = " X "
                else:
                    output = " . "
            line = line & output
        final.add(line)
    display(final) 