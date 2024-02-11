import std/heapqueue
import tables
import std/sequtils

#[
    enemies just use greedy best first
]#


type Location = object
    loc: (int, int)
    priority: int

proc `<`(a, b: Location): bool = a.priority < b.priority

proc validNeighbor(x: int, y: int, graph: seq[seq[int]]): (int, int) =
    try:
        if graph[y][x] == 0:
            return (x, y)
    except:
        return (-1, -1)


proc getNeighbors(graph: seq[seq[int]], node: (int, int)): seq[(int, int)] =
    var neighbors = newSeq[(int, int)]()

    neighbors.add(validNeighbor(node[0]+1, node[1], graph))
    neighbors.add(validNeighbor(node[0]-1, node[1], graph))
    neighbors.add(validNeighbor(node[0], node[1]+1, graph))
    neighbors.add(validNeighbor(node[0], node[1]-1, graph))
 
    return neighbors

proc heuristic(a, b: (int, int)): int =
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


proc recoverPath(path: Table[(int, int), (int, int)], current, start: (int, int)): seq[(int, int)] =
    var recovered = newSeq[(int, int)]()
    recovered.add(current)

    var c = current

    while true:
        c = path[c]
        if c[0] == start[0] and c[1] == start[1]:
            break
        else:
            recovered.add(c)

    return recovered

proc findPathGreedy*(graph: seq[seq[int]], start: (int, int), goal: (int, int)): seq[(int, int)] =
    var queue: HeapQueue[Location]
    var visited = newSeq[(int, int)]()
    var path = initTable[(int, int), (int, int)]()

    # mark start as visited
    visited.add(start)

    # add start to queue
    queue.push(Location(loc: start, priority: 0))


    while queue.len > 0:
        # remove current node
        var current_node = queue[0]
        queue.del(0)

        # check neighbors
        for n in getNeighbors(graph, current_node.loc):
            if visited.find(n) == -1:
                # check if goal
                if n[0] == goal[0] and n[1] == goal[1]:
                    return recoverPath(path, current_node.loc, start)
                else:
                    # push to que with priority
                    visited.add(n)
                    queue.push(Location(loc: n, priority: heuristic(n, goal)))
                    path[n] = current_node.loc
    return @[]


