import dungeon/[dungeon_handler, dungeon_from_file, dungeon_generator]
import std/terminal
import player/[player, player_attacks]
import game/[die, title, treasure]
import terminal/terminal
import enemies/[enemy, enemy_movement]
import std/strformat
#import save/[save, restore]


# Does some stuff before the start of the game
echo "\x1b[?25l"
eraseScreen()

#showTitle()

var
    dungeon = generateDungeon(
        width=100,
        height=100,
        max_rooms=40,
    )
    x: int
    y: int
    player_data: Player
    enemies: seq[Enemy]
    dir = "none"
    skibidi = false
    saved: int

#[
if saveExists():
    var game_data = restoreGameData()
    dungeon = game_data.dungeon
    x = game_data.x
    y = game_data.y
    player_data = game_data.player
    enemies = game_data.enemies
]#
#else:
#dungeon_map = generateDungeon(10, 10)

#dungeon = dungeonFromFile("./dungeon/hardcoded_maps/m1.txt")
player_data = newPlayer()
enemies = newSeq[Enemy]()

#dungeon_map = dungeon.rooms[dungeon.current_room]

#discard spawnItem(5, dungeon_map)

dungeon.current_room = 5

var dungeon_map = dungeon.rooms[dungeon.current_room].room

var cords = findSpawn(dungeon_map)
x = cords[0]
y = cords[1]

while true:
    if skibidi:
        saved = dungeon_map[y][x]
    
    dungeon_map[y][x] = 69

    # display enemy
    for e in enemies:
        var loc = enemyLoc(e)
        dungeon_map[loc[1]][loc[0]] = enemySymbol(e)

    printDungeonMap(dungeon_map, playerStats(player_data))
    echo &"Current Room: {dungeon.current_room}"

    if skibidi:
        dungeon_map[y][x] = saved
        skibidi = false
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
            #saveGameData(player_data, dungeon, enemies, x, y)
            discard
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
            var
                room: Room
                cords: (int, int)

            if dungeon.enteringRoom(x, y):
                # we get verbose
                popup(&"Room Link: {dungeon.rooms[dungeon.current_room].connection}")
                moveOn()
                dungeon.current_room = dungeon.rooms[dungeon.current_room].connection.to_id
                room = dungeon.rooms[dungeon.current_room] 
                cords = adjustCords(room, room.entry)
            else:
                popup(&"Exiting Room Link: {dungeon.rooms[dungeon.current_room].connection}")
                moveOn()
                dungeon.current_room = dungeon.rooms[dungeon.current_room].connection.from_id
                room = dungeon.rooms[dungeon.current_room] 
                cords = adjustCords(room, room.exit)

            x = cords[0]
            y = cords[1]
            dungeon_map = room.room
            

            # if entering a room, set dungeon map to new room
            # and then remove the drawn connection
            # update current room
            # if exiting a room, draw connection between room
            # and store connection
            # cut map to display map and display
            # set current room to -1 (triggers map cut)
        of 4:
            # walk but don't erase
            cont = true
            skibidi = true
        else:
            skibidi = true

    if cont:
        x += temp_x
        y += temp_y
    

    for i, e in enemies:
        if enemyInRange(e, x, y):
            var path = findPathGreedy(dungeon_map, enemyLoc(e), (x, y))
            if path.len > 0:
                moveEnemy(path[^1], enemies[i]) # can't be a lent enemy for this one
        elif enemyInAttackRange(e, x, y):
            enemyAttack(enemies[i], player_data)

    if playerDead(player_data):
        die()


# does some stuff after the game (if the while loop ends)
echo "\x1b[?25h"
echo "Goodbye!\n"