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

        let fuel = Chemical(name: "FUEL")
        let ore = Chemical(name: "ORE")

        // Start from FUEL Output
        var lastReaction: Reaction? = reactions.first { $0.output.chemical == fuel }

        // count all chemicals from inputs
        var chemicalsWithNumber: [Chemical: Int] = lastReaction!
            .input
            .reduce(into: [:]) { result, input in
                result[input.chemical] = input.number
        }

        var newReactions: [Reaction] = []

        // find outputs for last chemicals lastReaction.input
        repeat {
            for input in lastReaction!.input {
//                if let newReaction = findReaction(for: input, in: reactions), !newReaction.input.contains(where: ore) {
//                    chemicalsWithNumber.removeValue(forKey: input.chemical)
//                    newReactions.append(newReaction)
//                }
            }

            for newReaction in newReactions {
                for input in newReaction.input {

                    if chemicalsWithNumber.keys.contains(input.chemical) {
                        chemicalsWithNumber[input.chemical]! += input.number
                    } else {
                        chemicalsWithNumber[input.chemical] = input.number
                    }
                }
            }
            //TODO: fix this?
            lastReaction = newReactions.last
        } while !newReactions.isEmpty
        print(chemicalsWithNumber.map { "\($0.key), \($0.value)" })

        // TODO: remove translated inputs
        //["Chemical(name: \"ORE\"), 41", "Chemical(name: \"A\"), 28", "Chemical(name: \"E\"), 1", "Chemical(name: \"D\"), 1", "Chemical(name: \"B\"), 1", "Chemical(name: \"C\"), 1"]
        return ""
    }

    private static func findReaction(for ingredient: (chemical: Chemical, number: Int), in reactions: [Reaction]) -> Reaction? {
        return reactions.first(where: { $0.output.chemical == ingredient.chemical })
    }

}

private struct Reaction {
    let input: [(chemical: Chemical, number: Int)]
    let output: (chemical: Chemical, number: Int)

    init(with line: String) {
        // e.g, "12 HKGWZ, 1 GPVTF, 8 PSHF => 9 QDVJ"
        let reaction = line
            .components(separatedBy: " => ")

        let input = reaction[0]
            .components(separatedBy: ", ")
            .map { makeChemical(from: $0) }
        let output = makeChemical(from: reaction[1])

        self.input = input
        self.output = output
    }
}

private struct Chemical: Hashable {
    let name: String
}

private func makeChemical(from input: String) -> (chemical: Chemical, number: Int) {
    let inputs = input.components(separatedBy: .whitespaces)
    let chemical = Chemical(name: inputs[1])
    let number = Int(inputs[0])!
    return (chemical, number)
}
