import Foundation

/**
 https:adventofcode.com/2019/day/12
 */

enum Day12 {
    static func solve() {
        let input = Input.get("12-Input.txt")
//        print("Result Day 12 - Part One: \(totalEnergyAfter1000StepsForPart1(input: input))")
        print("Result Day 12 - Part Two: \(findExactPositionInTimeForPart2(input: input))")
    }

    private static func totalEnergyAfter1000StepsForPart1(input: String) -> String {
        let moons = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map(Moon.init)

        var moonsWithNewPosition = moons

        let timeSteps = 1000
        for _ in 0..<timeSteps {
            moonsWithNewPosition = moonsWithNewPosition
                .map { $0.applyGravity(on: moonsWithNewPosition) }
                .map { $0.applyVelocity() }
        }

        let result = moonsWithNewPosition.map { $0.totalEnergy }.reduce(0, +)
        assert(result == 12466)
        return String(result)
    }

    private static func findExactPositionInTimeForPart2(input: String) -> String {
        let moons = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
            .map(Moon.init)

        var moonsWithNewPosition = moons
        var counter = 0

        repeat {
            print(counter)
            moonsWithNewPosition = moonsWithNewPosition
                .map { $0.applyGravity(on: moonsWithNewPosition) }
                .map { $0.applyVelocity() }
            counter += 1
        } while moonsWithNewPosition != moons

        return String(counter)
    }
}

private struct Moon: Equatable {
    var x: Int
    var y: Int
    var z: Int
    var velocity = Velocity.zero

    var potentialEnergy: Int {
        abs(x) + abs(y) + abs(z)
    }

    var kineticEnergy: Int {
        abs(velocity.x) + abs(velocity.y) + abs(velocity.z)
    }

    var totalEnergy: Int {
        potentialEnergy * kineticEnergy
    }

    init(with input: String) {
        //<x=-4, y=-14, z=8>
        let regex = #"-?[0-9]\d{0,2}"#
        let digits = input.matches(for: regex).compactMap { Int($0) }
        x = digits[0]
        y = digits[1]
        z = digits[2]
    }

    func applyVelocity() -> Moon {
        var newMoon = self

        newMoon.x += velocity.x
        newMoon.y += velocity.y
        newMoon.z += velocity.z

        return newMoon
    }

    func applyGravity(on moons: [Moon]) -> Moon {
        var newMoon = self
        var newVelocityX = newMoon.velocity.x
        var newVelocityY = newMoon.velocity.y
        var newVelocityZ = newMoon.velocity.z

        for moon in moons where moon != self {
            // X
            if newMoon.x > moon.x {
                newVelocityX -= 1
            } else if newMoon.x < moon.x {
                newVelocityX += 1
            } else if newMoon.x == moon.x {
                // nothing
            }

            // Y
            if newMoon.y > moon.y {
                newVelocityY -= 1
            } else if newMoon.y < moon.y {
                newVelocityY += 1
            } else if newMoon.y == moon.y {
                // nothing
            }

            // Z
            if newMoon.z > moon.z {
                newVelocityZ -= 1
            } else if newMoon.z < moon.z {
                newVelocityZ += 1
            } else if newMoon.z == moon.z {
                // nothing
            }
        }

        newMoon.velocity.x = newVelocityX
        newMoon.velocity.y = newVelocityY
        newMoon.velocity.z = newVelocityZ

        return newMoon
    }
}

private struct Velocity: Equatable {
    static let zero = Velocity(x: 0, y: 0, z: 0)

    var x: Int
    var y: Int
    var z: Int
}

extension String {
    func matches(for regex: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: regex)
            let results = regex.matches(in: self, range: NSRange(self.startIndex..., in: self))
            return results.map {
                String(self[Range($0.range, in: self)!])
            }
        } catch let error {
            print("invalid regex: \(error.localizedDescription)")
            return []
        }
    }
}
