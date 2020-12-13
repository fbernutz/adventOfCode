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

		let sorted = busIds
			.filter { $0 != "x"}
			.compactMap(Int.init)
			.sorted(by: >)
		let highestNumber = sorted[0]
		let secondHighestNumber = sorted[1]

		let indexForHighestNumber = busIds.firstIndex(of: "\(highestNumber)")! as Int
		let indexForSecondHighestNumber = busIds.firstIndex(of: "\(secondHighestNumber)")! as Int
		let enumeratedWithoutX = busIds.enumerated()
			.filter { (index, element) in element != "x" }

		// check other busses
		while !checkBusses(
			enumeratedWithoutX,
			currentTimestamp: currentTimestamp,
			indexForHighestNumber: indexForHighestNumber,
			highestNumber: highestNumber,
			indexForSecondHighestNumber: indexForSecondHighestNumber,
			secondHighestNumber: secondHighestNumber
		) {
			currentTimestamp += firstBusId
		}

		return String("\(currentTimestamp)")
	}

	private static func checkBusses(_ busWithIndex: [EnumeratedSequence<[String]>.Element], currentTimestamp: Int, indexForHighestNumber: Int, highestNumber: Int, indexForSecondHighestNumber: Int, secondHighestNumber: Int) -> Bool {

		// check highest number first, for early exit
		guard (currentTimestamp + indexForHighestNumber) % highestNumber == 0 else {
			return false
		}

		// check 2nd highest number first, for early exit
		guard (currentTimestamp + indexForSecondHighestNumber) % secondHighestNumber == 0 else {
			return false
		}

		let noInvalidBusses = busWithIndex
			.filter { (index, element) in (currentTimestamp + index) % Int(element)! != 0 }
			.isEmpty
		return noInvalidBusses
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
