from utils import withStream
from streams import lines
from std/strutils import startsWith, split, parseInt
from std/sequtils import map
import sugar

const TEST_DATA = """
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""

proc partOne() =
    #let fn = "./input/day_5.txt"
    let fn = TEST_DATA
    let seeds = newSeq[string]()


    withStream(f, fn, fmRead):
        for line in lines(f):
            if line.startsWith("seeds:"):
                let seedLine = line.split(": ")[1]
                let seeds = seedLine.split(" ").map(x => x.parseInt())
                echo seeds
            elif line.startsWith("")

    echo "Part one: "

proc partTwo() =
    let fn = "./input/day_5.txt"

    withStream(f, fn, fmRead):
        for line in lines(f):
            echo line
    echo "Part two: "

when isMainModule:
    partOne()
    #partTwo()
