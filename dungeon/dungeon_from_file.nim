import std/strutils
import std/sequtils
import "../dungeon/dungeon_object"
import "../dungeon/dungeon_handler"


proc dungeonFromFile*(file: string): Dungeon =
    var raw = readFile(file)
    var lines = split(raw, "\n")

    var output: seq[seq[int]]

    for line in lines:
        var row: seq[int]
        var ripped = toSeq(line.items)
        for str in ripped:
            case str:
                of '#':
                    row.add(1)
                of '-':
                    row.add(4)
                of 'D':
                    row.add(10)
                of '.':
                    row.add(2)
                else:
                    row.add(0)
        output.add(row)

    echo "Getting ready to return" 
    return Dungeon(
        dungeon_map: output,
        rooms: splitIntoRooms(output),
        current_room: 0,
        links: @[],
    )

