//
//  02-Day.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 02.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

/**
 https:adventofcode.com/2019/day/8
 */

private struct Layer {
    let width: Int
    let content: [Int]

    init(with input: String, width: Int) {
        content = input.compactMap { $0.wholeNumberValue }
        self.width = width
    }

    init(with content: [Int], width: Int) {
        self.content = content
        self.width = width
    }

    var output: String {
        var output = String(content.flatMap { String($0) })
        for index in 0..<content.count / width {
            let index = String.Index(utf16Offset: index * (width + 1), in: output)
            output.insert("\n", at: index)
        }
        output = output.replacingOccurrences(of: "0", with: "◾️")
        output = output.replacingOccurrences(of: "1", with: "⬜️")
        return output
    }
}

extension Layer: Comparable {
    static func < (lhs: Layer, rhs: Layer) -> Bool {
        lhs.content.filter { $0 == 0 }.count
            < rhs.content.filter { $0 == 0 }.count
    }
}

enum Day08 {
    static let width = 25
    static let height = 6

    static func solve() {
        let input = Input.get("08-Input.txt")
        print("Result Day 8 - Part One: \(parseImageData(input: input))")
        print("Result Day 8 - Part Two: \(printImageData(input: input))")
    }

    private static func parseImageData(input: String) -> String {
        var input = input

        let numberOfPixels = width * height

        let lowerBound = String.Index(utf16Offset: 0, in: input)
        let upperBound = String.Index(utf16Offset: numberOfPixels, in: input)

        // format input
        var formattedInput: [String] = []
        for _ in 0..<input.count / numberOfPixels {
            let line = String(input[lowerBound..<upperBound])
            formattedInput.append(line)
            input = String(input.dropFirst(numberOfPixels))
        }

        let layers = formattedInput.map { Layer(with: $0, width: width) }

        let layerWithFewestZeroDigits = layers.sorted(by: <).first!
        let result = layerWithFewestZeroDigits.content.filter { $0 == 1 }.count * layerWithFewestZeroDigits.content.filter { $0 == 2 }.count
        return String(result)
    }

    /**
     0 is black, 1 is white, and 2 is transparent.
     */
    private static func printImageData(input: String) -> String {
        var input = input

        let numberOfPixels = width*height

        let lowerBound = String.Index(utf16Offset: 0, in: input)
        let upperBound = String.Index(utf16Offset: numberOfPixels, in: input)

        // format input
        var formattedInput: [String] = []
        for _ in 0..<input.count / numberOfPixels {
            let line = String(input[lowerBound..<upperBound])
            formattedInput.append(line)
            input = String(input.dropFirst(numberOfPixels))
        }

        let layers = formattedInput.map { Layer(with: $0, width: width) }

        // determine image with all layers
        var newContent: [Int] = []
        for pixelIndex in 0..<numberOfPixels {
            let pixels = layers.map { $0.content[pixelIndex] }
            let outputPixel = determinePixel(for: pixels)
            newContent.append(outputPixel)
        }
        return Layer(with: newContent, width: width).output
    }

    private static func determinePixel(for pixelPerLayer: [Int]) -> Int {
        // 0,1,2,0 -> 0
        // 2,1,2,0 -> 1
        // 2,2,1,0 -> 1
        // 2,2,2,0 -> 0

        var pixels = pixelPerLayer
        pixels.removeAll { $0 == 2 }
        return pixels.first ?? 2
    }
}
