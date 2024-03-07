import std/random

randomize()

const
    ROOM_MIN = 3
    ROOM_MAX = 15
    MIN_DIST = 3

type
    Connection* = object
        from_id*: int
        to_id*: int

    Room* = object
        start*: (int, int)
        room*: seq[seq[int]]
        width*: int
        height*: int
        connection*: Connection
        entry*: (int, int)
        exit*: (int, int)

    Dungeon* = object
        dungeon*: seq[seq[int]]
        rooms*: seq[Room]
        width*: int
        height*: int
        current_room*: int = 0


const
    EMPTY_CONNECTION = Connection(
        from_id: 0,
        to_id: 0
    )


proc buildEmpty(width, height: int): seq[seq[int]] =
    var base: seq[seq[int]]
    for y in countup(0, height):
        var row: seq[int]
        for x in countup(0, width):
            row.add(0)
        base.add(row)
    return base

proc buildEmpty(width, height, border: int): seq[seq[int]] =
    var base: seq[seq[int]]
    for y in countup(0, height-1):
        var row: seq[int]
        for x in countup(0, width-1):
            if x == 0 or x == width-1 or y == 0 or y == height-1:
                row.add(border)
            else:
                row.add(0)
        base.add(row)
    return base

proc overlaps(r1: Room, r2: Room): bool =
    #[ Checks if two rooms intersect ]#

    #r1 bottom < r2 top
    if r1.start[1]+r1.height+MIN_DIST < r2.start[1]-MIN_DIST:
        return false

    #r1 top > r2 bottom
    if r1.start[1]-MIN_DIST > r2.start[1]+r2.height+MIN_DIST:
        return false

    #r1 right < r2 left
    if r1.start[0]+r1.width+MIN_DIST < r2.start[0]-MIN_DIST:
        return false

    #r1 left > r2 right
    if r1.start[0]-MIN_DIST > r2.start[0]+r2.width+MIN_DIST:
        return false
    
    return true


proc roomOverlapping(dungeon: Dungeon, room: Room): bool =
    for r in dungeon.rooms:
        if room.overlaps(r):
            return true
    return false


proc genRoomDoor(room: Room): (int, int) =
    var t = rand(3)
    case t:
        of 0:
            return (0, rand(len(room.room)-1))
        of 1:
            return (len(room.room[0])-1, rand(len(room.room)-1))
        of 2:
            return (rand(len(room.room[0])-1), 0)
        else:
            return (rand(len(room.room[0])-1), len(room.room)-1)


proc drawDoors(room: var Room) =
    room.entry = genRoomDoor(room)
    room.exit = genRoomDoor(room)
    room.room[room.entry[1]][room.entry[0]] = 10
    room.room[room.exit[1]][room.exit[0]] = 10

proc generateRoom(dungeon: var Dungeon) =
    var
        width = rand(ROOM_MAX-ROOM_MIN) + ROOM_MIN
        height = rand(ROOM_MAX-ROOM_MIN) + ROOM_MIN
        start = (rand(dungeon.width - width), rand(dungeon.height - height))
        room = Room(
            start: start,
            room: buildEmpty(width, height, 1),
            width: width,
            height: height,
            entry: (0, 0),
            exit: (0, 0),
            connection: Connection(
                from_id: 0,
                to_id: 0
            )
        )
    
    if not roomOverlapping(dungeon, room):
        room.drawDoors()
        dungeon.rooms.add(room)


proc drawRoom(dungeon: var Dungeon, room: Room) =
    for y in countup(room.start[1], room.start[1]+room.height):
        for x in countup(room.start[0], room.start[0]+room.width):
            dungeon.dungeon[y][x] = 0

proc distanceBetween(l1, l2: (int, int)): int =
    return abs(l1[0] - l2[0]) + abs(l1[1] + l2[1])

proc findClosestRoom(dungeon: var Dungeon, room: Room): int =
    var closest = dungeon.rooms[0]
    var i = 0
    for index, item in dungeon.rooms:
        var r = dungeon.rooms[index]
        if room == closest:
            closest = r
            i = index
            continue
        if room.connection != EMPTY_CONNECTION:
            continue
        if distanceBetween(r.start, room.start) < distanceBetween(closest.start, room.start):
            closest = r
            i = index
    return i



proc connectRooms(id1, id2: int, dungeon: var Dungeon): Connection =
    var r1 = dungeon.rooms[id1]
    r1.connection.from_id = id1
    r1.connection.to_id = id2
    return r1.connection


proc generateDungeon*(width, height, max_rooms: int): Dungeon =
    var
        dungeon = Dungeon(
            dungeon: buildEmpty(width, height),
            rooms: newSeq[Room](),
            width: width,
            height: height
        )
        max_attempts = max_rooms * 20 # dunno what a good number here is
        attempts = 0

    while attempts < max_attempts and dungeon.rooms.len < max_rooms:
        attempts += 1
        generateRoom(dungeon)


    for i, r in dungeon.rooms:
        var r1 = i
        var r2 = findClosestRoom(dungeon, dungeon.rooms[i])
        dungeon.rooms[i].connection = connectRooms(r1, r2, dungeon)


    for room in dungeon.rooms:
        drawRoom(dungeon, room)

    return dungeon