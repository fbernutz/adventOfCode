import Foundation

/**
 https:adventofcode.com/2019/day/10
 */

enum Day10 {
    static func solve() {
        let input = Input.get("10-Input.txt")
        print("Result Day 10 - Part One: \(findBestAsteroidStation(input: input))")
//        print("Result Day 10 - Part Two: \(intcodeProgram(input: input, with: 2))")
    }

    private static func findBestAsteroidStation(input: String) -> String {
        let lines = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }
        var asteroids: [Asteroid] = []

        for (indexY, line) in lines.enumerated() {
            for (indexX, character) in line.enumerated() {
                if character == "#" {
                    asteroids.append(Asteroid(x: indexX, y: indexY))
                }
            }
        }

        var numberOfVisibleAsteroids: [Int] = []
        for asteroid in asteroids {
            numberOfVisibleAsteroids.append(asteroid.numberOfVisibleAsteroids(other: asteroids))
        }

        return String(numberOfVisibleAsteroids.max() ?? 0)
    }
}

struct Asteroid: Hashable {
    let x: Int
    let y: Int

    private func distance(to point: Asteroid) -> Double {
        let deltaY = Double(point.y - y)
        let deltaX = Double(point.x - x)
        return abs(deltaX + deltaY)
    }

    // Degree
    // from https://stackoverflow.com/a/28641720/6716961
    private func angle(to point: Asteroid) -> CGFloat {
        let v1 = CGVector(dx: x, dy: y)
        let v2 = CGVector(dx: point.x - x, dy: point.y - y)

        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        return angle * CGFloat(180.0 / .pi)
    }

    func numberOfVisibleAsteroids(other asteroids: [Asteroid]) -> Int {
        var angleWithVisibleAsteroids: [CGFloat: Asteroid] = [:]
        for asteroid in asteroids {
            guard asteroid != self else { continue }
            let angleToAsteroid = angle(to: asteroid)
            let asteroidWithSameAngle = angleWithVisibleAsteroids[angleToAsteroid]
            if asteroidWithSameAngle == nil {
                angleWithVisibleAsteroids[angleToAsteroid] = asteroid
            } else if let asteroidWithSameSlope = asteroidWithSameAngle,
                distance(to: asteroid) < distance(to: asteroidWithSameSlope) {
                angleWithVisibleAsteroids[angleToAsteroid] = asteroid
            } else {
                //blocked by another asteroid
                continue
            }
//            print("\(slopeToAsteroid) for \(asteroid.x)/\(asteroid.y)")
        }
//        print("\(x)/\(y) with: \(slopeWithVisibleAsteroids.keys.count)")
        return angleWithVisibleAsteroids.keys.count
    }
}
