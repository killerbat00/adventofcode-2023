from utils import withStream
from streams import lines
import strutils
import sequtils
import sugar

const TEST_INPUT = """
0 3 6 9 12 15
1 3 6 10 15 21
10 13 16 21 30 45
"""

proc differencePerStep(input: seq[int]): seq[int] =
    result = newSeq[int]()
    for i in 0 .. input.high - 1:
        result.add(input[i + 1] - input[i])

proc extrapolateRight(input: seq[int]): int = 
    var 
        current = input.toSeq()
    while not current.all(x => x == 0):
        result += current[^1]
        current = differencePerStep(current)

proc reduceLeft(input: seq[int]): seq[int] = 
    var 
        current = input.toSeq()
        result = newSeq[int]()
    while not current.all(x => x == 0):
        result.add(current[0])
        current = differencePerStep(current)
    result.add(current[0])
    return result

proc extrapolateLeft(reduced: seq[int]): int =
    result = 0
    for i in countdown(reduced.high-1, 0):
        result = reduced[i] - result

proc partOne() =
    let fn = "./input/day_9.txt"
    #let fn = TEST_INPUT

    var sum = 0

    withStream(f, fn, fmRead):
        for line in lines(f):
            sum += extrapolateRight(line.split(" ").map(parseInt))

    echo "Part one: ", sum

proc partTwo() =
    let fn = "./input/day_9.txt"
    #let fn = TEST_INPUT

    var sum = 0

    withStream(f, fn, fmRead):
        for line in lines(f):
            let reduced = reduceLeft(line.split(" ").map(parseInt))
            sum += extrapolateLeft(reduced)

    echo "Part two: ", sum

when isMainModule:
    #partOne()
    partTwo()
