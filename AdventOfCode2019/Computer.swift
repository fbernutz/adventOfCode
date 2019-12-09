//
//  Computer.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 09.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

class Computer {
    var name: String
    var memory: [Int] = []
    var index: Int = 0
    var phaseSetting: Int?
    var hit99: Bool = false

    init(name: String, memory: [Int]) {
        self.name = name
        self.memory = memory
    }

    enum ParameterMode: Int {
        case position
        case immediate

        func value(for index: Int, memory: [Int]) -> Int {
            switch self {
            case .position:
                return memory[index]
            case .immediate:
                return index
            }
        }
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
            let mode = parameterModes
                .compactMap { Int($0) }
                .map { ParameterMode(rawValue: $0)! }
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
                let first = mode[0].value(for: firstInputIndex, memory: memory)
                let second = mode[1].value(for: secondInputIndex, memory: memory)
                memory[outputIndex] = first + second

                index += 4
            case let optCode where optCode.starts(with: "2"):
                // multiply next two

                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0].value(for: firstInputIndex, memory: memory)
                let second = mode[1].value(for: secondInputIndex, memory: memory)
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
                let output = mode[0].value(for: firstInputIndex, memory: memory)
                print("Returning Amp\(name) with output: \(output)")

                currentOutput = output
                index += 2
                return output
            case let optCode where optCode.starts(with: "5"):
                // jump-if-true
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let first = mode[0].value(for: firstInputIndex, memory: memory)
                let second = mode[1].value(for: secondInputIndex, memory: memory)
                if first != 0 {
                    index = second
                } else {
                    index += 3
                }
            case let optCode where optCode.starts(with: "6"):
                // jump-if-false
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let first = mode[0].value(for: firstInputIndex, memory: memory)
                let second = mode[1].value(for: secondInputIndex, memory: memory)
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
                let first = mode[0].value(for: firstInputIndex, memory: memory)
                let second = mode[1].value(for: secondInputIndex, memory: memory)

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
                let first = mode[0].value(for: firstInputIndex, memory: memory)
                let second = mode[1].value(for: secondInputIndex, memory: memory)

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
