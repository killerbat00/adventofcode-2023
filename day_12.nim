from utils import withStream
from streams import lines

import strutils
import sequtils
import tables
import system
import strformat

const TEST_INPUT = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""

var cache = newTable[string, TableRef[seq[int], int]]()
proc countValidSolutions(line: string, spans: seq[int]): int =
    if line in cache:
        if spans in cache[line]:
            return cache[line][spans]

    if line.len == 0:
        if spans.len == 0:
            return 1
        return 0

    if spans.len == 0:
        if line.contains("#"):
            return 0
        return 1

    let
        c = line[0]
        rest = line[1 .. ^1]
    
    if c == '.':
        cache[line] = newTable([(spans, countValidSolutions(rest, spans))])
        return cache[line][spans]
    
    if c == '#':
        let curSpan = spans[0]
        if line.len >= curSpan and line[0 .. curSpan-1].allIt(it != '.') and (line.len == curSpan or line[curSpan] != '#'):
            if line.len == curSpan:
                cache[line] = newTable([(spans, countValidSolutions("", spans[1 .. ^1]))])
                return cache[line][spans]
            cache[line] = newTable([(spans, countValidSolutions(line[curSpan+1.. ^1], spans[1 .. ^1]))])
            return cache[line][spans]
        return 0

    if c == '?':
        cache[line] = newTable([(spans, countValidSolutions(&"#{rest}", spans) + countValidSolutions(&".{rest}", spans))])
        return cache[line][spans]
    return 0

proc partOne() =
    let fn = "./input/day_12.txt"
    #let fn = TEST_INPUT

    var
        map = newSeq[(string, seq[int])]()
        sum = 0

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line != "":
                let
                    parts = line.split(" ")
                    st = parts[0]
                    spans = parts[1].split(",").mapIt(parseInt(it))
                sum += countValidSolutions(st, spans)

    echo "Part one: ", sum

proc unfold(info: (string, seq[int])): (string, seq[int]) =
    let result1 = repeat(info[0] & "?", 5)[0 .. ^2]
    let result2 = repeat(info[1], 5).foldl(a.concat(b))
    return (result1, result2)

proc partTwo() =
    let fn = "./input/day_12.txt"
    #let fn = TEST_INPUT

    var
        map = newSeq[(string, seq[int])]()
        sum = 0

    withStream(f, fn, fmRead):
        for line in lines(f):
            if line != "":
                let
                    parts = line.split(" ")
                    st = parts[0]
                    spans = parts[1].split(",").mapIt(parseInt(it))
                    unfolded = unfold((st, spans))
                sum += countValidSolutions(unfolded[0], unfolded[1])

    echo "Part two: ", sum

when isMainModule:
    #partOne()
    partTwo()
