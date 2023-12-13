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

proc findEmptyRowsCols(map: seq[seq[char]]): (seq[int], seq[int]) =
    var emptyRows = newSeq[int]()
    var emptyCols = newSeq[int]()

    for (i, row) in map.pairs:
        if row.allIt(it == '.'):
            emptyRows.add(i+emptyRows.len)

    for x in 0 ..< map[0].len:
        if map.allIt(it[x] == '.'):
            emptyCols.add(x+emptyCols.len)
    
    return (emptyRows, emptyCols)

proc bigBang(map: var seq[seq[char]]) = 
    var 
        emptyRowCols = findEmptyRowsCols(map)
        emptyRows = emptyRowCols[0]
        emptyCols = emptyRowCols[1]

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
    #let fn = "./input/day_11.txt"
    let fn = TEST_INPUT

    var galaxyMap = newSeq[seq[char]]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line != "":
                galaxyMap.add(line.toSeq())

    var 
        galaxyLocs = findGalaxies(galaxyMap)
        sum = 0

    # now, if any galaxies have an empty row between them:
    #   add num empty rows * 1000000 to the y distance between them
    # if any galaxies have an empty col between them:
    #   and add num empty cols * 1000000 to the x distance between them
    let 
        emptyRowCols = findEmptyRowsCols(galaxyMap)
        emptyRows = emptyRowCols[0]
        emptyCols = emptyRowCols[1]

    for i in 0 .. galaxyLocs.high:
        var gp1 = galaxyLocs[i]
        for j in i+1 .. galaxyLocs.high:
            var gp2 = galaxyLocs[j]
            # count number of empty rows between galaxies
            # multiply by 1000000 and add to gp2.y distance
            var numEmptyRows = 0
            for row in emptyRows:
                if row in gp1.y .. gp2.y:
                    numEmptyRows += 1
            gp2.y += (numEmptyRows * 10) #1000000)
            # count number of empty cols between galaxies
            # multiply by 1000000 and add to gp2.x distance
            var numEmptyCols = 0
            for col in emptyCols:
                if col in gp1.x .. gp2.x:
                    numEmptyCols += 1
            gp2.x += (numEmptyCols * 10) #1000000)
            sum += manhattanDistance(gp1, gp2)
    
    echo "Part two: ", sum

when isMainModule:
    #partOne()
    partTwo()
