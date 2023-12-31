#!/usr/bin/env -S nim --hints:off

import os, strformat, sets, strutils

version = "0.1.0"
author = "brian houston morrow"
description = "advent of code 2023"
license = "MIT"
binDir = "bin"

requires("nim >= 2.0.0")

var params = commandLineParams().toHashSet()

mode = ScriptMode.Silent
when defined(verbose):
    params.excl("--d:verbose")
    params.excl("--define:verbose")
    mode = ScriptMode.Verbose
when defined(dryrun):
    params.excl("--d:dryrun")
    params.excl("--define:dryrun")
    mode = ScriptMode.WhatIf

task runDay, &"compiles and runs a day's code":
    params.excl("runDay")
    if params.len == 1:
        let dayNum = params.pop().parseInt()
        # (c)ompile -(f)orce -(x)checks -(a)ssert
        exec &"nim c -f -x -a -o:{binDir}/ --threads:on --lineTrace:on --mm:orc --debugger:native -d:debug -r day_{dayNum}.nim"
    else:
        echo "usage: nim runDay <day number>"

task runDayMacFast, "compiles and runs a day's code mac native":
    params.excl("runDayMacFast")
    if params.len == 1:
        let dayNum = params.pop().parseInt()
        --forceBuild:on
        --cc:clang
        --define:debug
        --deepcopy:on
        --cpu:arm64
        --passC:"-flto -target arm64-apple-macos11" 
        --passL:"-flto -target arm64-apple-macos11"
        --hints:off
        --outdir:"bin/"
        --run
        setCommand "c", &"day_{dayNum}.nim"
    else:
        echo "usage: nim runDayMacFast <day number>"

task clean, "clean build artifacts":
    if dirExists(binDir):
        rmdir(binDir)
        mkdir(binDir)
