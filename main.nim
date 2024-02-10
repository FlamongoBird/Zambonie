import dungeon/dungeon
import std/terminal

#var message = @["Hello Jonathan!", "How's it going"]
#display(message)



var
    dungeon_map = generateDungeon(10, 10)
    x = 5
    y = 5

while true:
    dungeon_map[y][x] = 69
    printDungeonMap(dungeon_map)
    var keypress = getch()
    
    case keypress:
        of 'e':
            break
        of 'h':
            x -= 1
        of 'j':
            y += 1
        of 'k':
            y -= 1
        of 'l':
            x += 1
        else:
            # TODO: actually do something here
            continue
