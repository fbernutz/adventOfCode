import Foundation

/**
https://adventofcode.com/2019/day/2
*/

enum Day02 {
    static func solve() {
        let input = Input.get("02-Input.txt")
        print("Result Day 2 - Part One & Two: \(intcodeProgram(input: input))")
    }

    private static func intcodeProgram(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        var numbers = originalInputAsNumbers

        // maniupulate numbers for start
        numbers[1] = 12
        numbers[2] = 2

        for index in numbers.indices where (index % 4 == 0) {
            switch numbers[index] {
            case 1:
                // addition next to inputs and write in third output
                let outputIndex = numbers[index + 3]
                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                numbers[outputIndex] = numbers[firstInputIndex] + numbers[secondInputIndex]
            case 2:
                // multiply next two
                let outputIndex = numbers[index + 3]
                let firstInputIndex = numbers[index + 1]
                let secondInputIndex = numbers[index + 2]
                numbers[outputIndex] = numbers[firstInputIndex] * numbers[secondInputIndex]
            case 99:
                // halting programm
                return String(numbers[0])
            default:
                continue
            }
        }

        return "should not happen"
    }

}
