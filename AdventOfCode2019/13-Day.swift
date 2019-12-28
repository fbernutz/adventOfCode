import Foundation

/**
 https:adventofcode.com/2019/day/13
 */

enum Day13 {
    static func solve() {
        let input = Input.get("13-Input.txt")
//        print("Result Day 13 - Part One: \(numberOfBlockTilesForPart1(input: input))")
        print("Result Day 13 - Part Two: \(scoreForPart2(input: input))")
    }

    private static func numberOfBlockTilesForPart1(input: String) -> String {

        /*
         every three output instructions specify:
         - x position (distance from the left)
         - y position (distance from the top)
         - tile id

         The tile id is interpreted as follows:
         0 is an empty tile. No game object appears in this tile.
         1 is a wall tile. Walls are indestructible barriers.
         2 is a block tile. Blocks can be broken by the ball.
         3 is a horizontal paddle tile. The paddle is indestructible.
         4 is a ball tile. The ball moves diagonally and bounces off objects.
         */

        let computer = Computer(rawMemory: input)
        var outputs: [Int] = []

        while computer.hit99 == false {
            if let output = computer.runProgramm(input: 0) {
                outputs.append(output)
            }
        }

        let tileIds = outputs
            .enumerated()
            .compactMap { $0 % 3 == 2 ? $1 : nil }

        let numberOfTiles = tileIds.filter { $0 == 2 }.count
        assert(numberOfTiles == 230)
        return "\(numberOfTiles)"
    }


    private static func scoreForPart2(input: String) -> String {
        /*
         If the joystick is in the neutral position, provide 0.
         If the joystick is tilted to the left, provide -1.
         If the joystick is tilted to the right, provide 1.

         When three output instructions specify X=-1, Y=0, the third output instruction is not a tile; the value instead specifies the new score to show in the segment display.

         Free Playing: memory[0] = 2
         */

        return ""
    }

}
