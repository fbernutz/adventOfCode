import Foundation

/**
 https:adventofcode.com/2019/day/9
 */

enum Day09 {
    static func solve() {
        let input = Input.get("09-Input.txt")
        print("Result Day 9 - Part One: \(parseImageDataForPart1(input: input))")
        print("Result Day 9 - Part Two: \(printImageDataForPart2(input: input))")
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
