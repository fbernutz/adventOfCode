import Foundation

/**
 https://adventofcode.com/2019/day/5
 */

enum Day05 {
    static func solve() {
        let input = Input.get("05-Input.txt")
        print("Result Day 5 - Part One: \(intcodeProgramForPart1(input: input))")
        print("Result Day 5 - Part Two: \(intcodeProgramForPart2(input: input))")
    }

    private static func intcodeProgramForPart1(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        let computer = Computer(memory: originalInputAsNumbers)
        computer.shouldReturnAt4 = false
        guard let output = computer.runProgramm(input: 1)
            else { return "should not happen" }

        assert(output == 7839346)
        return String(output)
    }

    private static func intcodeProgramForPart2(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        let computer = Computer(memory: originalInputAsNumbers)
        guard let output = computer.runProgramm(input: 5)
            else { return "should not happen" }

        assert(output == 447803)
        return String(output)
    }

}
