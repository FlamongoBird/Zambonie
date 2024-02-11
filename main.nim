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
    enemy1 = generateGoblin(dungeon_map)



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
            var path = findPathGreedy(dungeon_map, enemyLoc(enemy1), (x, y))
            var loc = enemyLoc(enemy1)
            dungeon_map[loc[1]][loc[0]] = enemySymbol(enemy1)
            moveEnemy(path[^1], enemy1)
            loc = enemyLoc(enemy1)
            dungeon_map[loc[1]][loc[0]] = enemySymbol(enemy1)
            #for loc in path:
            #    dungeon_map[loc[1]][loc[0]] = 2


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