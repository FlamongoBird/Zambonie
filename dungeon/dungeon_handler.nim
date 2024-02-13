import "../terminal/terminal"
import "../colors/colors"
import sequtils
import std/strformat
import std/random
import std/deques

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


proc getNeighbors(point: (int, int, int), matrix: seq[seq[int]]): seq[(int, int, int)] =
    var n: seq[(int, int, int)]
    n.add((point[0]+1, point[1]+1, matrix[point[1]][point[0]]))
    n.add((point[0]+1, point[1]-1, matrix[point[1]][point[0]]))
    n.add((point[0]-1, point[1]+1, matrix[point[1]][point[0]]))
    n.add((point[0]-1, point[1]-1, matrix[point[1]][point[0]]))
    n.add((point[0]+1, point[1], matrix[point[1]][point[0]]))
    n.add((point[0]-1, point[1], matrix[point[1]][point[0]]))
    n.add((point[0], point[1]+1, matrix[point[1]][point[0]]))
    n.add((point[0], point[1]-1, matrix[point[1]][point[0]]))


proc findSpawnQuick(graph: seq[seq[int]]): (int, int) =
    for y, row in graph:
        if count(graph[y], 0) > 0:
            for x, amongus in row:
                if row[x] == 0:
                    return (x, y)
    return (-1, -1)



proc splitIntoRooms*(raw: var seq[seq[int]]): seq[seq[seq[int]]] =
    var rooms: seq[seq[seq[int]]]

    echo "Splitting rooms"
 
    while true:
        echo "finding room"
        var x = findSpawnQuick(raw)
        if x == (-1, -1):
            echo "no more open spaces"
            break
        var
            known_point = (x[0], x[1], raw[x[1]][x[0]])
            queue = initDeque[(int, int, int)]()
            room: seq[(int, int, int)]
            top_right = (-500, -500)
            bottom_left = (500, 500)

        queue.addFirst(known_point)

        while len(queue) > 0:
            var point = queue.popFirst()
            if point[0] > top_right[0] or point[1] < top_right[1]:
                top_right = (point[0], point[1])
            if point[0] < bottom_left[0] or point[1] > bottom_left[1]:
                bottom_left = (point[0], point[1])
            room.add(point)
            var neighbors = getNeighbors(point, raw)
            for n in neighbors:
                if n[2] == 0 or n[2] == 1:
                    queue.addFirst(n)

        echo room

        # convert room to seq[seq[int]]

        var actual: seq[seq[int]] 

        echo top_right
        echo bottom_left

        for y in countup(0, top_right[1] - bottom_left[1], 1):
            actual.add(newSeq[int]())
            for x in countup(0, top_right[0] - bottom_left[0], 1):
                actual[y].add(2)

        echo "actual"
        echo actual

        for loc in room:
            actual[loc[1]][loc[0]] = loc[2]
            raw[loc[1]][loc[0]] = 25
        
        rooms.add(actual)
