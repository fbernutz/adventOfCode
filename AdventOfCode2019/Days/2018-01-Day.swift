//
//  Day01.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 30.11.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

/**
https://adventofcode.com/2018/day/1
*/

enum Day01 {
    static func solve() {
        let input = Input.get("2018-01-Input.txt")
        print("Result 2018 Day 1 - Part One: \(countFrequency(input: input))")
        print("Result 2018 Day 1 - Part Two: \(findDoubleFrequency(input: input))")
    }

    private static func countFrequency(input: String) -> String {
        let numbers = input.components(separatedBy: .newlines)
            .compactMap { Int($0) }
        return String(numbers.reduce(0, +))
    }

    private static func findDoubleFrequency(input: String) -> String {
        var frequencies: Set<Int> = []
        var counter = 0

        let numbers = input.components(separatedBy: .newlines)
            .compactMap { Int($0) }

        repeat {
            for number in numbers {
                counter += number

                if frequencies.contains(counter) {
                    return String(counter)
                } else {
                    frequencies.insert(counter)
                }
            }
        } while true
    }
}
