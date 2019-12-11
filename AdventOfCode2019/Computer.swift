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
    var relativeBase: Int = 0
    var phaseSetting: Int?
    var hit99: Bool = false

    init(name: String = "A", memory: [Int]) {
        self.name = name
        self.memory = memory
    }

    enum ParameterMode: Int {
        case position
        case immediate
        case relative

        func value(for index: Int, memory: [Int], relativeBaseOffset: Int) -> Int {
            switch self {
            case .position:
                return memory[index]
            case .immediate:
                return index
            case .relative:
                return memory[relativeBaseOffset + index]
            }
        }

        func write(for index: Int, memory: [Int], relativeBaseOffset: Int) -> Int {
            switch self {
            case .position:
                return index
            case .relative,
                 .immediate:
                return relativeBaseOffset + index
            }
        }
    }

    func runProgramm(input: Int) -> Int? {
//        print("Running Amp\(name) with input: \(input)")
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

            let opcode = memory[index].description
                .reversed()
                .map { String($0) }
                .joined()

            switch opcode {
            case let opcode where opcode.starts(with: "1"):
                // addition next to inputs and write in third output

                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = mode[1].value(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let output = mode[2].write(for: outputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if output + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: output + relativeBase - memory.count + 1))
                }
                memory[output] = first + second

                index += 4
            case let opcode where opcode.starts(with: "2"):
                // multiply next two

                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                if firstInputIndex + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: firstInputIndex + relativeBase - memory.count + 1))
                }
                let first = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if secondInputIndex + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: secondInputIndex + relativeBase - memory.count + 1))
                }
                let second = mode[1].value(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if outputIndex + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: outputIndex + relativeBase - memory.count + 1))
                }
                let output = mode[2].write(for: outputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if output + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: output + relativeBase - memory.count + 1))
                }
                memory[output] = first * second

                index += 4
            case let opcode where opcode.starts(with: "3"):
                // save input

                let outputIndex = memory[index + 1]
                let output = mode[0].write(for: outputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if output + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: output + relativeBase - memory.count + 1))
                }
                memory[output] = phaseSetting ?? input
                phaseSetting = nil

                index += 2
            case let opcode where opcode.starts(with: "4"):
                // return output

                let firstInputIndex = memory[index + 1]
                let output = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
//                print("Returning Amp\(name) with output: \(output)")

                currentOutput = output
                index += 2
                return output
            case let opcode where opcode.starts(with: "5"):
                // jump-if-true
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let first = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = mode[1].value(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if first != 0 {
                    index = second
                } else {
                    index += 3
                }
            case let opcode where opcode.starts(with: "6"):
                // jump-if-false
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let first = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = mode[1].value(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if first == 0 {
                    index = second
                } else {
                    index += 3
                }
            case let opcode where opcode.starts(with: "7"):
                // less than
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = mode[1].value(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let output = mode[2].write(for: outputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if output + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: output + relativeBase - memory.count + 1))
                }

                if first < second {
                    memory[output] = 1
                } else {
                    memory[output] = 0
                }

                index += 4
            case let opcode where opcode.starts(with: "8"):
                // equals
                let firstInputIndex = memory[index + 1]
                let secondInputIndex = memory[index + 2]
                let outputIndex = memory[index + 3]
                let first = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = mode[1].value(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let output = mode[2].write(for: outputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if output + relativeBase > memory.count {
                    memory.append(contentsOf: Array(repeating: 0, count: output + relativeBase - memory.count + 1))
                }

                if first == second {
                    memory[output] = 1
                } else {
                    memory[output] = 0
                }

                index += 4
            case let opcode where opcode.starts(with: "99"):
                // halting programm
//                print("Halting Amp\(name) with output: \(currentOutput)")
                hit99 = true
                return currentOutput
            case let opcode where opcode.starts(with: "9"):
                // adjusts the relative base
                let firstInputIndex = memory[index + 1]
                let first = mode[0].value(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                relativeBase += first
                
                index += 2
            default:
                fatalError("invalid input")
            }
        } while true
    }
}
