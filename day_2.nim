from utils import withStream
from std/strutils import split, parseInt
from std/streams import lines
import std/tables

proc partOne() =
    const MAX_RED = 12
    const MAX_GREEN = 13
    const MAX_BLUE = 14

    proc isPossible(colors: Table[string, int]): bool =
        if colors.getOrDefault("red", 0) > MAX_RED:
            return false
        if colors.getOrDefault("green", 0) > MAX_GREEN:
            return false
        if colors.getOrDefault("blue", 0) > MAX_BLUE:
            return false
        return true

    proc gameIsPossible(line: string): bool =
        var gameDraws = line.split(": ")[1]
        for drawn in split(gameDraws, "; "):
            var colors: Table[string, int]
            for color in split(drawn, ", "):
                let countName = color.split(' ')
                let count = countName[0].parseInt()
                let name = countName[1]
                colors[name] = colors.getOrDefault(name, 0) + count
                if not isPossible(colors):
                    return false
        return true
    var gameId = 0
    var gameIdSums = 0
    withStream(f, "./input/day_2.txt", fmRead):
        for line in lines(f):
            gameId += 1
            if not gameIsPossible(line):
                continue
            gameIdSums += gameId

    echo "Part one: ", gameIdSums

proc partTwo() =

    proc minimumPossibleCubes(line: string): (int, int, int) =
        var
            gameDraws = line.split(": ")[1]
            red = 0
            green = 0
            blue = 0
        for drawn in split(gameDraws, "; "):
            for color in split(drawn, ", "):
                let countName = color.split(' ')
                let count = countName[0].parseInt()
                let name = countName[1]
                if name == "red":
                    red = max(red, count)
                elif name == "green":
                    green = max(green, count)
                elif name == "blue":
                    blue = max(blue, count)
        return (red, green, blue)

    var powerSum = 0
    withStream(f, "./input/day_2.txt", fmRead):
        for line in lines(f):
            let (red, green, blue) = minimumPossibleCubes(line)
            let cubePower = red * green * blue
            powerSum += cubePower

    echo "Part two: ", powerSum 

when isMainModule:
    partOne()
    partTwo()
