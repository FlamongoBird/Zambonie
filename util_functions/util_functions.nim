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


