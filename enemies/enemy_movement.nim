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

proc getNeighbor(x: int, y: int, graph: seq[seq[int]]): (int, int) =
    if y > 0 and y < graph.len and x > 0 and x < graph[y].len:
        return (x, y)
    else:
        return (-1, -1)

proc getNeighbors(graph: seq[seq[int]], current_node: (int, int)): seq[(int, int)] =
    var neighbors = newSeq[(int, int)]()

    var n1 = getNeighbor(current_node[0], current_node[1]+1, graph)
    if n1 != (-1, -1):
        neighbors.add(n1)

    var n2 = getNeighbor(current_node[0], current_node[1]-1, graph)
    if n2 != (-1, -1):
        neighbors.add(n2)

    var n3 = getNeighbor(current_node[0]+1, current_node[1], graph)
    if n3 != (-1, -1):
        neighbors.add(n3)

    var n4 = getNeighbor(current_node[0]-1, current_node[1], graph)
    if n4 != (-1, -1):
        neighbors.add(n4)
 
    return neighbors

proc heuristic(a, b: (int, int)): int =
    return abs(a[0] - b[0]) + abs(a[1] - b[1])


proc findPathGreedy*(graph: seq[seq[int]], start: (int, int), goal: (int, int)) =
    var queue: HeapQueue[Location]
    var visited = initTable[(int, int), bool]()
    var path = newSeq[(int, int)]()

    # mark start as visited
    visited[start] = true

    # add start to queue
    queue.push(Location(loc: start, priority: 0))

    while queue.len > 0:
        echo "running"
        # remove current node
        var current_node = queue[0]
        queue.del(0)

        # check neighbors
        for n in getNeighbors(graph, current_node.loc):
            if not visited.haskey(n):
                echo "not visited"
                # check if goal
                if n[0] == goal[0] and n[1] == goal[1]:
                    echo "found"
                    break
                else:
                    echo "doing stuff"
                    # push to que with priority
                    visited[n] = true
                    queue.push(Location(loc: n, priority: heuristic(n, goal)))
                    path.add(current_node.loc)
            else:
                echo "visited"
    
    echo path


