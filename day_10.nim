from utils import withStream
from streams import lines
import sequtils
import strutils
import sugar

const TEST_INPUT = """
..F7.
.FJ|.
SJ.L7
|F--J
LJ...
"""

const TEST_INPUT_2 = """
.....
.S-7.
.|.|.
.L-J.
.....
"""

const TEST_INPUT_3 = """
7-F7-
.FJ|7
SJLL7
|F--J
LJ.LJ
"""

type
    Point = object
        y, x: int

proc `==`(a, b: Point): bool =
    return a.y == b.y and a.x == b.x

proc `$`(p: Point): string =
    return "[" & $p.y & ", " & $p.x & "]"

proc inBounds(curPos: Point, map: seq[seq[char]]): bool =
    return curPos.y >= 0 and curPos.y < map.len and curPos.x >= 0 and curPos.x < map[0].len

proc findStartingOptions(curPos: Point, map: seq[seq[char]]): seq[Point] =
    var options = newSeq[Point]()
    var neighbors = @[Point(y: curPos.y - 1, x: curPos.x), Point(y: curPos.y + 1, x: curPos.x), Point(y: curPos.y, x: curPos.x + 1), Point(y: curPos.y, x: curPos.x - 1)]
    for i, neighbor in neighbors.pairs:
        if not inBounds(neighbor, map):
            continue
        let neighborChar = map[neighbor.y][neighbor.x]
        if i == 0: # north
            # | 7 F
            if neighborChar in @['|', '7', 'F']:
                options.add(neighbor)
        elif i == 1: # south
            # | L J
            if neighborChar in @['|', 'L', 'J']:
                options.add(neighbor)
        elif i == 2: # east
            # - 7 J
            if neighborChar in @['-', '7', 'J']:
                options.add(neighbor)
        elif 1 == 3: # west 
            # - F L
            if neighborChar in @['-', 'F', 'L']:
                options.add(neighbor)
    return options


proc getNextSteps(curPos: Point, map: seq[seq[char]], path: seq[Point]): seq[Point] =
    let curChar = map[curPos.y][curPos.x]
    if curChar == 'S':
        var
            options = findStartingOptions(curPos, map)
            option = options[0]
        result.add(option)
    elif curChar == '|':
        # north and south
        let
            north = Point(y: max(0, curPos.y - 1), x: curPos.x)
            south = Point(y: min(map.len - 1, curPos.y + 1), x: curPos.x)
        if inBounds(north, map) and north notin path:
            result.add(north)
        if inBounds(south, map) and south notin path:
            result.add(south)
    elif curChar == '-':
        # east and west
        let
            east = Point(y: curPos.y, x: min(map[0].len - 1, curPos.x + 1))
            west = Point(y: curPos.y, x: max(0, curPos.x - 1))
        if inBounds(east, map) and east notin path:
            result.add(east)
        if inBounds(west, map) and west notin path:
            result.add(west)
    elif curChar == 'L':
        # north and east
        let
            north = Point(y: max(0, curPos.y - 1), x: curPos.x)
            east = Point(y: curPos.y, x: min(map[0].len - 1, curPos.x + 1))
        if inBounds(north, map) and north notin path:
            result.add(north)
        if inBounds(east, map) and east notin path:
            result.add(east)
    elif curChar == 'J':
        # north and west
        let
            north = Point(y: max(0, curPos.y - 1), x: curPos.x)
            west = Point(y: curPos.y, x: max(0, curPos.x - 1))
        if inBounds(north, map) and north notin path:
            result.add(north)
        if inBounds(west, map) and west notin path:
            result.add(west)
    elif curChar == '7':
        # south and west
        let
            south = Point(y: min(map.len - 1, curPos.y + 1), x: curPos.x)
            west = Point(y: curPos.y, x: max(0, curPos.x - 1))
        if inBounds(south, map) and south notin path:
            result.add(south)
        if inBounds(west, map) and west notin path:
            result.add(west)
    elif curChar == 'F':
        # south and east
        let
            south = Point(y: min(map.len - 1, curPos.y + 1), x: curPos.x)
            east = Point(y: curPos.y, x: min(map[0].len - 1, curPos.x + 1))
        if inBounds(south, map) and south notin path:
            result.add(south)
        if inBounds(east, map) and east notin path:
            result.add(east)
    else:
        return @[]


proc partOne() =
    let fn = "./input/day_10.txt"
    #let fn = TEST_INPUT
    #let fn = TEST_INPUT_2
    #let fn = TEST_INPUT_3

    var
        map = newSeq[seq[char]]()
        startPoint: Point

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line.len > 0:
                var lineSeq = newSeq[char]()
                for c in line:
                    if c == 'S':
                        startPoint = Point(y: map.len, x: line.find(c))
                    lineSeq.add(c)
                map.add(lineSeq)

    var
        beginningSteps = getNextSteps(startPoint, map, @[])
        curStep = beginningSteps[0]
        path: seq[Point] = @[startPoint]
        numSteps = 0

    while true:
        let nextStep = getNextSteps(curStep, map, path)

        path.add(curStep)
        if nextStep.len == 0:
            break
        curStep = nextStep[0]

    echo "Part one: ", path.len / 2


proc partTwo() =
    let fn = "./input/day_10.txt"

    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line
    echo "Part two: "

when isMainModule:
    partOne()
    #partTwo()
