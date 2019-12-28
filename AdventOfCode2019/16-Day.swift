import Foundation

/**
 https:adventofcode.com/2019/day/16
 */

enum Day16 {
    static func solve() {
        let input = Input.get("16-Input.txt")
        print("Result Day 16 - Part One: \(fftAfter100PhasesForPart1(input: input))")
        //        print("Result Day 16 - Part Two: \(findExactPositionInTimeForPart2(input: input))")
    }

    private static func fftAfter100PhasesForPart1(input: String) -> String {
        let inputs = input.compactMap { Int(String($0)) }

        var currentOutput = inputs

        let numberOfPhases = 100
        for _ in 0..<numberOfPhases {
            currentOutput.makeTransformation()
        }

        let result = currentOutput.prefix(8).map { String($0) }.joined()
        assert(result == "10332447")
        return result
    }

}

extension Array where Element == Int {
    mutating func makeTransformation() {
        let basePattern = [0, 1, 0, -1]

        var transformedNumbers: [Int] = []
        for (lineIndex, _) in enumerated() {
            // repeating based on index
            // index 0: 0, 1, 0, -1
            // index 1: 0, 0, 1, 1, 0, 0, -1, -1
            // ...
            var pattern: [Int] = []
            while pattern.count < count + 1 {
                pattern.append(contentsOf: Array(repeating: basePattern[0], count: lineIndex + 1))
                pattern.append(contentsOf: Array(repeating: basePattern[1], count: lineIndex + 1))
                pattern.append(contentsOf: Array(repeating: basePattern[2], count: lineIndex + 1))
                pattern.append(contentsOf: Array(repeating: basePattern[3], count: lineIndex + 1))
            }

            var transformed = 0
            for (index, element) in enumerated() {
                // skip the first value once
                if index == 0 {
                    pattern = Array(pattern.dropFirst())
                }

                // 1. multiply value in array with pattern
                let newValue = element * pattern.first!

                // 2. adding up results
                transformed += newValue

                pattern = Array(pattern.dropFirst())
            }
            transformedNumbers.append(transformed.onesDigit)
        }

        self = transformedNumbers
    }
}

private extension Int {
    var onesDigit: Int {
        return String(describing: self).compactMap { Int(String($0)) }.last!
    }
}

