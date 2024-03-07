import "../terminal/terminal"
import "../colors/colors"
import sequtils
import std/strformat
import std/random
import dungeon_generator

randomize()




proc atRoomEntry*(dungeon: Dungeon, x, y: int): bool =
    if dungeon.rooms[dungeon.current_room].entry[0] == x and dungeon.rooms[dungeon.current_room].entry[1] == y:
        return true
    return false

proc adjustCords*(room: Room, cords: (int, int)): (int, int) =
    #[ Figures out if the door is on the top, bottom, left, right of the
    room and adjusts the cords one above, below, etc ]#
    result = (cords[0], cords[1])

    if result[0] == len(room.room[0])-1:
        result[0] -= 1
    if result[0] == 0:
        result[0] = 1

    if result[1] == len(room.room)-1:
        result[1] -= 1
    if result[1] == 0:
        result[1] = 1


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
    for y, row in dungeon_map:
        var line = ""
        for x, item in row:
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
                    output = colorString("   ", [0, 0, 0], [10, 10, 10])
                of 3:
                    # highlighted floor
                    output = " . "
                of 4:
                    # tunnel
                    output = colorString(" ~ ", [75, 75, 75], [0, 0, 0])
                of 10:
                    # Door
                    output = " | "
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
                # 31-40 are monsters selected
                of 31:
                    # Goblin
                    output = colorString(" G ", SELECTED_FG, SELECTED_BG)
                else:
                    output = " . "
            line = line & output
        final.add(line)
    display(final)

