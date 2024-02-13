import "../player/player"
import "../enemies/enemy"
import "../terminal/terminal"
import "../colors/colors"
import "../colors/color"
import "../dungeon/dungeon_handler"
import "../battle/battle"
import std/terminal
import std/strformat

proc distanceToEnemy(x, y: int, enemy: Enemy): int =
    return abs(x - enemy.x) + abs(y - enemy.y)


proc playerAttack*(player: var Player, enemy: var Enemy) =
    if enemyDeflectAttack(enemy):
        popup(&"{enemy.name} {color(BAD_FG)}deflected{COLOR_RESET} your attack")
    else:
        var dmg = calcDamage(player.weapon, enemy.armor)
        popup(&"You deal +{color(GOOD_FG)}{dmg}{COLOR_RESET}dmg to {enemy.name}")
        hurtEnemy(enemy, dmg)
    moveOn()


proc playerAttemptAttack*(dungeon: var seq[seq[int]], player: var Player, enemies: var seq[Enemy], x: int, y:int) =
    # sequence of indexes of enemies... fyi
    var in_range = newSeq[int]()
    for i, e in enemies:
        if distanceToEnemy(x, y, e) <= player.weapon.r:
            in_range.add(i)
    
    if in_range.len == 0:
        popup(color(NEUTRAL_FG) & "No enemies in range." & COLOR_RESET)
        moveOn()
    else:
        # highlight enemies
        for index in in_range:
            var e = enemies[index]
            # the highlighted version of an enemy is always it's
            # symbol plus 10, ie. un highlighted is 11-20 and highlighted
            # is 21-30
            dungeon[e.y][e.x] = enemySymbol(e) + 10
        
        # highlight all squares in range

        var highlighted = newSeq[(int, int)]()

        for y_r in countup(y-player.weapon.r, y+player.weapon.r):
            for x_r in countup(x-player.weapon.r, x+player.weapon.r):
                if dungeon[y_r][x_r] == 0:
                    dungeon[y_r][x_r] = 3
                    highlighted.add((x_r, y_r))

        
        helperText("H/L - Select Enemy | <space> - Attack | C - Cancel")

        var selected = 0

        while true:
            var s_e = enemies[in_range[selected]]
            dungeon[s_e.y][s_e.x] = enemySymbol(s_e)+20
            dungeon[y][x] = 69
            printDungeonMap(dungeon, playerStats(player))
            dungeon[s_e.y][s_e.x] = enemySymbol(s_e)+10
            var key = getch()
            case key:
                of 'h':
                    selected += 1
                of 'l':
                    selected -= 1
                of ' ':
                    playerAttack(player, enemies[in_range[selected]])
                    break
                of 'c':
                    break
                else:
                    discard
            
            if selected > len(in_range):
                selected = 0
            elif selected < 0:
                selected = len(in_range)-1


        for loc in highlighted:
            dungeon[loc[1]][loc[0]] = 0
        
        eraseScreen()

        printDungeonMap(dungeon, playerStats(player))
        


    