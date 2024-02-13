import dungeon/[dungeon_handler, dungeon_from_file, dungeon_generator, dungeon_object]
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
    dungeon: Dungeon
    dungeon_map: seq[seq[int]]
    x: int
    y: int
    player_data: Player
    enemies: seq[Enemy]
    dir = "none"
    skibidi = 0

if saveExists():
    var game_data = restoreGameData()
    dungeon = game_data.dungeon
    dungeon_map = dungeon.dungeon_map
    x = game_data.x
    y = game_data.y
    player_data = game_data.player
    enemies = game_data.enemies

else:
    #dungeon_map = generateDungeon(10, 10)
    dungeon = dungeonFromFile("./dungeon/hardcoded_maps/m1.txt")
    dungeon_map = dungeon.dungeon_map
    x = 5
    y = 5
    player_data = newPlayer()
    enemies = newSeq[Enemy]()



#discard spawnItem(5, dungeon_map)

while true:
    dungeon_map[y][x] = 69

    # display enemy
    for e in enemies:
        var loc = enemyLoc(e)
        dungeon_map[loc[1]][loc[0]] = enemySymbol(e)

    printDungeonMap(dungeon_map, playerStats(player_data))

    if skibidi != 0:
        dungeon_map[y][x] = skibidi
        skibidi = 0
    else:
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
            dir = "left"
        of 'j':
            temp_y = 1
            dir = "down"
        of 'k':
            temp_y = -1
            dir = "up"
        of 'l':
            temp_x = 1
            dir = "right"
        of 'a':
            playerAttemptAttack(dungeon_map, player_data, enemies, x, y)
            var dead = -1
            for i, e in enemies:
                if not enemyAlive(e):
                    popup(&"You killed {e.name}")
                    dead = i
            if dead != -1:
                enemies.del(dead)
        of 'x':
            enemies.add(generateGoblin(dungeon_map))
        of 't':
            saveGameData(player_data, dungeon, enemies, x, y)
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
        of 10:
            # move through door
            if dir == "up":
                y -= 1
            elif dir == "down":
                y += 1
            elif dir == "right":
                x += 1 
            else:
                x -= 1
            cont = true
        of 4:
            # walk but don't erase
            cont = true
            skibidi = 4
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