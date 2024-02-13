import std/strutils


proc dungeonFromFile(file: string): seq[seq[int]] =
    var raw = readFile(file)
    var lines = split(raw, "\n")

    var output: seq[seq[int]]

    for line in lines:
        var row: seq[int]
        var ripped = split(line, "")
        for str in ripped:
            case str:
                of "#":
                    row.add(1)
                of "-":
                    row.add(4)
                else:
                    row.add(0)
        output.add(row)
    
    return output

