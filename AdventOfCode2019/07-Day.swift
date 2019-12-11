import Foundation

/**
 https:adventofcode.com/2019/day/7
 */

enum Day07 {
    static func solve() {
        let input = Input.get("07-Input.txt")
        print("Result Day 7 - Part One & Two: \(intcodeProgram(input: input))")
    }

    private static func intcodeProgram(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        var possibleOutputs: Set<Int> = []
        for feedbackPhaseSettings in permutations([5, 6, 7, 8, 9]) {
            print("--------- Next permutation Feedback Loop ---------")

            let amplifiers = [
                Computer(name: "A",
                    memory: originalInputAsNumbers),
                Computer(name: "B",
                    memory: originalInputAsNumbers),
                Computer(name: "C",
                    memory: originalInputAsNumbers),
                Computer(name: "D",
                    memory: originalInputAsNumbers),
                Computer(name: "E",
                    memory: originalInputAsNumbers)
            ]

            print("Prepare Feedback Loop Phase Settings")
            for (index, amplifier) in amplifiers.enumerated() {
                amplifier.phaseSetting = feedbackPhaseSettings[index]
            }

            print("Run Feedback Loop")
            var currentOutput = 0
            while amplifiers.last!.hit99 == false {
                for amplifier in amplifiers {
                    currentOutput = amplifier.runProgramm(input: currentOutput)!
                }
            }
            possibleOutputs.insert(currentOutput)
        }

        let result = possibleOutputs.max()!
        assert(result == 25534964)//18812)

        return String(result)
    }
}

//https://www.objc.io/blog/2014/12/08/functional-snippet-10-permutations/
private extension Array {
    func decompose() -> (Iterator.Element, [Iterator.Element])? {
        guard let x = first else { return nil }
        return (x, Array(self[1..<count]))
    }
}

private func between<T>(_ x: T, _ ys: [T]) -> [[T]] {
    guard let (head, tail) = ys.decompose() else { return [[x]] }
    return [[x] + ys] + between(x, tail).map { [head] + $0 }
}

private func permutations<T>(_ xs: [T]) -> [[T]] {
    guard let (head, tail) = xs.decompose() else { return [[]] }
    return permutations(tail).flatMap { between(head, $0) }
}
