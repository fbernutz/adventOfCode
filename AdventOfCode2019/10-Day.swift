import Foundation

/**
 https:adventofcode.com/2019/day/10
 */

private struct Asteroid: Hashable {
    let x: Int
    let y: Int

    private func distance(to point: Asteroid) -> Double {
        let deltaY = Double(point.y - y)
        let deltaX = Double(point.x - x)
        return abs(deltaX + deltaY)
    }

    // Angle in degrees, from https://stackoverflow.com/a/28641720/6716961
    private func angle(to point: Asteroid) -> CGFloat {
        let v1 = CGVector(dx: x, dy: y)
        let v2 = CGVector(dx: point.x - x, dy: point.y - y)

        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        let degree = angle * CGFloat(180.0 / .pi)
        return degree
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
//            print("\(angleToAsteroid) for \(asteroid.x)/\(asteroid.y)")
        }
//        print("\(x)/\(y) with: \(angleWithVisibleAsteroids.keys.count)")
        return angleWithVisibleAsteroids.keys.count
    }

    func angleOfAllAsteroids(other asteroids: [Asteroid]) -> [CGFloat: Asteroid] {
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
//                angleWithVisibleAsteroids[angleToAsteroid - 360] = asteroidWithSameAngle
            } else {
                angleWithVisibleAsteroids[angleToAsteroid + 360] = asteroid
                continue
            }
//            print("\(angleToAsteroid) for \(asteroid.x)/\(asteroid.y)")
        }
        //        print("\(x)/\(y) with: \(angleWithVisibleAsteroids.keys.count)")
        return angleWithVisibleAsteroids
    }
}


enum Day10 {
    static func solve() {
        let input = Input.get("10-Input.txt")
        print("Result Day 10 - Part One: \(findBestAsteroidStation(input: input))")
        print("Result Day 10 - Part Two: \(vaporizeAsteroids(input: input))")
    }

    private static func findBestAsteroidStation(input: String) -> String {
        let asteroids = prepareInput(input: input)
        let count = findBestAsteroid(in: asteroids).count
        return String(count)
    }

    private static func vaporizeAsteroids(input: String) -> String {
        let asteroids = prepareInput(input: input)
        let asteroid = findBestAsteroid(in: asteroids).asteroid

        let asteroidsWithAngle = asteroid.angleOfAllAsteroids(other: asteroids)
        let angles = asteroidsWithAngle
            .map { $0.key }
            .sorted(by: >)
        let angle200 = angles[200]

        // laser starts by pointing up -> then clockwise

        let asteroid200 = asteroidsWithAngle[angle200]!
        assert(asteroid200.x == 8 && asteroid200.y == 2)
        return String(asteroid200.x * 100 + asteroid200.y)
    }

    private static func findBestAsteroid(in asteroids: [Asteroid]) -> (asteroid: Asteroid, count: Int) {
        var numberOfVisibleAsteroids: [Int: Asteroid] = [:]
        for asteroid in asteroids {
            let newNumber = asteroid.numberOfVisibleAsteroids(other: asteroids)
            numberOfVisibleAsteroids[newNumber] = asteroid
        }
        let bestAsteroidCount = numberOfVisibleAsteroids.keys.sorted(by: >).first!
        let bestAsteroid = numberOfVisibleAsteroids[bestAsteroidCount]!
        return (bestAsteroid, bestAsteroidCount)
    }
}

extension Day10 {
    private static func prepareInput(input: String) -> [Asteroid] {
        let lines = input.components(separatedBy: .newlines)
            .filter { !$0.isEmpty }

        var asteroids: [Asteroid] = []
        for (indexY, line) in lines.enumerated() {
            for (indexX, character) in line.enumerated() where character == "#" {
                asteroids.append(Asteroid(x: indexX, y: indexY))
            }
        }
        return asteroids
    }
}
