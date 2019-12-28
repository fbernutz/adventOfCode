import Foundation

/**
 https:adventofcode.com/2019/day/16
 */

enum Day16 {
    static func solve() {
        let input = Input.get("16-Input.txt")
        print(Date())
//        print("Result Day 16 - Part One: \(fftAfter100PhasesForPart1(input: input))")
        print("Result Day 16 - Part Two: \(fftAfter100PhasesWithMessageOffsetForPart2(input: input))")
        print(Date())
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

    private static func fftAfter100PhasesWithMessageOffsetForPart2(input: String) -> String {
        let inputs = input.compactMap { Int(String($0)) }

        let lengthOfOffset = 7
        let offset = Int(
            inputs
                .prefix(lengthOfOffset)
                .map { String($0) }
                .joined()
            )!
        var currentOutput = Array([[Int]](repeating: inputs, count: 10000).flatMap { $0 }[offset...])

        let numberOfPhases = 100
        for _ in 0..<numberOfPhases {
            currentOutput.makeTransformation2()
        }

        let result = currentOutput.prefix(8).map { String($0) }.joined()
        assert(result == "14288025")
        return result
    }

}

private extension Array where Element == Int {

    mutating func makeTransformation() {
        var transformedNumbers: [Int] = []

        for lineIndex in 0..<count {
            var transformed = 0

            for index in 0..<count {
                transformed += self[index] * currentPattern(for: lineIndex, index: index)!
            }

            transformedNumbers.append(transformed.onesDigit)
        }

        self = transformedNumbers
    }

    // this helped:
    // https://imgur.com/wAJ1zEj
    // https://www.reddit.com/r/adventofcode/comments/ebai4g/2019_day_16_solutions/
    mutating func makeTransformation2() {
        var sum = 0
        for index in (0..<count).reversed() {
            sum += self[index]
            self[index] = sum.onesDigit
        }
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
        return self % 10
    }
}

