from utils import withStream
from streams import lines
import strutils
import sequtils
import tables
import math
import system
import sugar

const TEST_DATA = """
RL

AAA=BBB,CCC
BBB=DDD,EEE
CCC=ZZZ,GGG
DDD=DDD,DDD
EEE=EEE,EEE
GGG=GGG,GGG
ZZZ=ZZZ,ZZZ
"""

proc partOne() =
    let fn = "./input/day_8.txt"
    #let fn = TEST_DATA

    var 
        directions = newSeq[int]()
        map = initTable[string, seq[string]]()
        i = 0

    withStream(f, fn, fmRead):
        for line in lines(f):
            if i == 0:
                let rawDirs = line.toSeq()
                for dir in rawDirs:
                    if dir == 'R':
                        directions.add(1)
                    else:
                        directions.add(0)
                i += 1
                continue
            if line == "":
                continue
            let 
                raw = line.split("=")
                key = raw[0]
                values = raw[1].split(",").toSeq()
            map[key] = values

    var 
        current = "AAA"
        numSteps = 0
        currentDirIdx = 0
    
    while current != "ZZZ":
        let dir = directions[currentDirIdx]
        current = map[current][dir]
        currentDirIdx = (currentDirIdx + 1) mod directions.len
        numSteps += 1

    echo "Part one: ", numSteps

const TEST_DATA_TWO = """
LR

11A=11B,XXX
11B=XXX,11Z
11Z=11B,XXX
22A=22B,XXX
22B=22C,22C
22C=22Z,22Z
22Z=22B,22B
XXX=XXX,XXX
"""

proc partTwo() =
    let fn = "./input/day_8.txt"
    #let fn = TEST_DATA_TWO

    var 
        directions = newSeq[int]()
        map = initTable[string, seq[string]]()
        currentKeys = newSeq[string]()
        i = 0

    withStream(f, fn, fmRead):
        for line in lines(f):
            if i == 0:
                let rawDirs = line.toSeq()
                for dir in rawDirs:
                    if dir == 'R':
                        directions.add(1)
                    else:
                        directions.add(0)
                i += 1
                continue
            if line == "":
                continue
            let 
                raw = line.split("=")
                key = raw[0]
                values = raw[1].split(",").toSeq()
            map[key] = values
            if key.endsWith("A"):
                currentKeys.add(key)

    var 
        currentDirIdx = 0
        numSteps = newSeq[int]()
        steps = 0

    for i, key in currentKeys.pairs:
        var currKey = key
        currentDirIdx = 0
        steps = 0

        while not currKey.endsWith("Z"):
            let dir = directions[currentDirIdx]
            currKey = map[currKey][dir]
            currentDirIdx = (currentDirIdx + 1) mod directions.len
            steps += 1

        numSteps.add(steps)
        
    echo "Part two: ", lcm(numSteps)

when isMainModule:
    #partOne()
    partTwo()
