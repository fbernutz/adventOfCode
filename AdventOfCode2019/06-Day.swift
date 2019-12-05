//
//  02-Day.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 02.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

/**
 https://adventofcode.com/2019/day/6
 */

private struct OrbitConstellation {
    let orbit: String
    let center: String

    init(input: String) {
        let elements = input.split(separator: ")")
        center = String(elements[0])
        orbit = String(elements[1])
    }

    func countConnections(for constellations: [OrbitConstellation]) -> Int {
        var count = 1
        var constellation = findConstellation(for: center, in: constellations)
        while true {
            guard constellation != nil else { break }
            constellation = findConstellation(for: constellation!.center, in: constellations)
            count += 1
        }
        return count
    }

    func findConstellation(for center: String, in constellations: [OrbitConstellation]) -> OrbitConstellation? {
        return constellations.filter { $0.orbit == center }.first
    }

}

enum Day06 {
    static func solve() {
        let input = Input.get("06-Input.txt")
        print("Result Day 6 - Part One: \(countOrbitChecksums(input: input))")
//        print("Result Day 6 - Part Two: \(findValidPasswordsForPart2(input: input))")
    }

    private static func countOrbitChecksums(input: String) -> String {
        let constellations = input
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map(OrbitConstellation.init)

        var count = 0
        for constellation in constellations {
            let connections = constellation.countConnections(for: constellations)
//            print("\(constellation.center): \(connections)")
            count += connections
        }

        return String(count)
    }

}
