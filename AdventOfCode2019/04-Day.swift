import Foundation

/**
https://adventofcode.com/2019/day/4
*/

enum Day04 {
    static func solve() {
        let input = Input.get("04-Input.txt")
        print("Result Day 4 - Part One: \(findValidPasswordsForPart1(input: input))")
        print("Result Day 4 - Part Two: \(findValidPasswordsForPart2(input: input))")
    }

    private static func findValidPasswordsForPart1(input: String) -> String {
        let range = prepareInput(input: input)
        return String(range.filter { $0.description.isValidPasswordForPart1 }.count)
    }

    private static func findValidPasswordsForPart2(input: String) -> String {
        let range = prepareInput(input: input)
        return String(range.filter { $0.description.isValidPasswordForPart2 }.count)
    }
}

private extension String {
    var isValidPasswordForPart1: Bool {
        count == 6
        && containsMinimumTwoEqualLetters
        && containsOnlyIncreasingNumbers
    }

    var isValidPasswordForPart2: Bool {
        count == 6
        && containsTwoEqualLetters
        && containsOnlyIncreasingNumbers
    }

    var containsMinimumTwoEqualLetters: Bool {
        let letterCount = reduce(into: [:]) { counts, letter in
            counts[letter, default: 0] += 1
        }
        return !letterCount.values.filter { $0 >= 2 }.isEmpty
    }

    var containsTwoEqualLetters: Bool {
        let letterCount = reduce(into: [:]) { counts, letter in
            counts[letter, default: 0] += 1
        }
        return !letterCount.values.filter { $0 == 2 }.isEmpty
    }

    var containsOnlyIncreasingNumbers: Bool {
        var digits: [Int] = []
        for (index, character) in enumerated() {
            let digit = Int(String(character))!
            if digits.isEmpty || digits[index - 1] <= digit {
                digits.append(digit)
            } else {
                return false
            }
        }
        return true
    }
}

extension Day04 {
    private static func prepareInput(input: String) -> Range<Int> {
        let input = input
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: "-")
            .compactMap { Int($0) }

        return Range(uncheckedBounds: (lower: input[0], upper: input[1]))
    }
}
