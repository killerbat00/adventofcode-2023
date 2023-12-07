from utils import withStream
from std/strutils import split, parseInt, strip
from std/sequtils import map, filter, foldl
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

proc partOneAndTwo() =
    var gameResults = newSeq[int]()
    var numCopies = newSeq[int]()

    let fn = "./input/day_4.txt"
    #let fn = TEST_INPUT
    withStream(f, fn, fmRead):
        for line in f.lines:
            if line != "":
                let
                    parts = line.split(": ")
                    numLists = parts[1].split(" | ")
                    winningNums = numLists[0].split(" ").map((x) => x.strip()).filter((x) => x != "").map(parseInt).toHashSet()
                    numsWeHave = numLists[1].split(" ").map((x) => x.strip()).filter((x) => x != "").map(parseInt).toHashSet()
                gameResults.add((winningNums * numsWeHave).len)
                numCopies.add(1)

    var 
        cardsWorth = 0
        totalCards = 0
    for i, numWon in gameResults.pairs:
        if numWon <= 0:
            continue
        cardsWorth += 2 ^ (numWon - 1)

        for j in i+1..i+numWon:
            numCopies[j] += numCopies[i]

    echo "Part one: ", cardsWorth
    echo "Part two: ", numCopies.foldl(a + b)


when isMainModule:
    partOneAndTwo()
