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

    var formattedOutput: String {
        var output = String(content.flatMap { String($0) })
        for index in 0..<content.count / width {
            let index = String.Index(utf16Offset: index * (width + 1), in: output)
            output.insert("\n", at: index)
        }
        output = output.replacingOccurrences(of: "0", with: "◾️")
        output = output.replacingOccurrences(of: "1", with: "⬜️")
        output = output.replacingOccurrences(of: "2", with: "🧊")
        return output
    }
}

enum Day08 {
    static let width = 25
    static let height = 6
    static var numberOfPixels: Int {
        width * height
    }

    static func solve() {
        let input = Input.get("08-Input.txt")
        print("Result Day 8 - Part One: \(parseImageDataForPart1(input: input))")
        print("Result Day 8 - Part Two: \(printImageDataForPart2(input: input))")
    }

    private static func parseImageDataForPart1(input: String) -> String {
        let layers = parseImageData(input)

        let layerWithFewestZeroDigits = layers.min {
            $0.content.filter { $0 == 0 }.count < $1.content.filter { $0 == 0 }.count
        }!
        let numberOfOneDigit = layerWithFewestZeroDigits.content.filter { $0 == 1 }.count
        let numberOfTwoDigit = layerWithFewestZeroDigits.content.filter { $0 == 2 }.count
        return String(numberOfOneDigit * numberOfTwoDigit)
    }

    private static func printImageDataForPart2(input: String) -> String {
        let layers = parseImageData(input)

        var newContent: [Int] = []
        for pixelIndex in 0..<numberOfPixels {
            let pixels = layers.map { $0.content[pixelIndex] }
            let outputPixel = pixels.first { $0 != 2 } ?? 2
            newContent.append(outputPixel)
        }
        return Layer(with: newContent, width: width).formattedOutput
    }

    private static func parseImageData(_ input: String) -> [Layer] {
        var input = input

        let lowerBound = String.Index(utf16Offset: 0, in: input)
        let upperBound = String.Index(utf16Offset: numberOfPixels, in: input)

        var formattedInput: [String] = []
        for _ in 0..<input.count / numberOfPixels {
            let line = String(input[lowerBound..<upperBound])
            formattedInput.append(line)
            input = String(input.dropFirst(numberOfPixels))
        }

        let layers = formattedInput.map { Layer(with: $0, width: width) }
        return layers
    }
}
