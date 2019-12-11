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
        print("Result Day 11 - Part One & Two: \(intcodeProgram(input: input))")
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
        var firstPanel: Int? = 1

        while computer.hit99 == false {
            let input = firstPanel ?? paintedPanels[position] ?? 0
            firstOutput = computer.runProgramm(input: input)!
            //1. output -> paint position with output
            paintedPanels[position] = firstOutput

            secondOutput = computer.runProgramm(input: input)!
            //2. output -> direction 0 turn left, 1 turn right
            currentDirection = Direction(rawValue: secondOutput)!.rotate(with: currentDirection)
            position = position.moveForward(in: currentDirection)
            firstPanel = nil
        }
        draw(coordinatesWithColor: paintedPanels)

        return String(paintedPanels.keys.count)
    }

    private static func draw(coordinatesWithColor: [Coordinate: Int]) {
        var maxY = 0
        var maxX = 0
        var minY = 0
        var minX = 0

        for coordinate in coordinatesWithColor.keys {
            if coordinate.y > maxY && coordinate.y > 0 {
                maxY = coordinate.y
            }
            if coordinate.y < minY && coordinate.y < 0 {
                minY = coordinate.y
            }
            if coordinate.x > maxX && coordinate.y > 0  {
                maxX = coordinate.x
            }
            if coordinate.x < minX && coordinate.x < 0 {
                minX = coordinate.x
            }
        }

        var image: [[String]]?
        var height = abs(minY) + maxY + 1
        let width = abs(minX) + maxX + 1
        while height != 0 {
            if let _ = image {
                image!.append(Array(repeating: "◽️", count: width))
            } else {
                image = [Array(repeating: "◽️", count: width)]
            }
            height -= 1
        }

        for coordinateWithColor in coordinatesWithColor {
            let coordinate = coordinateWithColor.key
            var x = coordinate.x
            var y = coordinate.y
            if coordinate.x < 0 {
                x = abs(minX) + abs(coordinate.x)
            } else {
                x += abs(minX)
            }
            if coordinate.y < 0 {
                y = abs(minY) + abs(coordinate.y)
            } else {
                y += abs(minY)
            }
            image![y][x] = coordinateWithColor.value == 0 ? "◾️" : "◽️"
        }

        var formatted = ""
        for line in image! {
            formatted.append(contentsOf: line.joined())
            formatted += "\n"
        }
        print(formatted)
    }
}
