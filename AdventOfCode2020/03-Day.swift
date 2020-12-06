import Foundation

/**
https://adventofcode.com/2020/day/3
*/

enum Day03 {
	static func solve() {
		let input = Input.get("03-Input.txt")
		print("Result Day 3 - Part One: \(getNumberOfTrees(input: input))")
		print("Result Day 3 - Part Two: \(getNumberOfTreesForDifferentSlopes(input: input))")
	}

	private static func getNumberOfTrees(input: String) -> String {
		let treeCounter = countTrees(for: input, numberOfStepsRight: 3, numberOfStepsDown: 1)

		// 173
		return String(treeCounter)
	}

	private static func getNumberOfTreesForDifferentSlopes(input: String) -> String {
		let treeCounter1 = countTrees(for: input, numberOfStepsRight: 1, numberOfStepsDown: 1)
		let treeCounter2 = countTrees(for: input, numberOfStepsRight: 3, numberOfStepsDown: 1)
		let treeCounter3 = countTrees(for: input, numberOfStepsRight: 5, numberOfStepsDown: 1)
		let treeCounter4 = countTrees(for: input, numberOfStepsRight: 7, numberOfStepsDown: 1)
		let treeCounter5 = countTrees(for: input, numberOfStepsRight: 1, numberOfStepsDown: 2)

		// 4385176320
		return String(treeCounter1 * treeCounter2 * treeCounter3 * treeCounter4 * treeCounter5)
	}

	private static func countTrees(for input: String, numberOfStepsRight: Int, numberOfStepsDown: Int) -> Int {
		let lines = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }

		var treeCounter = 0

		var currentX = 0
		for (index, line) in lines.enumerated() where (index % numberOfStepsDown) == 0 {
			if line[currentX] == "#" {
				treeCounter += 1
			}
			currentX = (currentX + numberOfStepsRight) % line.count
		}

		return treeCounter
	}

}
