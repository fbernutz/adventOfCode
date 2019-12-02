//
//  01-Day.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 01.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

/**
https://adventofcode.com/2019/day/1
*/

enum Day01 {
    static func solve() {
        let input = Input.get("01-Input.txt")
        print("Result Day 1 - Part One: \(calculateFuel(input: input))")
        print("Result Day 1 - Part Two: \(calculateFuelForFuel(input: input))")
    }

    private static func calculateFuel(input: String) -> String {
        let fuelRequirementInTotal = input.components(separatedBy: .newlines)
            .compactMap { Int($0) }
            .map { ($0 / 3) - 2 }
            .reduce(0, +)
        return String(fuelRequirementInTotal)
    }

    private static func calculateFuelForFuel(input: String) -> String {
        let fuelRequirementForModules = input.components(separatedBy: .newlines)
            .compactMap { Int($0) }
            .map { ($0 / 3) - 2 }

        var countInTotal: [Int] = []
        for fuelForModule in fuelRequirementForModules {
            var countForModule: [Int] = [fuelForModule]
            repeat {
                let result = (countForModule.last! / 3) - 2
                if result > 0 {
                    countForModule.append(result)
                } else {
                    let resultForModule = countForModule.reduce(0, +)
                    countInTotal.append(resultForModule)
                    break
                }
            } while true
        }
        return String(countInTotal.reduce(0, +))
    }
}
