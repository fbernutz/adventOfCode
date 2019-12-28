import Foundation

/**
 https:adventofcode.com/2019/day/16
 */

enum Day16 {
    static func solve() {
        let input = Input.get("16-Input.txt")
        print(Date())
        print("Result Day 16 - Part One: \(fftAfter100PhasesForPart1(input: input))")
        print(Date())
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

private extension Array where Element == Int {

    mutating func makeTransformation() {
        var transformedNumbers: [Int] = []

        for lineIndex in 0..<count {
            var transformed = 0

            for (index, element) in enumerated() {
                // 1. multiply value in array with pattern
                // 2. adding up results
                transformed += element * currentPattern(for: lineIndex, index: index)!
            }

            transformedNumbers.append(transformed.onesDigit)
        }

        self = transformedNumbers
    }

    func currentPattern(for lineIndex: Int, index: Int) -> Int? {
        // repeating based on index
        // index 0: 0, 1, 0, -1
        // index 1: 0, 0, 1, 1, 0, 0, -1, -1
        // ...

        switch ((index + 1) / (lineIndex + 1)) % 4 {
        case 0:
            return 0
        case 1:
            return 1
        case 2:
            return 0
        case 3:
            return -1
        default:
            fatalError("Should not happen")
        }
    }
}

private extension Int {
    var onesDigit: Int {
        return String(describing: self).compactMap { Int(String($0)) }.last!
    }
}

