import std/terminal
import std/re
import math

proc stringLength(str: string): int =
    #[ counts the characters in a string without counting 
    the ansi escape codes ]#
    var new_string = replace(str, re"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])", "")
    return new_string.len

proc longestString(strings: seq[string]): int =
    #[ Returns the longest string in the sequence ]#
    var longest = 0

    for str in strings:
        var length = stringLength(str)
        if length > longest:
            longest = length
    
    return longest


proc display*(message: seq[string]) =
    let term_size = terminalSize()

    var x = floorDiv(term_size.w, 2) - floorDiv(longestString(message), 2)
    var y = floorDiv(term_size.h, 2) - floorDiv(message.len, 2)


    for index, line in message:
        setCursorPos(x, (y+index))
        echo line
