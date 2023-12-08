from utils import withStream
from streams import lines

import sets
import tables
import sugar
import sequtils
import strutils
import algorithm

const TEST_DATA = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""

var ranks = @['A', 'K', 'Q', 'J', 'T', '9', '8', '7', '6', '5', '4', '3', '2']

proc isFiveOfAKind(input: string): bool =
    return input.toHashSet().len == 1

proc isFourOfAKind(input: string): bool =
    let ht = input.toCountTable()
    return ht.keys().toSeq().len == 2 and ht.values().toSeq().filter(x => x == 4).len != 0

proc isFullHouse(input: string): bool =
    let ht = input.toCountTable()
    return ht.keys().toSeq().len == 2 and ht.values().toSeq().filter(x => x == 3).len != 0

proc isThreeOfAKind(input: string): bool =
    let ht = input.toCountTable()
    return ht.keys().toSeq().len == 3 and ht.values().toSeq().filter(x => x == 3).len != 0

proc isTwoPair(input: string): bool =
    let ht = input.toCountTable()
    return ht.keys().toSeq().len == 3 and ht.values().toSeq().filter(x => x == 2).len == 2

proc isOnePair(input: string): bool =
    let ht = input.toCountTable()
    return ht.keys().toSeq().len == 4 and ht.values().toSeq().filter(x => x == 2).len == 1

proc scoreHand(input: string): int =
    if isFiveOfAKind(input):
        return 6
    elif isFourOfAKind(input):
        return 5
    elif isFullHouse(input):
        return 4
    elif isThreeOfAKind(input):
        return 3
    elif isTwoPair(input):
        return 2
    elif isOnePair(input):
        return 1
    else:
        return 0

proc cmpHand(a: string, b: string): int =
    let scoreA = scoreHand(a)
    let scoreB = scoreHand(b)
    if scoreA > scoreB:
        return 1
    elif scoreA < scoreB:
        return -1
    else:
        for i in 0..a.len-1:
            if ranks.find(a[i]) > ranks.find(b[i]):
                return -1
            elif ranks.find(a[i]) < ranks.find(b[i]):
                return 1

proc partOne() =
    let fn = "./input/day_7.txt"
    #let fn = TEST_DATA
    var handsAndBids = newSeq[(string, int)]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            let handBid = line.split(" ")
            handsAndBids.add((handBid[0], handBid[1].parseInt()))

    handsAndBids.sort((x, y: (string, int)) => cmpHand(x[0], y[0]))

    var totalWinnings = 0        
    for i, handBid in handsAndBids.pairs:
        let 
            multFactor = i + 1
            won = handBid[1] * multFactor
        totalWinnings += won

    echo "Part one: ", totalWinnings

var partTwoRanks = @['A', 'K', 'Q', 'T', '9', '8', '7', '6', '5', '4', '3', '2', 'J']

proc cmpHandTwo(a: string, b: string, aOrig: string, bOrig: string): int =
    let scoreA = scoreHand(a)
    let scoreB = scoreHand(b)
    if scoreA > scoreB:
        return 1
    elif scoreA < scoreB:
        return -1
    else:
        for i in 0..a.len-1:
            if partTwoRanks.find(aOrig[i]) > partTwoRanks.find(bOrig[i]):
                return -1
            elif partTwoRanks.find(aOrig[i]) < partTwoRanks.find(bOrig[i]):
                return 1

proc cmpTwoRanks(a: char, b: char): int =
    if partTwoRanks.find(a) > partTwoRanks.find(b):
        return -1
    else:
        return 1

proc maximizeHand(a: string): string =
    var ht = a.toCountTable()
    var numJokers = ht['J']
    ht.sort()

    if numJokers == 0:
        return a
    if numJokers == 1:
        var options = a.replace("J").toHashSet().toSeq()
        if options.len == 1:
            return a.replace('J', options[0])
        if options.len == 2:
            # three of one, two of another, pick one with three
            for key, value in a.replace("J").toCountTable().pairs:
                if value == 3:
                    return a.replace('J', key)
            # two of one, two of another, pick highest ranking one with two
            if partTwoRanks.find(options[0]) > partTwoRanks.find(options[1]):
                return a.replace('J', options[1])
            else:
                return a.replace('J', options[0])
        if options.len == 3:
            # two of one, one of another, one of another, pick one with two
            for key, value in a.replace("J").toCountTable().pairs:
                if value == 2:
                    return a.replace('J', key)
        if options.len == 4:
            # all different, pick highest ranking
            var copy = options.toSeq()
            copy.sort((x, y: char) => cmpTwoRanks(x, y))
            return a.replace('J', copy[0])
    if numJokers == 2:
        var options = a.replace("J").toHashSet().toSeq()
        # all different, pick highest
        if options.len == 3:
            var copy = options.toSeq()
            copy.sort((x, y: char) => cmpTwoRanks(x, y))
            return a.replace('J', copy[0])
        # two of one, one of another, pick one with two
        if options.len == 2:
            for key, value in a.replace("J").toCountTable().pairs:
                if value == 2:
                    return a.replace('J', key)
        if options.len == 1:
            return a.replace('J', options[0])
    if numJokers == 3:
        # go with one with highest rank
        let options = ht.keys().toSeq().filter(x => x != 'J')
        if (options.len == 1):
            return a.replace('J', options[0])
        if partTwoRanks.find(options[0]) < partTwoRanks.find(options[1]):
            return a.replace('J', options[0])
        else:
            return a.replace('J', options[1])
    if numJokers == 4:
        let options = ht.keys().toSeq().filter(x => x != 'J')
        return a.replace('J', options[0])
    if numJokers == 5:
        return "AAAAA"
    return a


proc partTwo() =
    let fn = "./input/day_7.txt"
    #let fn = TEST_DATA
    var handsAndBids = newSeq[(string, string, int)]()

    withStream(f, fn, fmRead):
        for line in lines(f):
            let handBid = line.split(" ")
            handsAndBids.add((maximizeHand(handBid[0]), handBid[0], handBid[1].parseInt()))

    handsAndBids.sort((x, y: (string, string, int)) => cmpHandTwo(x[0], y[0], x[1], y[1]))

    var totalWinnings = 0        
    for i, handBid in handsAndBids.pairs:
        let 
            multFactor = i + 1
            won = handBid[2] * multFactor
        totalWinnings += won

    echo "Part two: ", totalWinnings

when isMainModule:
    partOne()
    partTwo()
