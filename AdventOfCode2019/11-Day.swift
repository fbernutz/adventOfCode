import Foundation

/**
 https:adventofcode.com/2019/day/11
 */

private struct Coordinate: Hashable {
    let x: Int
    let y: Int

    func moveForward(in direction: Direction) -> Coordinate {
        let newCoordinate: Coordinate
        switch direction {
        case .left:
            newCoordinate = Coordinate(x: x-1, y: y)
        case .right:
            newCoordinate = Coordinate(x: x+1, y: y)
        case .up:
            newCoordinate = Coordinate(x: x, y: y+1)
        case .down:
            newCoordinate = Coordinate(x: x, y: y-1)
        }
        return newCoordinate
    }
}

private enum Direction: Int {
    case left = 0
    case right = 1
    case up
    case down

    func rotate(with currentDirection: Direction) -> Direction {
        let newDirection: Direction
        switch currentDirection {
        case .up:
            newDirection = self == .left ? .left : .right
        case .right:
            newDirection = self == .left ? .up : .down
        case .down:
            newDirection = self == .left ? .right : .left
        case .left:
            newDirection = self == .left ? .down : .up
        }
        return newDirection
    }
}

enum Day11 {
    static func solve() {
        let input = Input.get("11-Input.txt")
        print("Result Day 11 - Part One: \(intcodeProgram(input: input))")
//        print("Result Day 11 - Part Two: \(vaporizeAsteroids(input: input))")
    }

    private static func intcodeProgram(input: String) -> String {
        let originalInputAsNumbers = input.components(separatedBy: ",")
            .compactMap { Int($0) }

        let computer = Computer(memory: originalInputAsNumbers)

        var paintedPanels: [Coordinate: Int] = [:]
        var firstOutput = 0
        var secondOutput = 0
        var currentDirection: Direction = .up
        var position = Coordinate(x: 0, y: 0)

        while computer.hit99 == false {
            let input = paintedPanels[position] ?? 0
            firstOutput = computer.runProgramm(input: input)!
            //1. output -> paint position with output
            paintedPanels[position] = firstOutput

            secondOutput = computer.runProgramm(input: input)!
            //2. output -> direction 0 turn left, 1 turn right
            currentDirection = Direction(rawValue: secondOutput)!.rotate(with: currentDirection)
            position = position.moveForward(in: currentDirection)
        }

        return String(paintedPanels.keys.count)
    }
}
