import std/terminal
import std/re
import strutils
import math
import os


proc stringLength(str: string): int =
    #[ counts the characters in a string without counting
    the ansi escape codes ]#
    var new_string = replace(str, re"\x1B(?:[@-Z\\-_]|\[[0-?]*[ -/]*[@-~])", "")
    return replace(new_string, re"(═)|(╔)|(╗)|(║)|(╝)|(╚)", " ").len


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


proc popup*(message: string) =
    let term_size = terminalSize()

    let message_len = stringLength(message)

    var x = floorDiv(term_size.w, 2) - floorDiv(message_len+4, 2)
    var y = floorDiv(term_size.h, 2) - 1

    setCursorPos(x, y)

    echo "╔" & repeat("═", message_len+2) & "╗"

    setCursorPos(x, y+1)

    echo "║ " & repeat(" ", message_len) & " ║"

    setCursorPos(x, y+2)

    echo "╚" & repeat("═", message_len+2) & "╝"

    setCursorPos(x+2, y+1)

    var skip = false

    for x in message:
        stdout.write(x)
        stdout.flushFile()
        if ord(x) < 32 or ord(x) > 126:
            skip = true
        if x == 'm' and skip:
            skip = false

        if not skip:
            sleep(25)







proc centerString*(str: string, width: int): string =
    if str.len >= width:
        return str

    var spacing = width - str.len

    var right_side = floorDiv(spacing, 2)
    var left_side = spacing - right_side

    return repeat(" ", right_side) & str & repeat(" ", left_side)


proc centerStrings*(strings: seq[string], width: int): seq[string] =
    var output = newSeq[string](0)

    for str in strings:
        output.add(centerString(str, width))

    return output



proc moveOn*() =
    setCursorPos(5, terminalHeight()-3)
    echo "Press Space to Continue"
    while true:
        var key = getch()
        if key == ' ':
            break

    eraseScreen()


proc helperText*(text: string) =
    setCursorPos(5, terminalHeight()-5)
    echo text
