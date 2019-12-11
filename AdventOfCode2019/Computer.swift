//
//  Computer.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 09.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

class Computer {
    let name: String
    var memory: [Int] = []
    var index: Int = 0
    var relativeBase: Int = 0
    var phaseSetting: Int?
    var hit99: Bool = false
    var shouldReturnAt4: Bool = true

    init(name: String = "A", memory: [Int]) {
        self.name = name
        self.memory = memory
    }

    init(name: String = "A", rawMemory: String) {
        self.name = name
        memory = rawMemory
            .components(separatedBy: ",")
            .compactMap { Int($0) }
    }

    /**
     - 0, position mode: the parameter to be interpreted as a position
     if the parameter is 50, its value is the value stored at address 50 in memory

     - 1, immediate mode: the parameter is interpreted as a value
     if the parameter is 50, its value is simply 50.

     - 2, relative mode: the parameter is interpreted as a position
     Like position mode, parameters in relative mode can be read from or written to. Relative mode parameters don't count from address 0. Instead, they count from a value called the relative base. The relative base starts at 0.
     */
    private enum ParameterMode: Int {
        case position
        case immediate
        case relative

        func readValue(for index: Int, memory: [Int], relativeBaseOffset: Int) -> Int {
            switch self {
            case .position:
                return memory[safe: index]
            case .immediate:
                return index
            case .relative:
                return memory[safe: relativeBaseOffset + index]
            }
        }

        func write(for index: Int, relativeBaseOffset: Int) -> Int {
            switch self {
            case .position:
                return index
            case .immediate,
                 .relative:
                return relativeBaseOffset + index
            }
        }
    }

    private enum Opcode: Int {
        case add = 1
        case multiply
        case write
        case read
        case jumpIfTrue
        case jumpIfFalse
        case lessThan
        case equals
        case adjustRelativeBase
        case halt = 99
    }

    func runProgramm(input: Int) -> Int? {
//        print("Running Computer \(name) with input: \(input)")
        var currentOutput = input

        while true {
            let position = memory[safe: index]
            let modes = parameterModes(for: position)

            guard let opcode = Opcode(rawValue: position % 100) else {
                fatalError("invalid input")
            }

            switch opcode {
            case .add:
                let firstInputIndex = memory[safe: index + 1]
                let secondInputIndex = memory[safe: index + 2]
                let outputIndex = memory[safe: index + 3]
                let first = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = modes[1].readValue(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let output = modes[2].write(for: outputIndex, relativeBaseOffset: relativeBase)
                memory[safe: output] = first + second

                index += 4
            case .multiply:
                let firstInputIndex = memory[safe: index + 1]
                let secondInputIndex = memory[safe: index + 2]
                let outputIndex = memory[safe: index + 3]
                let first = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = modes[1].readValue(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let output = modes[2].write(for: outputIndex, relativeBaseOffset: relativeBase)
                memory[safe: output] = first * second

                index += 4
            case .write:
                let outputIndex = memory[safe: index + 1]
                let output = modes[0].write(for: outputIndex, relativeBaseOffset: relativeBase)
                memory[safe: output] = phaseSetting ?? input
                phaseSetting = nil

                index += 2
            case .read:
                let firstInputIndex = memory[safe: index + 1]
                let output = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
//                print("Returning Amp\(name) with output: \(output)")

                currentOutput = output
                index += 2
                if shouldReturnAt4 {
                    return output
                }
            case .jumpIfTrue:
                let firstInputIndex = memory[safe: index + 1]
                let secondInputIndex = memory[safe: index + 2]
                let first = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = modes[1].readValue(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if first != 0 {
                    index = second
                } else {
                    index += 3
                }
            case .jumpIfFalse:
                let firstInputIndex = memory[safe: index + 1]
                let secondInputIndex = memory[safe: index + 2]
                let first = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = modes[1].readValue(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                if first == 0 {
                    index = second
                } else {
                    index += 3
                }
            case .lessThan:
                let firstInputIndex = memory[safe: index + 1]
                let secondInputIndex = memory[safe: index + 2]
                let outputIndex = memory[safe: index + 3]
                let first = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = modes[1].readValue(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let output = modes[2].write(for: outputIndex, relativeBaseOffset: relativeBase)

                if first < second {
                    memory[safe: output] = 1
                } else {
                    memory[safe: output] = 0
                }

                index += 4
            case .equals:
                let firstInputIndex = memory[safe: index + 1]
                let secondInputIndex = memory[safe: index + 2]
                let outputIndex = memory[safe: index + 3]
                let first = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let second = modes[1].readValue(for: secondInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                let output = modes[2].write(for: outputIndex, relativeBaseOffset: relativeBase)

                if first == second {
                    memory[safe: output] = 1
                } else {
                    memory[safe: output] = 0
                }

                index += 4
            case .adjustRelativeBase:
                // adjusts the relative base
                let firstInputIndex = memory[safe: index + 1]
                let first = modes[0].readValue(for: firstInputIndex, memory: memory, relativeBaseOffset: relativeBase)
                relativeBase += first

                index += 2
            case .halt:
//                print("Halting Computer\(name) with output: \(currentOutput)")
                hit99 = true
                return currentOutput
            }
        }
    }

    private func parameterModes(for value: Int) -> [Computer.ParameterMode] {
        // ABCDE
        // A: if empty -> 0, parameter mode
        // B: parameter mode
        // C: parameter mode
        // DE: opcode, 02 etc.

        var parameterModes = value.description
            .reversed()
            .map { String($0) }
            .dropFirst()
            .dropFirst()
        while parameterModes.count < 4 {
            parameterModes.append("0")
        }

        // CBA
        let modes = parameterModes
            .compactMap { Int($0) }
            .map { ParameterMode(rawValue: $0)! }
        return modes
    }
}

private extension Array where Element == Int {
    subscript(safe index: Int) -> Element {
        get {
            if index >= count {
                return 0
            } else {
                return self[index]
            }
        }

        set {
            if index >= count {
                self += Array(repeating: 0, count: index - count + 1)
            }
            self[index] = newValue
        }
    }
}
