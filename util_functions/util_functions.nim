import strutils

proc buildBar*(percent: float, length: int): string =
    var color = ""
    if percent >= 0.6:
        color = "\x1b[48;2;0;255;0m"
    elif percent >= 0.3:
        color = "\x1b[48;2;240;100;0m"
    else:
        color = "\x1b[48;2;255;0;0m"

    var reset = "\x1b[0m"
    var background = "\x1b[48;2;50;50;50m"

    if percent >= 1:
        return color & repeat(" ", length) & reset
    elif percent <= 0:
        return background & repeat(" ", length) & reset

    var a = int(percent*float(length))
    return color & repeat(" ", a) & background & repeat(" ", length-a) & reset


proc joinSequences*(string1, string2: seq[string], connector: string): seq[string] =
    ## joins two strings

    var
        counter = 0
        output: seq[string]

    while true:
        var row = ""
        if string1.len > counter:
            row &= string1[counter]

        if string1.len > counter and string2.len > counter:
            row &= connector

        if string2.len > counter:
            row &= string2[counter]

        if string1.len < counter and string2.len < counter:
            break

        counter += 1
        output.add(row)

    return output


