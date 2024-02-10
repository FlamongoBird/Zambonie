import "../terminal/terminal"
import std/terminal

const title = @["Boogie Woogie! Less GO!!!", "", "Press Any Key to Continue"]

proc showTitle*() =
    display(title)
    discard getch()