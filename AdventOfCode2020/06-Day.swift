import Foundation

/**
https://adventofcode.com/2020/day/6
*/

enum Day06 {
	static func solve() {
		let input = Input.get("06-Input.txt")
		print("Result Day 6 - Part One: \(numberOfQuestionsAnsweredWithYes(for: input))")
		print("Result Day 6 - Part Two: \(numberOfQuestionsAnsweredWithYesByEveryone(for: input))")
	}

	private static func numberOfQuestionsAnsweredWithYes(for input: String) -> String {
		let answers = input.components(separatedBy: "\n\n")
			.filter { !$0.isEmpty }
			.map { $0.replacingOccurrences(of: "\n", with: "") }
			.map(Set.init)

		let count = answers
			.map { $0.count }
			.reduce(0, +)

		// 6775
		return String(count)
	}

	private static func numberOfQuestionsAnsweredWithYesByEveryone(for input: String) -> String {
		let answerGroups = input
			.components(separatedBy: "\n\n")
			.filter { !$0.isEmpty }
			.map {
				$0
					.split(separator: "\n")
					.map(Set.init)
			}

		var count = 0
		for group in answerGroups {
			// check if answer is answered by everybody in the group
			let commonElements = group.reduce(group.first ?? []) {
				$0.intersection($1)
			}
			count += commonElements.count
		}

		// 3356
		return String(count)
	}
}
