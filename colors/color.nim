import std/strformat
import "../colors/colors"

proc color*(color: array[3, int]): string =
    return &"\x1b[38;2;{color[0]};{color[1]};{color[2]}m"

proc color*(color: array[3, int], bg: bool): string =
    if bg:
        return &"\x1b[48;2;{color[0]};{color[1]};{color[2]}m"
    else:
        return color(color)

proc colorString*(str: string, c: array[3, int]): string =
    return color(c) & str & "\x1b[0m"

proc colorString*(str: string, c: string): string =
    return c & str & "\x1b[0m"