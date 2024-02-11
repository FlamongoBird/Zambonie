import dungeon/dungeon
import std/terminal
import player/player
import game/[die, title, treasure]
import terminal/terminal
import enemies/[enemy, enemy_movement]

#[ Old stuff ignore ]#
#var message = @["Hello Jonathan!", "How's it going"]
#display(message)

# Does some stuff before the start of the game
#echo "\x1b[?25l"
#eraseScreen()

#showTitle()

var
    dungeon_map = generateDungeon(10, 10)
    x = 5
    y = 5
    player_data = newPlayer()



discard spawnItem(5, dungeon_map)

while true:
    dungeon_map[y][x] = 69
    printDungeonMap(dungeon_map, playerStats(player_data))
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
        of 't':
            #hurtPlayer(player_data)
            var enemy = generateGoblin(dungeon_map)
            var path = findPathGreedy(dungeon_map, enemyLoc(enemy), (x, y))
            for loc in path:
                dungeon_map[loc[0]][loc[1]] = 2


        of '1':
            showPlayerInventory(player_data)
        else:
            # TODO: actually do something here
            continue
    
    var spot = dungeon_map[temp_y+y][temp_x+x]

    var cont = false

    case spot:
        of 0:
            cont = true
        of 5:
            var treasure = openTreasure()
            givePlayerTreasure(player_data, treasure)
            cont = true
        of 11:
            cont = true
        else:
            discard

    if cont:
        x += temp_x
        y += temp_y


    if playerDead(player_data):
        die()


# does some stuff after the game (if the while loop ends)
echo "\x1b[?25h"