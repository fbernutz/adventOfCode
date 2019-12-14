import Foundation

/**
 https:adventofcode.com/2019/day/14
 */

enum Day14 {
    static func solve() {
        let input = Input.get("14-Input.txt")
        print("Result Day 14 - Part One: \(numberOfOreForFuelForPart1(input: input))")
//        print("Result Day 14 - Part Two: \(findExactPositionInTimeForPart2(input: input))")
    }

    private static func numberOfOreForFuelForPart1(input: String) -> String {
        let reactions = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map(Reaction.init)

        let ore = Chemical(name: "ORE")
        let fuel = Chemical(name: "FUEL")

        return ""
    }

    private static func forPart2(input: String) -> String {
        return ""
    }
}

private struct Reaction {
    let input: [Chemical: Int]
    let output: [Chemical: Int]

    init(with line: String) {
        // 12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ
        // 165 ORE => 6 DCFZ
        let reaction = line
            .components(separatedBy: " => ")

        let inputs = reaction[0]
            .components(separatedBy: ", ")
        // TODO:
        let inputChemicals = [Chemical(name: ""): 5]
        self.input = inputChemicals

        let output = reaction[1]
            .components(separatedBy: .whitespaces)
        let chemicalOutput = Chemical(name: output[1])
        let numberOfOutput = Int(output[0])!
        self.output = [chemicalOutput: numberOfOutput]
    }
}

private struct Chemical: Hashable {
    let name: String
}
