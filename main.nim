import dungeon/dungeon
import std/terminal
import player/[player, player_attacks]
import game/[die, title, treasure]
import terminal/terminal
import enemies/[enemy, enemy_movement]
import std/strformat
import save/[save, restore]

#[ Old stuff ignore ]#
#var message = @["Hello Jonathan!", "How's it going"]
#display(message)

# Does some stuff before the start of the game
echo "\x1b[?25l"
eraseScreen()

showTitle()

var
    dungeon_map = generateDungeon(10, 10)
    x = 5
    y = 5
    player_data = newPlayer()
    enemies = newSeq[Enemy]()



discard spawnItem(5, dungeon_map)

while true:
    dungeon_map[y][x] = 69

    # display enemy
    for e in enemies:
        var loc = enemyLoc(e)
        dungeon_map[loc[1]][loc[0]] = enemySymbol(e)

    printDungeonMap(dungeon_map, playerStats(player_data))
    dungeon_map[y][x] = 0

    # erase the enemy
    for e in enemies:
        var loc = enemyLoc(e)
        dungeon_map[loc[1]][loc[0]] = 0


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
        of 'a':
            playerAttemptAttack(dungeon_map, player_data, enemies, x, y)
            var dead = -1
            for i, e in enemies:
                if not enemyAlive(e):
                    popup(&"You killed {e.name}")
                    dead = i
            if dead != -1:
                enemies.del(dead)
        of 't':
            #enemies.add(generateGoblin(dungeon_map))
            saveGameData(player_data, dungeon_map, enemies)
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
        of 21:
            # dead Goblin
            lootEnemy(player_data, generateGoblin())
            cont = true
            discard
        else:
            discard

    if cont:
        x += temp_x
        y += temp_y
    

    for i, e in enemies:
        if enemyInRange(e, x, y):
            var path = findPathGreedy(dungeon_map, enemyLoc(e), (x, y))
            moveEnemy(path[^1], enemies[i]) # can't be a lent enemy for this one
        elif enemyInAttackRange(e, x, y):
            enemyAttack(enemies[i], player_data)

    if playerDead(player_data):
        die()


# does some stuff after the game (if the while loop ends)
echo "\x1b[?25h"