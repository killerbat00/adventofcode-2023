from utils import withStream
from streams import lines

import strutils
import sequtils
import sugar
import algorithm
import bitops

const TEST_INPUT = """
???.### 1,1,3
.??..??...?##. 1,1,3
?#?#?#?#?#?#?#? 1,3,1,6
????.#...#... 4,1,1
????.######..#####. 1,6,5
?###???????? 3,2,1
"""

proc isValidLine(line: string, gaps: seq[int]): bool =
    var 
        counts = newSeq[int]()
        curCount = 0
    
    for c in line:
        if c == '#':
            inc curCount
        else:
            if curCount > 0:
                counts.add(curCount)
                curCount = 0
    if curCount > 0:
        counts.add(curCount)
    
    return counts == gaps

iterator combos(n: int): seq[char] =
    let totalCombos = 1 shl n
    for i in 0 ..< totalCombos:
        var combo = newSeq[char]()
        for j in 0 ..< n:
            if bitand(i, 1 shl (n - j - 1)) != 0:
                combo.add('#')
            else:
                combo.add('.')
        yield combo

proc replaceFromChoice(line: string, choice: seq[char]): string = 
    var 
        r = line.toSeq()
        i = 0

    for li, l in r.mpairs:
        if l == '?':
            r[li] = choice[i]
            inc i
        else:
            r[li] = l
    return r.join

proc isValidLineWithChoice(line: string, choice: seq[char], gaps: seq[int]): bool =
    var 
        counts = newSeq[int]()
        curCount = 0
        choiceIdx = 0
    
    for i, c in line.pairs:
        if counts.len > gaps.len:
            return false
        if c == '?':
            if choice[choiceIdx] == '#':
                inc curCount
            else:
                if curCount > 0:
                    counts.add(curCount)
                    curCount = 0
            inc choiceIdx
            continue

        if c == '#':
            inc curCount
        else:
            if curCount > 0:
                counts.add(curCount)
                curCount = 0

    if curCount > 0:
        counts.add(curCount)
    
    return counts == gaps

proc checkPermutations(line: string, gaps: seq[int]): int =
    var result = 0
    let unknown = line.filterIt(it == '?')
    for choice in combos(unknown.len):
        if isValidLineWithChoice(line, choice, gaps):
            result += 1
    return result

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
                    gaps = parts[1].split(",").mapIt(it.parseInt())
                map.add((st, gaps))

    for m in map:
        sum += checkPermutations(m[0], m[1])
    echo "Part one: ", sum

proc partTwo() =
    let fn = "./input/day_12.txt"
    
    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line
    echo "Part two: "

when isMainModule:
    partOne()
    #partTwo()
