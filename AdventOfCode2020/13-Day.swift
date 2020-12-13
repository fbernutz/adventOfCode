import Foundation

/**
https://adventofcode.com/2020/day/13
*/

enum Day13 {
	static func solve() {
		let input = Input.get("13-Input.txt")
		let start = Date()
		print(start)
		print("Result Day 13 - Part One: \(findNextBus(for: input))")
		print("Result Day 13 - Part Two: \(findEarliestTimestampForConstraint(for: input))")
		print("duration: \(DateInterval(start: start, end: Date()).duration) sec")
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
		let busIds = getBusIds(for: input)

		// set timestamp to first bus id after 0
		let firstBusId = Int(busIds[0])!
		var currentTimestamp = firstBusId

		// check other busses
		while !otherBussesAreValid(busIds, currentTimestamp: currentTimestamp) {
			currentTimestamp += firstBusId
		}

		return String("\(currentTimestamp)")
	}

	private static func otherBussesAreValid(_ busIds: [String], currentTimestamp: Int) -> Bool {
		var currentTime = currentTimestamp

		for busId in busIds {
			if busId == "x" {
				// always valid
				currentTime += 1
				continue
			} else if currentTime % Int(busId)! != 0 {
				// invalid, test failed
				return false
			} else {
				// valid bus, check next
				currentTime += 1
			}
		}

		return true
	}

	private static func getBusIds(for input: String) -> [String] {
		let lines = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }

		let busIds = lines[1]
			.split(separator: ",")
			.map(String.init)

		// 17,x,13,19
		return busIds
	}
}
