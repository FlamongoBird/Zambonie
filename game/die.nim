import "../terminal/terminal"
import std/terminal

const death_message = @["Loool get rekked noob"]


proc die*() =
    eraseScreen()
    display(death_message)
    echo "\x1b[?25h"
    quit()