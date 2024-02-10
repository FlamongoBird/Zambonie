import std/terminal
import std/re
import strutils
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



proc centerString(str: string, width: int): string =
    if str.len >= width:
        return str

    var spacing = width - str.len

    var right_side = floorDiv(spacing, 2)
    var left_side = spacing - right_side

    return repeat(" ", right_side) & str & repeat(" ", left_side)


proc centerStrings(strings: seq[string], width: int): seq[string] =
    var output = newSeq[string](0)

    for str in strings:
        output.add(centerString(str, width))
    
    return output


proc gameScreenDisplay*(dungeon: seq[string], log: seq[string]) =
    #[ Displays the game dungeon on one side and log on the other ]#
    var dungeon_balanced = centerStrings(dungeon, 50)
    var log_balanced = centerStrings(log, 30)

    var together = newSeq[string](0)

    for index, item in dungeon_balanced:
        var log_item = ""
        if index < log_balanced.len:
            log_item = log_balanced[index]
        together.add(item & log_item)
    
    display(together)

proc moveOn*()=
    setCursorPos(5, terminalHeight()-1)
    echo "Press Space to Continue"
    while true:
        var key = getch()
        if key == ' ':
            break
    
    eraseScreen()
