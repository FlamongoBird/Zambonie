import dungeon/dungeon
import std/terminal

#var message = @["Hello Jonathan!", "How's it going"]
#display(message)



var
    dungeon_map = generateDungeon(10, 10)
    x = 5
    y = 5

while true:
    #eraseScreen()
    dungeon_map[y][x] = 69
    printDungeonMap(dungeon_map)
    dungeon_map[y][x] = 0
    var keypress = getch()

    var temp_x = 0
    var temp_y = 0
    
    case keypress:
        of 'e':
            break
        of 'h':
            temp_x = -1
        of 'j':
            temp_y = 1
        of 'k':
            temp_y = -1
        of 'l':
            temp_x = 1
        else:
            # TODO: actually do something here
            continue
    
    var spot = dungeon_map[temp_y+y][temp_x+x]

    case spot:
        of 0:
            x += temp_x
            y += temp_y
        else:
            continue


