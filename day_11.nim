from utils import withStream
from streams import lines

import strutils
import sequtils
import sugar

const TEST_INPUT = """
...#......
.......#..
#.........
..........
......#...
.#........
.........#
..........
.......#..
#...#.....
"""

proc insertRow(map: var seq[seq[char]], row: int) = 
    var newRow = newSeq[char]()
    for _ in 0 .. map[0].high:
        newRow.add('.')
    map.insert(newRow, row)

proc insertCol(map: var seq[seq[char]], col: int) = 
    for _, row in map.mpairs:
        row.insert('.', col)

proc bigBang(map: var seq[seq[char]]) = 
    # find all empty rows
    var emptyRows = newSeq[int]()
    var emptyCols = newSeq[int]()

    for (i, row) in map.pairs:
        if row.allIt(it == '.'):
            emptyRows.add(i+emptyRows.len)

    for x in 0 ..< map[0].len:
        if map.allIt(it[x] == '.'):
            emptyCols.add(x+emptyCols.len)

    for row in emptyRows:
        insertRow(map, row)

    for col in emptyCols:
        insertCol(map, col)

type 
    Point = object
        x, y: int

proc manhattanDistance(p1, p2: Point): int =
    abs(p1.x - p2.x) + abs(p1.y - p2.y)

proc findGalaxies(map: seq[seq[char]]): seq[Point] =
    for y in 0 .. map.high:
        for x in 0 .. map[0].high:
            if map[y][x] == '#':
                result.add(Point(y: y, x: x))

proc partOne() =
    let fn = "./input/day_11.txt"
    #let fn = TEST_INPUT

    var galaxyMap = newSeq[seq[char]]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line != "":
                galaxyMap.add(line.toSeq())

    bigBang(galaxyMap)

    var 
        galaxyLocs = findGalaxies(galaxyMap)
        sum = 0

    for i in 0 .. galaxyLocs.high:
        for j in i+1 .. galaxyLocs.high:
            sum += manhattanDistance(galaxyLocs[i], galaxyLocs[j])
    echo "Part one: ", sum

proc partTwo() =
    let fn = "./input/day_11.txt"
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line
    echo "Part two: "

when isMainModule:
    partOne()
    #partTwo()
