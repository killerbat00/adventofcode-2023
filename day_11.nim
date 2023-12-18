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

proc isEmptyRow(map: seq[seq[char]], row: int): bool =
    return map[row].allIt(it == '.')

proc isEmptyCol(map: seq[seq[char]], col: int): bool =
    return map.allIt(it[col] == '.')

proc findEmptyRowsCols(map: seq[seq[char]]): (seq[int], seq[int]) =
    var emptyRows = newSeq[int]()
    var emptyCols = newSeq[int]()

    for (i, row) in map.pairs:
        if row.allIt(it == '.'):
            emptyRows.add(i + emptyRows.len)

    for x in 0 ..< map[0].len:
        if map.allIt(it[x] == '.'):
            emptyCols.add(x + emptyCols.len)
    
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
    return abs(p1.x - p2.x) + abs(p1.y - p2.y)

proc left(p1, p2: Point): bool =
    return p1.x < p2.x

proc above(p1, p2: Point): bool =
    return p1.y < p2.y

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
    #let fn = TEST_INPUT

    var 
        galaxyMap = newSeq[seq[char]]()
        galaxyLocs = newSeq[Point]()
        distSum = 0
        emptyRows = newSeq[int]()
        emptyCols = newSeq[int]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line != "":
                galaxyMap.add(line.toSeq())

    galaxyLocs = findGalaxies(galaxyMap)

    for y in 0 .. galaxyMap.high:
        if isEmptyRow(galaxyMap, y):
            emptyRows.add(y)
    for x in 0 .. galaxyMap[0].high:
        if isEmptyCol(galaxyMap, x):
            emptyCols.add(x)

    for i in 0 .. galaxyLocs.high:
        let gp1 = galaxyLocs[i]
        for j in i+1 .. galaxyLocs.high:
            let gp2 = galaxyLocs[j]
            var 
                numEmptyRows = 0
                numEmptyCols = 0

            # count number of empty rows between galaxies
            for row in countup(min(gp1.y, gp2.y), max(gp1.y, gp2.y)):
                if row in emptyRows:
                    numEmptyRows += 1
            # count number of empty cols between galaxies
            for col in countup(min(gp1.x, gp2.x), max(gp1.x, gp2.x)):
                if col in emptyCols:
                    numEmptyCols += 1

            let origDist = manhattanDistance(gp1, gp2)
            let distModif = 999999
            distSum += (origDist + (numEmptyRows*distModif) + (numEmptyCols*distModif))
    
    echo "Part two: ", distSum

when isMainModule:
    partOne()
    partTwo()
