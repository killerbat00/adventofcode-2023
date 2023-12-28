from utils import withStream
from streams import lines

import strutils
import sequtils
import sugar

const TEST_INPUT = """
#.##..##.
..#.##.#.
##......#
##......#
..#.##.#.
..##..##.
#.#.##.#.

#...##..#
#....#..#
..##..###
#####.##.
#####.##.
..##..###
#....#..#
"""

proc findSmudgeHorizontal(map: seq[seq[char]]): (int, int, int) = # y, y, x coord
    # while looking for horizontal symmetry
    # there will be a pair of rows that are only off by 1 element
    # that is the smudge
    for y in 1 ..< map.len:
        var 
            topY = y - 1
            btmY = y

        while true:
            var numDiff = newSeq[int]()
            if topY < 0 or btmY >= map.len:
                break
            for x in 0 ..< map[0].len:
                if map[topY][x] != map[btmY][x]:
                    numDiff.add(x)

            if numDiff.len == 1:
                return (topY, btmY, numDiff[0])

            topY -= 1
            btmY += 1
    return (-1, -1, -1)

proc findSmudgeVertical(map: seq[seq[char]]): (int, int, int) = # x, x, y coord
    # while looking for vertical symmetry
    # there will be a pair of columns that are only off by 1 element
    # that is the smudge
    for x in 1 ..< map[0].len:
        var 
            leftX = x - 1
            rightX = x
    
        while true:
            var numDiff = newSeq[int]()
            if leftX < 0 or rightX >= map[0].len:
                break
            for y in 0 ..< map.len:
                if map[y][leftX] != map[y][rightX]:
                    numDiff.add(y)

            if numDiff.len == 1:
                return (leftX, rightX, numDiff[0])

            leftX -= 1
            rightX += 1
    return (-1, -1, -1)

proc isReflectiveHorizontal(map: seq[seq[char]], yIdx: int): bool =
    assert yIdx > 0 and yIdx < map.len

    var 
        topY = yIdx - 1
        btmY = yIdx

    while true:
        if topY < 0 or btmY >= map.len:
            return true
        for x in 0 ..< map[yIdx].len:
            if map[topY][x] != map[btmY][x]:
                return false
        topY -= 1
        btmY += 1
    return true

proc isReflectiveVertical(map: seq[seq[char]], xIdx: int): bool =
    assert xIdx >= 0 and xIdx < map[0].len

    var 
        leftX = xIdx - 1
        rightX = xIdx
    
    while true:
        if leftX < 0 or rightX >= map[0].len:
            return true
        for y in 0 ..< map.len:
            if map[y][leftX] != map[y][rightX]:
                return false
        leftX -= 1
        rightX += 1
    return true

proc findReflectiveVertical(map: seq[seq[char]]): int =
    for x in 1 ..< map[0].len:
        if isReflectiveVertical(map, x):
            return x
    return -1

proc findReflectiveHorizontal(map: seq[seq[char]]): int =
    for y in 1 ..< map.len:
        if isReflectiveHorizontal(map, y):
            return y
    return -1

proc partOne() =
    let fn = "./input/day_13.txt"
    #let fn = TEST_INPUT

    var
        maps = newSeq[seq[seq[char]]]()
        curMapIdx = 0

    maps.add(newSeq[seq[char]]())

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line == "":
                maps.add(newSeq[seq[char]]())
                curMapIdx += 1
            else:
                maps[curMapIdx].add(line.toSeq())

    var 
        mapIsReflectiveH = newSeq[bool]()
        mapIsReflectiveV = newSeq[bool]()
        sum = 0
    
    for i, map in maps.pairs:
        let y = findReflectiveHorizontal(map)
        let x = findReflectiveVertical(map)

        if y != -1:
            sum += y * 100
        if x != -1:
            sum += x

    echo "Part one: ", sum

proc partTwo() =
    let fn = "./input/day_13.txt"
    #let fn = TEST_INPUT

    var
        maps = newSeq[seq[seq[char]]]()
        curMapIdx = 0

    maps.add(newSeq[seq[char]]())

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line == "":
                maps.add(newSeq[seq[char]]())
                curMapIdx += 1
            else:
                maps[curMapIdx].add(line.toSeq())

    var 
        sum = 0
    
    for i, map in maps.mpairs:
        var 
            potentialSmudgeH = findSmudgeHorizontal(map)
            origY = findReflectiveHorizontal(map)
            potentialSmudgeV = findSmudgeVertical(map)
            origX = findReflectiveVertical(map)

        if potentialSmudgeH[0] != -1:
            let oldChar1 = map[potentialSmudgeH[0]][potentialSmudgeH[2]]

            if oldChar1 == '#':
                map[potentialSmudgeH[0]][potentialSmudgeH[2]] = '.'
                let y = findReflectiveHorizontal(map)
                let x = findReflectiveVertical(map)

                if y != -1 and y != origY:
                    sum += y * 100
                elif x != -1 and x != origX:
                    sum += x
                else:
                    if origY != -1:
                        sum += origY * 100
                    elif origX != -1:
                        sum += origX
                    else:
                        echo "map ", i, " uhhh."

            else:
                map[potentialSmudgeH[0]][potentialSmudgeH[2]] = '#'
                let y = findReflectiveHorizontal(map)
                let x = findReflectiveVertical(map)

                if y != -1 and y != origY:
                    sum += y * 100
                elif x != -1 and x != origX:
                    sum += x
                else:
                    if origY != -1:
                        sum += origY * 100
                    elif origX != -1:
                        sum += origX
                    else:
                        echo "map ", i, " uhhh."

            map[potentialSmudgeH[0]][potentialSmudgeH[2]] = oldChar1

        elif potentialSmudgeV[0] != -1:
            let oldChar1 = map[potentialSmudgeV[2]][potentialSmudgeV[0]]

            if oldChar1 == '#':
                map[potentialSmudgeV[2]][potentialSmudgeV[0]] = '.'
                let y = findReflectiveHorizontal(map)
                let x = findReflectiveVertical(map)

                if y != -1 and y != origY:
                    sum += y * 100
                elif x != -1 and x != origX:
                    sum += x
                else:
                    if origY != -1:
                        sum += origY * 100
                    elif origX != -1:
                        sum += origX
                    else:
                        echo "map ", i, " uhhh."
            else:
                map[potentialSmudgeV[2]][potentialSmudgeV[0]] = '#'
                let y = findReflectiveHorizontal(map)
                let x = findReflectiveVertical(map)
                if y != -1 and y != origY:
                    sum += y * 100
                elif x != -1 and x != origX:
                    sum += x
                else:
                    if origY != -1:
                        sum += origY * 100
                    elif origX != -1:
                        sum += origX
                    else:
                        echo "map ", i, " uhhh."

            map[potentialSmudgeV[2]][potentialSmudgeV[0]] = oldChar1
        else:
            echo "uhh"
    echo "Part two: ", sum

when isMainModule:
    #partOne()
    partTwo()
