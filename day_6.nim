from utils import withStream
from streams import lines
from strutils import split, parseInt, replace
from sequtils import map, foldl

const TEST_DATA = """
7 15 30
9 40 200
"""

proc calcWaysToBeat(raceTime: int, maxDistance: int): int =
    var numWays = 0
    for startTime in 1..raceTime-1:
        var 
            speed = startTime
            remainingTime = raceTime - startTime
            distance = speed * remainingTime
        if distance > maxDistance:
            inc numWays
    return numWays

proc partOne() =
    let fn = "./input/day_6.txt"
    #let fn = TEST_DATA

    var timeAndDistance = newSeq[string]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            timeAndDistance.add(line)

    let
        raceTimes = timeAndDistance[0].split(" ").map(parseInt)
        maxDistances = timeAndDistance[1].split(" ").map(parseInt)

    var numWays = newSeq[int]()

    for i in 0..raceTimes.len-1:
        numWays.add(calcWaysToBeat(raceTimes[i], maxDistances[i]))

    echo "Part one: ", numWays.foldl(a*b)

proc partTwo() =
    let fn = "./input/day_6.txt"
    #let fn = TEST_DATA

    var timeAndDistance = newSeq[string]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            timeAndDistance.add(line)

    let
        raceTime = timeAndDistance[0].replace(" ").parseInt()
        maxDistance = timeAndDistance[1].replace(" ").parseInt()

    echo "Part two: ", calcWaysToBeat(raceTime, maxDistance)

when isMainModule:
    partOne()
    partTwo()
