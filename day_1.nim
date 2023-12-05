from utils import withStream
from std/strutils import parseInt, isDigit, replace
from std/sequtils import filter
from std/streams import lines
import std/tables
import sugar

const TEST_INPUT = """
two1nine
eightwothree
abcone2threexyz
xtwone3four
4nineeightseven2
zoneight234
7pqrstsixteen
"""

const translation = {"z0ro": "zero", "o1e": "one", "t2o": "two", "t3ree": "three", "f4ur": "four", "f5ve": "five", "s6x": "six", "s7ven": "seven", "e8ght": "eight", "n9ne": "nine"}.toTable

proc normalizeString(s: string): string =
    var fixed = s
    for k, v in translation.pairs:
        fixed = fixed.replace(v, $k)
    return fixed


when isMainModule:
    var dayOneSum = 0
    var dayTwoSum = 0
    let dayOneFilterFunc = (c: char) => isDigit(c)

    withStream(f, "./input/day_1.txt", fmRead):
        for line in lines(f):
            let nums = line.filter(dayOneFilterFunc)
            dayOneSum += parseInt(nums[0] & nums[^1])

    withStream(f, "./input/day_1.txt", fmRead):
        for line in lines(f):
            let nums = normalizeString(line).filter(dayOneFilterFunc)
            dayTwoSum += parseInt(nums[0] & nums[^1])


    echo "Calibration Values: ", dayOneSum
    echo "Fixed Calibration Values: ", dayTwoSum
