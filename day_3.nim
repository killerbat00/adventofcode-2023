from utils import withStream
from std/strutils import isDigit, parseInt
from std/sequtils import toSeq
from std/streams import lines
import std/tables

const TEST_INPUT = """
467..114..
...*......
..35..633.
......#...
617*......
.....+.58.
..592.....
......755.
...$.*....
.664.598..
"""

proc isAdjacent(x: int, y: int, len: int, table: var seq[seq[char]]): (bool, (char, int, int)) =
    for xx in x..min(x+len-1, table[y].len-1):
        for yi in max(0, y-1)..min(y+1, table.len-1):
            for xi in max(0, xx-1)..min(xx+1, table[yi].len-1):
                if yi == y and xi == xx:
                    continue
                if table[yi][xi].isDigit() == false and not (table[yi][xi] == '.'):
                    return (true, (table[yi][xi], xi, yi))
    return (false, ('/', 0, 0))

proc partOneAndTwo() =
    var schematic = newSeq[seq[char]]()
    var symbolMap: Table[(char, int, int), seq[int]]
    withStream(f, "./input/day_3.txt", fmRead):
    #withStream(f, TEST_INPUT, fmRead):
        for line in lines(f):
            if line != "":
                schematic.add(line.toSeq())

    let
        maxX = schematic[0].len - 1
        maxY = schematic.len - 1
    var
        x = 0
        y = 0

    var numbers = newSeq[string]()
    var currentNumber = ""

    while y <= maxY:
        if currentNumber != "":
            let result = isAdjacent(x - currentNumber.len, y - 1, currentNumber.len, schematic)
            if result[0]:
                if symbolMap.hasKey(result[1]):
                    symbolMap[result[1]].add(currentNumber.parseInt())
                else:
                    symbolMap[result[1]] = @[currentNumber.parseInt()]
            currentNumber = ""
        x = 0
        while x <= maxX:
            if isDigit(schematic[y][x]):
                currentNumber &= $schematic[y][x]
            else:
                let startX = x - currentNumber.len
                if currentNumber != "":
                    let result = isAdjacent(startX, y, currentNumber.len, schematic)
                    if result[0]:
                        if symbolMap.hasKey(result[1]):
                            symbolMap[result[1]].add(currentNumber.parseInt())
                        else:
                            symbolMap[result[1]] = @[currentNumber.parseInt()]
                    currentNumber = ""
            x += 1
        y += 1

    var numberSum = 0
    for key, numbers in symbolMap.pairs:
        for number in numbers:
            numberSum += number

    var gearRatioSum = 0
    for key, numbers in symbolMap.pairs:
        if numbers.len == 2:
            gearRatioSum += numbers[0] * numbers[1]

    echo "Part one: ", numberSum
    echo "Part two: ", gearRatioSum

when isMainModule:
    partOneAndTwo()
