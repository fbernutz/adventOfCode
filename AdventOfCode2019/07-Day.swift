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

class Amp {
    var name: String
    var memory: [Int] = []
    var index: Int = 0
    var phaseSetting: Int?
    var hit99: Bool = false

    init(name: String, memory: [Int]) {
        self.name = name
        self.memory = memory
    }

    func runProgramm(input: Int) -> Int? {
        print("Running Amp\(name) with input: \(input)")
        var currentOutput = input

        repeat {
            var parameterModes = memory[index].description
                .reversed()
                .map { String($0) }
                .dropFirst()
                .dropFirst()
            while parameterModes.count <= 3 {
                parameterModes.append("0")
            }
            let mode = parameterModes.compactMap { Int($0) }
            // CBA

            let optCode = memory[index].description
                .reversed()
                .map { String($0) }
                .joined()

            switch optCode {
            case let optCode where optCode.starts(with: "1"):
                // addition next to inputs and write in third output

                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0] == 0 ? memory[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? memory[secondInputIndex] : secondInputIndex
                memory[outputIndex] = first + second

                index += 4
            case let optCode where optCode.starts(with: "2"):
                // multiply next two

                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0] == 0 ? memory[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? memory[secondInputIndex] : secondInputIndex
                memory[outputIndex] = first * second

                index += 4
            case let optCode where optCode.starts(with: "3"):
                // save input

                let outputIndex = memory[index + 1]
                memory[outputIndex] = phaseSetting ?? input
                phaseSetting = nil

                index += 2
            case let optCode where optCode.starts(with: "4"):
                // return output

                let firstInputIndex = memory[index + 1]
                let output = mode[0] == 0 ? memory[firstInputIndex] : firstInputIndex
                print("Returning Amp\(name) with output: \(output)")

                currentOutput = output
                index += 2
                return output
            case let optCode where optCode.starts(with: "5"):
                // jump-if-true
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let first = mode[0] == 0 ? memory[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? memory[secondInputIndex] : secondInputIndex
                if first != 0 {
                    index = second
                } else {
                    index += 3
                }
            case let optCode where optCode.starts(with: "6"):
                // jump-if-false
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let first = mode[0] == 0 ? memory[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? memory[secondInputIndex] : secondInputIndex
                if first == 0 {
                    index = second
                } else {
                    index += 3
                }
            case let optCode where optCode.starts(with: "7"):
                // less than
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0] == 0 ? memory[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? memory[secondInputIndex] : secondInputIndex

                if first < second {
                    memory[outputIndex] = 1
                } else {
                    memory[outputIndex] = 0
                }

                index += 4
            case let optCode where optCode.starts(with: "8"):
                // equals
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0] == 0 ? memory[firstInputIndex] : firstInputIndex
                let second = mode[1] == 0 ? memory[secondInputIndex] : secondInputIndex

                if first == second {
                    memory[outputIndex] = 1
                } else {
                    memory[outputIndex] = 0
                }

                index += 4
            case let optCode where optCode.starts(with: "99"):
                // halting programm
                print("Halting Amp\(name) with output: \(currentOutput)")
                hit99 = true
                return currentOutput
            default:
                fatalError("invalid input")
            }
        } while true
    }
}

enum Day07 {
    static func solve() {
        let input = Input.get("07-Input.txt")
        print("Result Day 7 - Part One&Two: \(intcodeProgram(input: input))")
    }

    private static func intcodeProgram(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        var possibleOutputs: Set<Int> = []
        for feedbackPhaseSettings in permutations([5, 6, 7, 8, 9]) {
            print("--------- Next permutation Feedback Loop ---------")

            let amplifiers = [
                Amp(name: "A",
                    memory: originalInputAsNumbers),
                Amp(name: "B",
                    memory: originalInputAsNumbers),
                Amp(name: "C",
                    memory: originalInputAsNumbers),
                Amp(name: "D",
                    memory: originalInputAsNumbers),
                Amp(name: "E",
                    memory: originalInputAsNumbers)
            ]

            print("Prepare Feedback Loop Phase Settings")
            for (index, amplifier) in amplifiers.enumerated() {
                amplifier.phaseSetting = feedbackPhaseSettings[index]
            }

            print("Run Feedback Loop")
            var currentOutput = 0
            repeat {
                for amplifier in amplifiers {
                    currentOutput = amplifier.runProgramm(input: currentOutput)!
                }
            } while amplifiers.last!.hit99 == false
            possibleOutputs.insert(currentOutput)
        }

        return String(possibleOutputs.max()!)
    }
}
