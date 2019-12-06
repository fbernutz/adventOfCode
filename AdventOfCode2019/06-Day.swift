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
        return makeChain(with: [center], from: constellations).count
    }

    func makeChain(with constellations: [OrbitConstellation]) -> [String] {
        return makeChain(with: [center, orbit], from: constellations)
    }

    private func makeChain(with input: [String], from constellations: [OrbitConstellation]) -> [String] {
        var constellation = findConstellation(for: center, in: constellations)
        var array = input
        while constellation != nil {
            array.append(constellation!.center)
            constellation = findConstellation(for: constellation!.center, in: constellations)
        }
        return array
    }

    private func findConstellation(for center: String, in constellations: [OrbitConstellation]) -> OrbitConstellation? {
        return constellations.first { $0.orbit == center }
    }

}

enum Day06 {
    static func solve() {
        let input = Input.get("06-Input.txt")
        print(Date())
        print("Result Day 6 - Part One: \(countOrbitChecksums(input: input))")
//        print("Result Day 6 - Part Two: \(countMinimumTransfersToSanta(input: input))")
        print(Date())
    }

    private static func countOrbitChecksums(input: String) -> String {
        let constellations = input
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map(OrbitConstellation.init)

        let count = constellations
            .map { $0.countConnections(for: constellations) }
            .reduce(0,+)
        return String(count)
    }

    private static func countMinimumTransfersToSanta(input: String) -> String {
        let constellations = input
            .components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map(OrbitConstellation.init)

        let chainYou = constellations
            .first { $0.orbit == "YOU" }!
            .makeChain(with: constellations)
        let chainSanta = constellations
            .first { $0.orbit == "SAN" }!
            .makeChain(with: constellations)

        let intersection = chainYou.first { chainSanta.contains($0) }!

        // count from YOU and SAN to intersection, exclusive YOU and SAN
        let stepsToIntersectionFromYou = Int(chainYou.firstIndex(of: intersection)!) - 1
        let stepsToIntersectionFromSanta = Int(chainSanta.firstIndex(of: intersection)!) - 1

        return String(stepsToIntersectionFromYou + stepsToIntersectionFromSanta)
    }

}
