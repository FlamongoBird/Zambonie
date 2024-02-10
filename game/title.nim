import "../terminal/terminal"
import std/terminal
import strutils

const title = """

  _____   _    __  __ ____   ___  _   _ ___ _____ 
 |__  /  / \  |  \/  | __ ) / _ \| \ | |_ _| ____|
   / /  / _ \ | |\/| |  _ \| | | |  \| || ||  _|  
  / /_ / ___ \| |  | | |_) | |_| | |\  || || |___ 
 /____/_/   \_\_|  |_|____/ \___/|_| \_|___|_____|
                                                  
                                                  
                                                  
             Press Any Key to Continue
""".split("\n")


proc showTitle*() =
    display(title)
    discard getch()
    eraseScreen()