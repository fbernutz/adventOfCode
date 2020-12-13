import Foundation

/**
https://adventofcode.com/2020/day/13
*/

enum Day13 {
	static func solve() {
		let input = Input.get("13-Input.txt")
		print("Result Day 13 - Part One: \(findNextBus(for: input))")
		print("Result Day 13 - Part Two: \(findEarliestTimestampForConstraint(for: input))")
	}

	private static func findNextBus(for input: String) -> String {
		let lines = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }

		let timestamp = Int(lines[0])!
		let busIds = lines[1]
			.split(separator: ",")
			.map(String.init)
			.filter { $0 != "x" }
			.compactMap(Int.init)

		var nearestBusId = busIds[0]
		var minimumMinutesToWait = busIds[0] - (timestamp % busIds[0])

		for busId in busIds {
			let minutesToWait = busId - (timestamp % busId)
			if minutesToWait < minimumMinutesToWait {
				nearestBusId = busId
				minimumMinutesToWait = minutesToWait
			}
		}

		// 153
		return String("\(nearestBusId * minimumMinutesToWait)")
	}

	private static func findEarliestTimestampForConstraint(for input: String) -> String {
		let lines = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }

		let busIds = lines[1]
			.split(separator: ",")
			.map(String.init)

		var minimumTimestamp = 0

		// TODO:

		return String("\(minimumTimestamp)")
	}
}
