from utils import withStream
from streams import lines

import strutils
import sequtils
import sugar

proc partOne() =
    let fn = "./input/day_12.txt"

    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line

    echo "Part one: "

proc partTwo() =
    let fn = "./input/day_12.txt"
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line
    echo "Part two: "

when isMainModule:
    partOne()
    partTwo()
