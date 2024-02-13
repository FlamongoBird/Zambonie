

type
    Dungeon* = object
        dungeon_map*: seq[seq[int]]
        rooms*: seq[seq[seq[int]]]
        current_room*: int
        links*: seq[(int, int, int)]
        