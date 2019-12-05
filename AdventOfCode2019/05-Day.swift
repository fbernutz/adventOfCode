//
//  02-Day.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 02.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

/**
 https://adventofcode.com/2019/day/5
 */

enum Day05 {
    static func solve() {
        let input = Input.get("05-Input.txt")
        print("Result Day 5 - Part One&Two: \(intcodeProgram(input: input))")
    }

    private static func intcodeProgram(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        if let output = runProgramm(
            numbers: originalInputAsNumbers,
            input: 5) {
            return String(output)
        } else {
            return "should not happen"
        }
    }

    /**
     parameter modes:
     - 0, position mode,
     which causes the parameter to be interpreted as a position - if the parameter is 50, its value is the value stored at address 50 in memory
     - 1, immediate mode,
     where a parameter is interpreted as a value - if the parameter is 50, its value is simply 50.
     */
    private static func runProgramm(numbers: [Int], input: Int) -> Int? {
        var numbers = numbers
        var index = 0
        var currentOutput: Int?

        repeat {
            // ABCDE
            // A: if empty -> 0, parameter mode
            // B: parameter mode
            // C: parameter mode
            // DE: optcode, 02 etc.

            var parameterModes = numbers[index].description
                .reversed()
                .map { String($0) }
                .dropFirst()
                .dropFirst()
            while parameterModes.count <= 3 {
                parameterModes.append("0")
            }
            let mode = parameterModes.compactMap { Int($0) }
            // CBA

            let optCode = numbers[index].description
                .reversed()
                .map { String($0) }
                .joined()

            switch optCode {
            case let optCode where optCode.starts(with: "1"):
                // addition next to inputs and write in third output

                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                let outputIndex = numbers[index + 3]
                let first = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? numbers[secondInputIndex] : secondInputIndex
                numbers[outputIndex] = first + second

                index += 4
            case let optCode where optCode.starts(with: "2"):
                // multiply next two

                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                let outputIndex = numbers[index + 3]
                let first = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? numbers[secondInputIndex] : secondInputIndex
                numbers[outputIndex] = first * second

                index += 4
            case let optCode where optCode.starts(with: "3"):
                // save input

                let firstInputIndex = numbers[index + 1]
                let outputIndex = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                numbers[outputIndex] = input

                index += 2
            case let optCode where optCode.starts(with: "4"):
                // return output

                let firstInputIndex = numbers[index + 1]
                let output = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                currentOutput = output
                print("Output: \(output)")

                index += 2
            case let optCode where optCode.starts(with: "5"):
                // jump-if-true
                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                let first = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? numbers[secondInputIndex] : secondInputIndex
                if first != 0 {
                    index = second
                } else {
                    index += 3
                }
            case let optCode where optCode.starts(with: "6"):
                // jump-if-false
                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                let first = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? numbers[secondInputIndex] : secondInputIndex
                if first == 0 {
                    index = second
                } else {
                    index += 3
                }
            case let optCode where optCode.starts(with: "7"):
                // less than
                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                let outputIndex = numbers[index + 3]
                let first = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? numbers[secondInputIndex] : secondInputIndex

                if first < second {
                    numbers[outputIndex] = 1
                } else {
                    numbers[outputIndex] = 0
                }

                index += 4
            case let optCode where optCode.starts(with: "8"):
                // equals
                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                let outputIndex = numbers[index + 3]
                let first = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? numbers[secondInputIndex] : secondInputIndex

                if first == second {
                    numbers[outputIndex] = 1
                } else {
                    numbers[outputIndex] = 0
                }

                index += 4
            case let optCode where optCode.starts(with: "99"):
                // halting programm
                return currentOutput ?? 0
            default:
                fatalError("invalid input")
            }
        } while true
    }
}
