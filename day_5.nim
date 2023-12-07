from utils import withStream
from streams import lines
from std/strutils import startsWith, split, parseInt
from std/sequtils import map, minmax
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

type
    Range = object
        destStart: int
        srcStart: int
        length: int

proc srcNumInRange(r: Range, srcNum: int): bool =
    if srcNum < r.srcStart:
        return false
    elif srcNum >= r.srcStart + r.length:
        return false
    return true

proc srcNumToDestNum(r: Range, srcNum: int): int =
    let destOffset = srcNum - r.srcStart
    return r.destStart + destOffset

proc translateSrcNum(map: seq[Range], srcNum: int): int =
    for r in map:
        if srcNumInRange(r, srcNum):
            return srcNumToDestNum(r, srcNum)
    return srcNum

proc translateSeedToLocation(seed: int, maps: seq[seq[Range]]): int =
    var
        srcNum = seed
        destNum = -1
    for map in maps:
        destNum = translateSrcNum(map, srcNum)
        srcNum = destNum
    return destNum

proc partOne() =
    let fn = "./input/day_5.txt"
    #let fn = TEST_DATA

    var seedsAndMap = newSeq[string]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            seedsAndMap.add(line)

    let numLines = seedsAndMap.len
    var
        i = 0
        seeds = newSeq[int]()
        seedToSoil = newSeq[Range]()
        soilToFert = newSeq[Range]()
        fertToWater = newSeq[Range]()
        waterToLight = newSeq[Range]()
        lightToTemp = newSeq[Range]()
        tempToHumid = newSeq[Range]()
        humidToLoc = newSeq[Range]()

    while i < numLines:
        if i == 0:
            seeds = seedsAndMap[i].split(": ")[1].split(" ").map(parseInt)
            i += 1
            continue
        if seedsAndMap[i] == "":
            i += 1
            continue
        if seedsAndMap[i].startsWith("seed-to-soil"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                seedToSoil.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("soil-to-fertilizer"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                soilToFert.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("fertilizer-to-water"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                fertToWater.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("water-to-light"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                waterToLight.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("light-to-temperature"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                lightToTemp.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("temperature-to-humidity"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                tempToHumid.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("humidity-to-location"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                humidToLoc.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue

    var locations = newSeq[int]()
    for seed in seeds:
        let location = translateSeedToLocation(seed, @[seedToSoil, soilToFert, fertToWater, waterToLight, lightToTemp, tempToHumid, humidToLoc])
        locations.add(location)
    echo "Part one: ", minmax(locations)[0]

proc partTwo() =
    #let fn = "./input/day_5.txt"
    let fn = TEST_DATA

    var seedsAndMap = newSeq[string]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            seedsAndMap.add(line)

    let numLines = seedsAndMap.len
    var
        i = 0
        initialSeeds = newSeq[int]()
        seeds = newSeq[int]()
        seedToSoil = newSeq[Range]()
        soilToFert = newSeq[Range]()
        fertToWater = newSeq[Range]()
        waterToLight = newSeq[Range]()
        lightToTemp = newSeq[Range]()
        tempToHumid = newSeq[Range]()
        humidToLoc = newSeq[Range]()

    while i < numLines:
        if i == 0:
            initialSeeds = seedsAndMap[i].split(": ")[1].split(" ").map(parseInt)
            let numSeeds = initialSeeds.len
            var i = 0
            while i < numSeeds:
                for j in initialSeeds[i]..initialSeeds[i+1]:
                    seeds.add(j)
            i += 1
            continue
        if seedsAndMap[i] == "":
            i += 1
            continue
        if seedsAndMap[i].startsWith("seed-to-soil"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                seedToSoil.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("soil-to-fertilizer"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                soilToFert.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("fertilizer-to-water"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                fertToWater.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("water-to-light"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                waterToLight.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("light-to-temperature"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                lightToTemp.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("temperature-to-humidity"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                tempToHumid.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue
        if seedsAndMap[i].startsWith("humidity-to-location"):
            i += 1
            while i < numLines and seedsAndMap[i] != "":
                let
                    line = seedsAndMap[i]
                    parts = line.split(" ")
                    destStart = parseInt(parts[0])
                    srcStart = parseInt(parts[1])
                    length = parseInt(parts[2])
                humidToLoc.add(Range(destStart: destStart, srcStart: srcStart, length: length))
                i += 1
            continue

    var locations = newSeq[int]()
    for seed in seeds:
        let location = translateSeedToLocation(seed, @[seedToSoil, soilToFert, fertToWater, waterToLight, lightToTemp, tempToHumid, humidToLoc])
        locations.add(location)
    echo "Part two: ", minmax(locations)[0]

when isMainModule:
    #partOne()
    partTwo()
