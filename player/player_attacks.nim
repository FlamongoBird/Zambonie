import "../player/player"
import "../enemies/enemy"
import "../terminal/terminal"
import "../colors/colors"
import "../colors/color"
import "../dungeon/dungeon"

proc distanceToEnemy(x, y: int, enemy: Enemy): int =
    return abs(x - enemy.x) + abs(y - enemy.y)

proc playerAttemptAttack*(dungeon: var seq[seq[int]], player: var Player, enemies: var seq[Enemy], x: int, y:int) =
    var in_range = newSeq[Enemy]()
    for e in enemies:
        if distanceToEnemy(x, y, e) <= player.weapon.r:
            in_range.add(e)
    
    if in_range.len == 0:
        popup(color(NEUTRAL_FG) & "No enemies in range." & COLOR_RESET)
        moveOn()
    else:
        # highlight enemies
        for e in in_range:
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

        
        printDungeonMap(dungeon, playerStats(player))
        helperText("H/L - Select Enemy | <space> - Attack | c - Cancel")
        moveOn()

        for loc in highlighted:
            dungeon[loc[1]][loc[0]] = 0
        


    