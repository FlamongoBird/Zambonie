import random

randomize()

type
  Tile* = char
  Direction* {.pure.} = enum
    North, South, West, East
  Rect* = object
    x, y, width, height: int
  BigD* = ref object
    width*, height*: int
    tiles*: seq[Tile]
    rooms*: seq[Rect]
    exits*: seq[Rect]

const
  Unused*: Tile = ' '
  Floor*: Tile = '.'
  Corridor*: Tile = ','
  Wall*: Tile = '#'
  ClosedDoor*: Tile = '+'
  OpenDoor*: Tile = '-'
  UpStairs*: Tile = '<'
  DownStairs*: Tile = '>'
  DirectionCount = 4

proc randomInt(exclusiveMax: int): int =
  rand(exclusiveMax - 1)

proc randomInt(min, max: int): int =
  rand(min..max)

proc randomBool(probability: float = 0.5): bool =
  rand(1.0) < probability

proc newDungeon*(width, height: int): BigD =
  new result
  result.width = width
  result.height = height
  result.tiles = newSeq[Tile](width * height)
  for i in 0..<result.tiles.len:
    result.tiles[i] = Unused
  result.rooms = @[]
  result.exits = @[]

proc getTile*(d: BigD, x, y: int): Tile =
  if x < 0 or y < 0 or x >= d.width or y >= d.height:
    return Unused
  d.tiles[x + y * d.width]

proc setTile(d: BigD, x, y: int, tile: Tile) =
  if x >= 0 and x < d.width and y >= 0 and y < d.height:
    d.tiles[x + y * d.width] = tile

proc placeRect(d: BigD, rect: Rect, tile: Tile): bool =
  if rect.x < 1 or rect.y < 1 or rect.x + rect.width > d.width - 1 or rect.y +
      rect.height > d.height - 1:
    return false

  for y in rect.y..<rect.y + rect.height:
    for x in rect.x..<rect.x + rect.width:
      if d.getTile(x, y) != Unused:
        return false

  for y in (rect.y - 1)..(rect.y + rect.height):
    for x in (rect.x - 1)..(rect.x + rect.width):
      if x == rect.x - 1 or y == rect.y - 1 or x == rect.x + rect.width or y ==
          rect.y + rect.height:
        d.setTile(x, y, Wall)
      else:
        d.setTile(x, y, tile)

  true

proc makeCorridor(d: BigD, x, y: int, dir: Direction): bool =
  const
    minCorridorLength = 3
    maxCorridorLength = 6

  var corridor = Rect(x: x, y: y, width: 0, height: 0)

  if randomBool():
    corridor.width = randomInt(minCorridorLength, maxCorridorLength)
    corridor.height = 1
    case dir:
    of North:
      corridor.y = y - 1
      if randomBool():
        corridor.x = x - corridor.width + 1
    of South:
      corridor.y = y + 1
      if randomBool():
        corridor.x = x - corridor.width + 1
    of West:
      corridor.x = x - corridor.width
    of East:
      corridor.x = x + 1
  else:
    corridor.height = randomInt(minCorridorLength, maxCorridorLength)
    corridor.width = 1
    case dir:
    of North:
      corridor.y = y - corridor.height
    of South:
      corridor.y = y + 1
    of West:
      corridor.x = x - 1
      if randomBool():
        corridor.y = y - corridor.height + 1
    of East:
      corridor.x = x + 1
      if randomBool():
        corridor.y = y - corridor.height + 1

  if d.placeRect(corridor, Corridor):
    if dir != South and corridor.width != 1:
      d.exits.add(Rect(x: corridor.x, y: corridor.y - 1, width: corridor.width, height: 1))
    if dir != North and corridor.width != 1:
      d.exits.add(Rect(x: corridor.x, y: corridor.y + corridor.height,
          width: corridor.width, height: 1))
    if dir != East and corridor.height != 1:
      d.exits.add(Rect(x: corridor.x - 1, y: corridor.y, width: 1,
          height: corridor.height))
    if dir != West and corridor.height != 1:
      d.exits.add(Rect(x: corridor.x + corridor.width, y: corridor.y, width: 1,
          height: corridor.height))
    true
  else:
    false

proc makeRoom(d: BigD, x, y: int, dir: Direction,
    firstRoom: bool = false): bool =
  const
    minRoomSize = 5
    maxRoomSize = 10

  var room: Rect
  room.width = randomInt(minRoomSize, maxRoomSize)
  room.height = randomInt(minRoomSize, maxRoomSize)

  case dir:
  of North:
    room.x = x - room.width div 2
    room.y = y - room.height
  of South:
    room.x = x - room.width div 2
    room.y = y + 1
  of West:
    room.x = x - room.width
    room.y = y - room.height div 2
  of East:
    room.x = x + 1
    room.y = y - room.height div 2

  if d.placeRect(room, Floor):
    d.rooms.add(room)
    if dir != South or firstRoom:
      d.exits.add(Rect(x: room.x, y: room.y - 1, width: room.width, height: 1))
    if dir != North or firstRoom:
      d.exits.add(Rect(x: room.x, y: room.y + room.height, width: room.width, height: 1))
    if dir != East or firstRoom:
      d.exits.add(Rect(x: room.x - 1, y: room.y, width: 1, height: room.height))
    if dir != West or firstRoom:
      d.exits.add(Rect(x: room.x + room.width, y: room.y, width: 1,
          height: room.height))
    true
  else:
    false

proc createFeature(d: BigD, x, y: int, dir: Direction): bool =
  const roomChance = 50

  var dx, dy = 0
  case dir:
  of North: dy = 1
  of South: dy = -1
  of West: dx = 1
  of East: dx = -1

  if d.getTile(x + dx, y + dy) notin {Floor, Corridor}:
    return false

  if randomInt(100) < roomChance:
    if d.makeRoom(x, y, dir):
      d.setTile(x, y, ClosedDoor)
      true
    else:
      false
  else:
    if d.makeCorridor(x, y, dir):
      if d.getTile(x + dx, y + dy) == Floor:
        d.setTile(x, y, ClosedDoor)
      else:
        d.setTile(x, y, Corridor)
      true
    else:
      false

proc createFeature(d: BigD): bool =
  for _ in 0..999:
    if d.exits.len == 0:
      break
    let r = randomInt(d.exits.len)
    let exit = d.exits[r]
    let x = randomInt(exit.x, exit.x + exit.width - 1)
    let y = randomInt(exit.y, exit.y + exit.height - 1)

    for j in 0..<DirectionCount:
      let dir = Direction(j)
      if d.createFeature(x, y, dir):
        d.exits.del(r)
        return true
  false

proc placeObject(d: BigD, tile: Tile): bool =
  if d.rooms.len == 0:
    return false

  let r = randomInt(d.rooms.len)
  let room = d.rooms[r]
  let x = randomInt(room.x + 1, room.x + room.width - 2)
  let y = randomInt(room.y + 1, room.y + room.height - 2)

  if d.getTile(x, y) == Floor:
    d.setTile(x, y, tile)
    d.rooms.del(r)
    true
  else:
    false

proc generate*(d: BigD, maxFeatures: int) =
  let centerX = d.width div 2
  let centerY = d.height div 2
  let dir = Direction(randomInt(4))
  if not d.makeRoom(centerX, centerY, dir, true):
    echo "Unable to place the first room."
    return

  for i in 1..<maxFeatures:
    if not d.createFeature():
      echo "Unable to place more features (placed ", i, ")."
      break

  if not d.placeObject(UpStairs):
    echo "Unable to place up stairs."
  if not d.placeObject(DownStairs):
    echo "Unable to place down stairs."

  for i in 0..<d.tiles.len:
    if d.tiles[i] == Unused:
      d.tiles[i] = '.'
    elif d.tiles[i] in {Floor, Corridor}:
      d.tiles[i] = ' '

proc print(d: BigD) =
  for y in 0..<d.height:
    var line = newString(d.width)
    for x in 0..<d.width:
      line[x] = d.getTile(x, y)
    echo line

when isMainModule:
  var d = newDungeon(100, 100)
  d.generate(100)
  d.print()
  echo "Press Enter to quit..."
  discard stdin.readLine()
