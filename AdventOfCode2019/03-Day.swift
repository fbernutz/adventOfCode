import Foundation

/**
https://adventofcode.com/2019/day/3
*/

enum Day03 {
    static func solve() {
        let input = Input.get("03-Input.txt")
        print("Result Day 3 - Part One: \(findClosestIntersection(input: input))")
        print("Result Day 3 - Part Two: \(countStepsToNearestIntersections(input: input))")
    }

    private static func findClosestIntersection(input: String) -> String {
        let wires = input.components(separatedBy: .newlines)
        let instructionsOne = wires[0].components(separatedBy: ",")
        let instructionsTwo = wires[1].components(separatedBy: ",")

        let coordinatesOne = Set(calculateCoordinates(for: instructionsOne))
        let coordinatesTwo = Set(calculateCoordinates(for: instructionsTwo))

        // find intersections, exclusive central port (0, 0)
        let intersections = coordinatesOne.intersection(coordinatesTwo)
            .filter { Coordinate(x: 0, y: 0) != $0 }

        // calculate manhattan distances from central port to intersections
        let distances = intersections.map { $0.distance }

        guard let closestDistance = distances.min()
            else { fatalError("could not find any distance") }

        return String(closestDistance)
    }

    private static func countStepsToNearestIntersections(input: String) -> String {
        let wires = input.components(separatedBy: .newlines)
        let instructionsOne = wires[0].components(separatedBy: ",")
        let instructionsTwo = wires[1].components(separatedBy: ",")

        let coordinatesOne = calculateCoordinates(for: instructionsOne)
        let coordinatesTwo = calculateCoordinates(for: instructionsTwo)

        // find intersections, exclusive central port (0, 0)
        let intersections = Set(coordinatesOne).intersection(Set(coordinatesTwo))
            .filter { Coordinate(x: 0, y: 0) != $0 }

        var stepsInTotal: Int?
        for intersection in intersections {
            let stepsOnFirstWire = coordinatesOne.firstIndex(of: intersection)!
            let stepsOnSecondWire = coordinatesTwo.firstIndex(of: intersection)!
            let sum = stepsOnFirstWire + stepsOnSecondWire
            if let steps = stepsInTotal {
                if steps < sum {
                    continue
                } else {
                    stepsInTotal = sum
                }
            } else {
                stepsInTotal = sum
            }
        }

        return String(stepsInTotal!)
    }

    private static func calculateCoordinates(for instructions: [String]) -> [Coordinate] {
        var coordinates = [Coordinate(x: 0, y: 0)]

        for instructionStep in instructions {
            let currentPosition = coordinates.last!
            let (x, y) = (currentPosition.x, currentPosition.y)

            let direction = instructionStep.first
            let steps = Int(instructionStep.dropFirst())!

            //   U
            // L + R
            //   D

            for step in 1..<steps+1 {
                let newCoordinate: Coordinate
                switch direction {
                case "U":
                    newCoordinate = Coordinate(x: x, y: y+step)
                case "D":
                    newCoordinate = Coordinate(x: x, y: y-step)
                case "L":
                    newCoordinate = Coordinate(x: x-step, y: y)
                case "R":
                    newCoordinate = Coordinate(x: x+step, y: y)
                default:
                    fatalError("Non valid input")
                }

                coordinates.append(newCoordinate)
            }
        }

        return coordinates
    }

}
