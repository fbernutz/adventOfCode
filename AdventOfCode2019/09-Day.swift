import Foundation

/**
 https:adventofcode.com/2019/day/9
 */

enum Day09 {
    static func solve() {
        let input = Input.get("09-Input.txt")
        print("Result Day 9 - Part One: \(intcodeProgramForPart1(input: input))")
        print("Result Day 9 - Part Two: \(intcodeProgramForPart2(input: input))")
    }

    private static func intcodeProgramForPart1(input: String) -> String {
        let memory = prepareInput(input: input)
        let computer = Computer(memory: memory)
        let output = computer.runProgramm(input: 1)!

        assert(output == 2399197539)
        return String(output)
    }

    private static func intcodeProgramForPart2(input: String) -> String {
        let memory = prepareInput(input: input)
        let computer = Computer(memory: memory)
        let output = computer.runProgramm(input: 2)!

        assert(output == 35106)
        return String(output)
    }
}

extension Day09 {
    private static func prepareInput(input: String) -> [Int] {
        return input.components(separatedBy: ",")
            .compactMap { Int($0) }
    }
}
