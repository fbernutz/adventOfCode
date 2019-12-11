import Foundation

/**
 https:adventofcode.com/2019/day/11
 */

enum Day11 {
    static func solve() {
        let input = Input.get("11-Input.txt")
        print("Result Day 11 - Part One: \(intcodeProgramForPart1(input: input))")
        print("Result Day 11 - Part Two: \(intcodeProgramForPart2(input: input))")
    }

    private static func intcodeProgramForPart1(input: String) -> String {
        let result = paintPanels(with: input, startColor: 0).keys.count
        assert(result == 1883)
        return String(result)
    }

    private static func intcodeProgramForPart2(input: String) -> String {
        let panels = paintPanels(with: input, startColor: 1)
        let painting = draw(coordinatesWithColor: panels)
        let expectedResult = """
        ◾️◾️⬜️⬜️◾️◾️⬜️⬜️⬜️◾️◾️⬜️◾️◾️⬜️◾️◾️⬜️⬜️◾️◾️⬜️◾️◾️⬜️◾️⬜️⬜️⬜️◾️◾️⬜️⬜️⬜️⬜️◾️⬜️◾️◾️⬜️◾️◾️◾️
        ◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️◾️◾️⬜️◾️◾️⬜️◾️◾️◾️
        ◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️◾️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️⬜️⬜️◾️◾️⬜️⬜️⬜️⬜️◾️◾️◾️
        ◾️⬜️⬜️⬜️⬜️◾️⬜️⬜️⬜️◾️◾️⬜️◾️◾️⬜️◾️⬜️◾️⬜️⬜️◾️⬜️◾️◾️⬜️◾️⬜️⬜️⬜️◾️◾️⬜️◾️◾️◾️◾️⬜️◾️◾️⬜️◾️◾️◾️
        ◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️◾️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️⬜️◾️⬜️◾️⬜️◾️◾️⬜️◾️◾️◾️◾️⬜️◾️◾️⬜️◾️◾️◾️
        ◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️◾️◾️◾️⬜️⬜️◾️◾️◾️⬜️⬜️⬜️◾️◾️⬜️⬜️◾️◾️⬜️◾️◾️⬜️◾️⬜️◾️◾️◾️◾️⬜️◾️◾️⬜️◾️◾️◾️

        """
        assert(painting == expectedResult)
        return "\n" + painting
    }

    private static func paintPanels(with input: String, startColor: Int) -> [Coordinate: Int] {
        var paintedPanels: [Coordinate: Int] = [:]
        var firstOutput = 0
        var secondOutput = 0
        var currentDirection: Direction = .up
        var position = Coordinate(x: 0, y: 0)
        var firstPanel: Int? = startColor

        let computer = Computer(rawMemory: input)
        while computer.hit99 == false {
            let input = firstPanel ?? paintedPanels[position] ?? 0
            firstOutput = computer.runProgramm(input: input)!
            secondOutput = computer.runProgramm(input: input)!

            // Paint
            paintedPanels[position] = firstOutput

            // Turn
            currentDirection = Direction(rawValue: secondOutput)!.rotate(with: currentDirection)

            // Move
            position = position.moveForward(in: currentDirection)
            firstPanel = nil
        }

        return paintedPanels
    }

    private static func draw(coordinatesWithColor: [Coordinate: Int]) -> String {
        let maxY = coordinatesWithColor.keys.map { $0.y }.max() ?? 0
        let minY = coordinatesWithColor.keys.map { $0.y }.min() ?? 0
        let maxX = coordinatesWithColor.keys.map { $0.x }.max() ?? 0
        let minX = coordinatesWithColor.keys.map { $0.x }.min() ?? 0

        let height = abs(minY) + maxY + 1
        let width = abs(minX) + maxX + 1

        var image = Array(repeating: Array(repeating: "◾️", count: width), count: height)

        for y in minY...maxY {
            for x in minX...maxX {
                let coordinate = Coordinate(x: x, y: y)
                let color = coordinatesWithColor[coordinate] ?? 0
                image[maxY - y][x - minX] = color == 1 ? "⬜️" : "◾️"
            }
        }

        var formatted = ""
        for line in image {
            formatted.append(contentsOf: line.joined())
            formatted += "\n"
        }
        return formatted
    }
}
