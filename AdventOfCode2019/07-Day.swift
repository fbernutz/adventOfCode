//
//  02-Day.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 02.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

/**
 https:adventofcode.com/2019/day/7
 */

//https://www.objc.io/blog/2014/12/08/functional-snippet-10-permutations/
private extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

private func between<T>(_ x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x, tail).map { [head] + $0 }
}

private func permutations<T>(_ xs: [T]) -> [[T]] {
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(tail).flatMap { between(head, $0) }
}

enum Day07 {
    static func solve() {
        let input = Input.get("07-Input.txt")
        print("Result Day 7 - Part One: \(intcodeProgram(input: input))")
//        print("Result Day 7 - Part Two: \(countMinimumTransfersToSanta(input: input))")
    }


    private static func intcodeProgram(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        var possibleOutputs: [Int] = []

        for phaseSettings in permutations([0, 1, 2, 3, 4]) {
            var currentOutput = 0
            for phase in phaseSettings {
                currentOutput = runProgramm(
                    numbers: originalInputAsNumbers,
                    phaseSetting: phase,
                    input: currentOutput)!
            }
            possibleOutputs.append(currentOutput)
        }

        return String(possibleOutputs.max()!)
    }
    
    private static func runProgramm(numbers: [Int], phaseSetting: Int, input: Int) -> Int? {
        var numbers = numbers
        var index = 0
        var phaseSetting: Int? = phaseSetting
        var currentOutput: Int?

        repeat {
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

                let outputIndex = numbers[index + 1]
                numbers[outputIndex] = phaseSetting ?? input
                phaseSetting = nil

                index += 2
            case let optCode where optCode.starts(with: "4"):
                // return output

                let firstInputIndex = numbers[index + 1]
                let output = mode[0] == 0 ? numbers[firstInputIndex] : firstInputIndex
                currentOutput = output
//                print("Output: \(output)")

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
