import std/random
import "../dungeon/portedv"

randomize()

#[
const
    ROOM_MIN = 8
    ROOM_MAX = 15
    MIN_DIST = 3
]#

type
    Connection* = object
        from_id*: int
        to_id*: int

    Room* = object
        start*: array[2, int]
        room*: seq[seq[int]]
        width*: int
        height*: int
        connection*: Connection
        entry*: array[2, int]
        exit*: array[2, int]

    Dungeon* = object
        dungeon*: seq[seq[int]]
        #rooms*: seq[Room]
        width*: int
        height*: int
        #current_room*: int = 0


const
    EMPTY_CONNECTION* = Connection(
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
#[

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


proc genRoomDoor(room: Room): array[2, int] =
    var t = rand(3)
    case t:
        of 0:
            result = [0, (rand(len(room.room)-3)+1)]
        of 1:
            result = [len(room.room[0])-1, (rand(len(room.room)-3)+1)]
        of 2:
            result = [(rand(len(room.room[0])-3)+1), 0]
        else:
            result = [(rand(len(room.room[0])-3)+1), len(room.room)-1]


proc drawDoors(room: var Room) =
    room.entry = genRoomDoor(room)
    room.exit = genRoomDoor(room)
    room.room[room.entry[1]][room.entry[0]] = 10
    room.room[room.exit[1]][room.exit[0]] = 9

proc generateRoom(dungeon: var Dungeon) =
    var
        width = rand(ROOM_MAX-ROOM_MIN) + ROOM_MIN
        height = rand(ROOM_MAX-ROOM_MIN) + ROOM_MIN
        start = [rand(dungeon.width - width), rand(dungeon.height - height)]
        room = Room(
            start: start,
            room: buildEmpty(width, height, 1),
            width: width,
            height: height,
            entry: [0, 0],
            exit: [0, 0],
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

    for room in dungeon.rooms:
        drawRoom(dungeon, room)

    # link the rooms

    var
        next: int
        prev = len(dungeon.rooms)-1
        available = newSeq[int]()

    for x in dungeon.rooms:
        available.add(dungeon.rooms.find(x))

    for index, room in dungeon.rooms:
        if len(available) > 1:
            while true:
                # hyper efficient
                next = rand(len(available)-1)
                if available[next] != prev:
                    break

            dungeon.rooms[index].connection = Connection(
                from_id:prev,
                to_id:available[next]
            )
            available.delete(next)
            prev = index

    dungeon.rooms[^1].connection.from_id = prev


    return dungeon
]#

proc generateDungeon*(width, height, max_rooms: int): Dungeon =
    var d = newDungeon(width, height)
    d.generate(max_rooms)


    # Skibidi Toilet Activities
    # aka I'm going to change the type from a BigD to a Dungeon

    var dungeon = Dungeon(
        dungeon: buildEmpty(100, 100),
        width: 100,
        height: 100,
    )


    for y in 0..<d.height:
        for x in 0..<d.width:
            var tile = d.getTile(x, y)

            var newVal: int

            case tile:
            of Unused:
                newVal = 0
            of Floor:
                newVal = 3
            of Corridor:
                newVal = 4
            of Wall:
                newVal = 1
            of ClosedDoor:
                newVal = 7
            of OpenDoor:
                newVal = 8
            of UpStairs:
                newVal = 9
            of DownStairs:
                newVal = 9
            else:
                newVal = 0

            dungeon.dungeon[y][x] = newVal


    return dungeon
