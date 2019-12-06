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

    func makeChain(with constellations: [OrbitConstellation]) -> [String] {
        var constellation = findConstellation(for: center, in: constellations)
        var array: [String] = [orbit, center]
        while true {
            guard constellation != nil else { break }
            array.append(constellation!.center)
            constellation = findConstellation(for: constellation!.center, in: constellations)
        }
        return array.compactMap { $0 }
    }

}

enum Day06 {
    static func solve() {
        let input = Input.get("06-Input.txt")
//        print("Result Day 6 - Part One: \(countOrbitChecksums(input: input))")
        print("Result Day 6 - Part Two: \(countMinimumTransfersToSanta(input: input))")
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

    private static func countMinimumTransfersToSanta(input: String) -> String {
        let constellations = input
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map(OrbitConstellation.init)

        // Make chain from YOU and SAN
        let chainYou = constellations
            .filter { $0.orbit == "YOU" }
            .first!
            .makeChain(with: constellations)
        let chainSanta = constellations
            .filter { $0.orbit == "SAN" }
            .first!
            .makeChain(with: constellations)

        // find intersection
        let intersection = chainYou.filter { chainSanta.contains($0) }.first!

        // count from YOU to intersection, exclusive YOU
        let stepsToIntersectionFromYou = Int(chainYou.firstIndex(of: intersection)!) - 1
        // count from SAN to intersection, exclusive SAN
        let stepsToIntersectionFromSanta = Int(chainSanta.firstIndex(of: intersection)!) - 1

        // sum
        let steps = stepsToIntersectionFromYou + stepsToIntersectionFromSanta

        return String(steps)
    }

}
