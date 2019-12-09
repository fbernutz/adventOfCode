import Foundation

/**
 https:adventofcode.com/2019/day/10
 */

enum Day10 {
    static func solve() {
        let input = Input.get("10-Input.txt")
        print("Result Day 10 - Part One: \(intcodeProgram(input: input, with: 1))")
        print("Result Day 10 - Part One: \(intcodeProgram(input: input, with: 2))")
    }

    private static func intcodeProgram(input: String, with programmInput: Int) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        let computer = Computer(
            name: "A",
            memory: originalInputAsNumbers)
        let output = computer.runProgramm(input: programmInput)!

        return String(output)
    }
}
