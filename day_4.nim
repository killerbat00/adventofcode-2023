from utils import withStream
from std/strutils import split, parseInt, strip
from std/sequtils import map, filter
from std/streams import lines
import std/math
import sets
import sugar

const TEST_INPUT = """
Card 1: 41 48 83 86 17 | 83 86  6 31 17  9 48 53
Card 2: 13 32 20 16 61 | 61 30 68 82 17 32 24 19
Card 3:  1 21 53 59 44 | 69 82 63 72 16 21 14  1
Card 4: 41 92 73 84 69 | 59 84 76 51 58  5 54 83
Card 5: 87 83 26 28 32 | 88 30 70 12 93 22 82 36
Card 6: 31 18 13 56 72 | 74 77 10 23 35 67 36 11
"""

proc partOne() =
    var games = newSeq[(HashSet[int], HashSet[int])]()

    let fn = "./input/day_4.txt"
    #let fn = TEST_INPUT
    withStream(f, fn, fmRead):
        for line in f.lines:
            if line != "":
                let parts = line.split(": ")
                let numLists = parts[1].split(" | ")
                let winningNums = numLists[0].split(" ").map((x) => x.strip()).filter((x) => x != "").map(parseInt).toHashSet()
                let numsWeHave = numLists[1].split(" ").map((x) => x.strip()).filter((x) => x != "").map(parseInt).toHashSet()
                games.add((winningNums, numsWeHave))

    var cardsWorth = 0
    for i, game in games.pairs:
        let intersection = game[0] * game[1]
        if intersection.len > 0:
            cardsWorth += 2 ^ (intersection.len - 1)

    echo "Part one: ", cardsWorth


proc partTwo() =
    echo 0

when isMainModule:
    partOne()
    partTwo()
