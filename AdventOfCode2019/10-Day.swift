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

    // Steigung
    private func slope(to point: Asteroid) -> Double {
        let deltaY = Double(point.y - y)//3-2 = 1, 0-2 = -2
        let deltaX = Double(point.x - x)//4-3 = 1, 1-3 = -2

        if deltaY < 0 && deltaX < 0 {
            return -(deltaY / deltaX)
        }

        // vertical
        if deltaY == 0 { return deltaX > 0 ? .greatestFiniteMagnitude : -.greatestFiniteMagnitude }

        // horizontal
        if deltaX == 0 { return deltaY > 0 ? .pi : -.pi }

        return deltaY / deltaX
    }

    func numberOfVisibleAsteroids(other asteroids: [Asteroid]) -> Int {
        var slopeWithVisibleAsteroids: [Double: Asteroid] = [:]
        for asteroid in asteroids {
            guard asteroid != self else { continue }
            let slopeToAsteroid = slope(to: asteroid)
            let asteroidWithSameSlope = slopeWithVisibleAsteroids[slopeToAsteroid]
            if asteroidWithSameSlope == nil {
                slopeWithVisibleAsteroids[slopeToAsteroid] = asteroid
            } else if let asteroidWithSameSlope = asteroidWithSameSlope,
                distance(to: asteroid) < distance(to: asteroidWithSameSlope) {
                slopeWithVisibleAsteroids[slopeToAsteroid] = asteroid
            } else {
                //blocked by another asteroid
                continue
            }
//            print("\(slopeToAsteroid) for \(asteroid.x)/\(asteroid.y)")
        }
        /**
         1/0 with: 7
         4/0 with: 7
         0/2 with: 6
         1/2 with: 7
         2/2 with: 7
         3/2 with: 7
         4/2 with: 5
         4/3 with: 6 -> 7
         3/4 with: 6 -> 8
         4/4 with: 7
         */
        print("\(x)/\(y) with: \(slopeWithVisibleAsteroids.keys.count)")
        return slopeWithVisibleAsteroids.keys.count
    }
}
