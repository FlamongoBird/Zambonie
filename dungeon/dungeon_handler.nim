import "../terminal/terminal"
import "../colors/colors"
import "../util_functions/util_functions"
import "../player/player"
import sequtils
import std/strformat
import std/random
import dungeon_generator
import std/deques

randomize()



#[
proc atRoomEntry*(dungeon: Dungeon, x, y: int): bool =
    if dungeon.rooms[dungeon.current_room].entry[0] == x and dungeon.rooms[dungeon.current_room].entry[1] == y:
        return true
    return false
]#

proc adjustCords*(room: Room, cords: array[2, int]): array[2, int] =
    #[ Figures out if the door is on the top, bottom, left, right of the
    room and adjusts the cords one above, below, etc ]#
    result = [cords[0], cords[1]]

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

proc spawnItem*(item: int, dungeon: var seq[seq[int]]): (int, int) =
    var loc = findSpawn(dungeon)
    dungeon[loc[1]][loc[0]] = item
    return loc



proc colorString(str: string, fg: array[3, int], bg: array[3, int]): string =
    return &"\x1b[38;2;{fg[0]};{fg[1]};{fg[2]}m\x1b[48;2;{bg[0]};{bg[1]};{bg[2]}m{str}\x1b[0m"



proc displayMap(dungeon_map: seq[seq[int]], player: Player) =
    var final = newSeq[string](0)
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
                of 7:
                    # locked door
                    output = "[x]"
                of 8:
                    # unlocked door
                    output = "[ ]"
                of 9:
                    # exit
                    output = colorString("   ", [0, 0, 0], [200, 0, 0])
                of 10:
                    # entry
                    output = colorString("   ", [0, 0, 0], [0, 200, 0])
                of 5:
                    # treasure
                    output = colorString("[T]", [255, 215, 0], [0, 0, 0])
                # 69 is player cause
                of 69:
                    output = " X "
                # 11-20 are monsters
                of 11:
                    # Goblin
                    output = " G "
                of 12:
                    # Fiend
                    output = " F "
                of 13:
                    # Goul
                    output = colorString(" G ", [50, 50, 50], [100, 100, 100])
                of 14:
                    # monkey
                    output = colorString(" M ", [245, 209, 66], [88, 56, 40])
                # 21-30 are monsters highlighed
                of 21:
                    # Goblin
                    output = colorString(" G ", HIGHLIGHT_FG, HIGHLIGHT_BG)
                # 31-40 are monsters selected
                of 31:
                    # Goblin
                    output = colorString(" G ", SELECTED_FG, SELECTED_BG)
                else:
                    output = " ? "
            line = line & output
        final.add(line)

    var real_final = joinSequences(final, bigStats(player), "      ")
    display(real_final)

proc hideOtherRooms(dungeon_map: var seq[seq[int]]) =
    # hide rooms that the player is not in
    let rows = dungeon_map.len
    let cols = dungeon_map[0].len

    # Find player position
    var px, py = -1
    for x in 0..<rows:
        for y in 0..<cols:
            if dungeon_map[x][y] == 69:
                px = x
                py = y
                break
        if px != -1:
            break

    if px == -1:
        return

    # there may be an easier way to do this... most likely I will find it a few days after

    var
        visited = newSeqWith(rows, newSeq[bool](cols))
        queue = initDeque[(int, int)]()

    queue.addLast((px, py))

    visited[px][py] = true

    let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]

    while queue.len > 0:
        let (x, y) = queue.popFirst()
        for (dx, dy) in directions:
            let nx = x + dx
            let ny = y + dy
            if nx >= 0 and nx < rows and ny >= 0 and ny < cols:
                if not visited[nx][ny] and dungeon_map[nx][ny] != 1:
                    visited[nx][ny] = true
                    if dungeon_map[nx][ny] != 7 and dungeon_map[nx][ny] != 8:
                        queue.addLast((nx, ny))

    for x in 0..<rows:
        for y in 0..<cols:
            if dungeon_map[x][y] != 1 and not visited[x][y]:
                dungeon_map[x][y] = 1



proc printDungeonMap*(dungeon_map: seq[seq[int]], player: Player, globalx,
        globaly: int) =
    var
        newMap: seq[seq[int]]
        px = 0
        py = 0
        found = false

    for y in countup(globaly-10, globaly+10):
        var row: seq[int]
        for x in countup(globalx-10, globalx+10):
            if x > 100 or x < 0 or y > 100 or y < 0:
                row.add(3)
            else:
                row.add(dungeon_map[y][x])

        newMap.add(row)

    hideOtherRooms(newMap)

    displayMap(newMap, player)
