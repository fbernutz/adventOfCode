import Foundation

/**
 https:adventofcode.com/2019/day/24
 */

private struct Layout: Hashable, Equatable {
    var bugsCoordinates: [Coordinate] = []

    let width = 4
    let height = 4

    var description: String {
        var output = ""

        for y in 0...height {
            output.append("\n")
            for x in 0...width {
                let coordinate = Coordinate(x: x, y: y)
                if bugsCoordinates.contains(coordinate) {
                    output.append("#")
                } else {
                    output.append(".")
                }
            }
        }
        return output
    }

    var biodiverseRating: Int {
        let flatten = bugsCoordinates
            .map { ($0.x + 1) + (width + 1) * $0.y }
        let biodiverseRatings = flatten
            .map { powersOfTwo(number: $0) }
        return biodiverseRatings.reduce(0, +)
    }

    private func powersOfTwo(number: Int) -> Int {
        var result = 1
        for _ in 1..<number {
            result *= 2
        }
        return result
    }

    mutating func nextGeneration() {
        var nextGeneration = bugsCoordinates
        for x in 0...width {
            for y in 0...height {
                let currentCoordinate = Coordinate(x: x, y: y)

                let numberOfNeighbors = numberOfLivingNeighbors(of: currentCoordinate)
                if nextGeneration.contains(currentCoordinate) {
                    if numberOfNeighbors != 1 {
                        // bug dies
                        nextGeneration = nextGeneration.filter { $0 != currentCoordinate }
                    }
                } else {
                    if numberOfNeighbors == 1 || numberOfNeighbors == 2 {
                        // infested
                        nextGeneration.append(currentCoordinate)
                    }
                }
            }
        }
        bugsCoordinates = nextGeneration
    }

    func numberOfLivingNeighbors(of coordinate: Coordinate) -> Int {
        let (x, y) = (coordinate.x, coordinate.y)
        let neighbors: [(x: Int, y: Int)] = [
                   (x, y-1),
            (x-1, y),   (x+1, y),
                   (x, y+1)
        ]

        var count = 0
        for neighbor in neighbors {
            let coordinate = Coordinate(x: neighbor.x, y: neighbor.y)
            if bugsCoordinates.contains(coordinate) {
                count += 1
            }
        }
        return count
    }

}

enum Day24 {
    static func solve() {
        let input = Input.get("24-Input.txt")
        print("Result Day 24 - Part One: \(biodiversityRatingForPart1(input: input))")
        //        print("Result Day 24 - Part Two: \(findExactPositionInTimeForPart2(input: input))")
    }

    private static func biodiversityRatingForPart1(input: String) -> String {
        let initialBugCoordinates = prepareInput(input: input)

        var bugsLayout = Layout(bugsCoordinates: initialBugCoordinates)
        var layouts: Set<Layout> = [bugsLayout]

        while true {
            bugsLayout.nextGeneration()

            if !layouts.contains(bugsLayout) {
                layouts.insert(bugsLayout)
            } else {
                break
            }
        }

        // not!
        //18621425
        //28772435
        return "\(bugsLayout.biodiverseRating)"
    }

}

extension Day24 {
    private static func prepareInput(input: String) -> [Coordinate] {
        let lines = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }

        var bugCoordinates: [Coordinate] = []
        for (y, line) in lines.enumerated() {
            for (x, character) in line.enumerated() where character == "#" {
                bugCoordinates.append(Coordinate(x: x, y: y))
            }
        }
        return bugCoordinates
    }
}
