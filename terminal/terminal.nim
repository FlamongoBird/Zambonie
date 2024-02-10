import std/terminal
import std/re
import math

proc stringLength(str: string): int =
    #[ counts the characters in a string without counting 
    the ansi escape codes ]#
    var new_string = replace(str, re"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])", "")
    return new_string.len


proc display*(message: string) =
    let term_size = terminalSize()

    var x = floorDiv(term_size.w, 2) - floorDiv(stringLength(message), 2)
    var y = floorDiv(term_size.h, 2) - 1

    setCursorPos(x, y)
    echo message