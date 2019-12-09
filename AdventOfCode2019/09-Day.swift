import Foundation

/**
 https:adventofcode.com/2019/day/9
 */

enum Day09 {
    static func solve() {
        let input = Input.get("09-Input.txt")
        print("Result Day 9 - Part One: \(intcodeProgram(input: input))")
//        print("Result Day 9 - Part Two: \(printImageDataForPart2(input: input))")
    }

    private static func intcodeProgram(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        let computer = Computer(
            name: "A",
            memory: originalInputAsNumbers)
        let output = computer.runProgramm(input: 1)!

        return String(output)
    }
}
