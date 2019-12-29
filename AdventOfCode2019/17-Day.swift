import Foundation

/**
 https:adventofcode.com/2019/day/17
 */

enum Day17 {
    static func solve() {
        let input = Input.get("17-Input.txt")
        print("Result Day 17 - Part One: \(sumAlignmentParametersForPart1(input: input))")
//        print("Result Day 17 - Part Two: \(fftAfter100PhasesWithMessageOffsetForPart2(input: input))")
    }

    private static func sumAlignmentParametersForPart1(input: String) -> String {
        let computer = Computer(rawMemory: input)

        var screen = Screen()
        var y = 0

        while !computer.hit99 {
            let output = computer.runProgramm(input: 0)
            if output == 35 {
                screen.elements[y].append("#")
            }
            if output == 46 {
                screen.elements[y].append(".")
            }
            if output == 10 {
                y += 1
                screen.elements.append("")
            }
        }

        // Sort out empty newLines
        screen.elements = screen.elements.filter { !$0.isEmpty }

        let result = screen.sumOfAlignmentParameters
        assert(result == 4864)
        return "\(result)"
    }

}

private struct Screen {
    var elements: [String] = [""]

    var description: String {
        var output = ""

        for line in elements {
            output += "\n"
            for character in line {
                output += "\(character)"
            }
        }

        return output
    }

    var sumOfAlignmentParameters: Int {
        var alignmentParameters: [Int] = []

        for (y, line) in elements.enumerated() {
            for (x, character) in line.enumerated()
                where character == "#" && isScaffoldIntersection(on: (x, y)) {
                    alignmentParameters.append(x * y)
            }
        }
        return alignmentParameters.reduce(0, +)
    }

    func isScaffoldIntersection(on position: (x: Int, y: Int)) -> Bool {
        let (x, y) = position
        let neighbors: [(x: Int, y: Int)] = [
                   (x, y-1),
            (x-1, y),   (x+1, y),
                   (x, y+1)
        ]

        var count = 0
        for neighbor in neighbors {
            guard neighbor.y > 0,
                neighbor.x > 0,
                neighbor.y < elements.count,
                neighbor.x < elements[y].count else { break }

            if elements[neighbor.y][neighbor.x] == "#" {
                count += 1
            }
        }
        return count == 4
    }
}

extension String {
    subscript (index: Int) -> String {
        let start = String.Index(utf16Offset: index, in: self)
        let end = String.Index(utf16Offset: index, in: self)
        return String(self[start...end])
    }
}

