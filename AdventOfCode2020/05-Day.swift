import Foundation

/**
https://adventofcode.com/2020/day/5
*/

enum Day05 {
	static func solve() {
		let input = Input.get("05-Input.txt")
		print("Result Day 5 - Part One: \(findHighestSeatId(for: input))")
		print("Result Day 5 - Part Two: \(findSeat(for: input))")
	}

	private static func findHighestSeatId(for input: String) -> String {
		let boardingPasses = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }

		var seatIds: [Int] = []
		for boardingPass in boardingPasses {
			seatIds.append(getSeatId(for: boardingPass))
		}

		// 816
		return String(seatIds.max()!)
	}

	private static func findSeat(for input: String) -> String {
		let boardingPasses = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }

		var seatIds: [Int] = []
		for boardingPass in boardingPasses {
			seatIds.append(getSeatId(for: boardingPass))
		}

		let mySeatId = seatIds
			.first {
				!seatIds.contains($0 + 1) && seatIds.contains($0 + 2)
			}! + 1

		// 539
		return String(mySeatId)
	}

	private static func getSeatId(for boardingPass: String) -> Int {
		var row = 0
		var column = 0

		// first seven:
		// F means lower half
		// B means upper half
		// -> row

		// last three:
		// R means upper half
		// L means lower half
		// -> column

		var rowRange = 0...127
		for character in boardingPass.prefix(7) {
			if character == "F" {
				rowRange = rowRange.lowerBound...rowRange.upperBound - (rowRange.count / 2)
			} else if character == "B" {
				rowRange = rowRange.lowerBound + (rowRange.count / 2)...rowRange.upperBound
			}
		}
		row = rowRange.lowerBound

		var columnRange = 0...7
		for character in boardingPass.suffix(3) {
			if character == "L" {
				columnRange = columnRange.lowerBound...columnRange.upperBound - (columnRange.count / 2)
			} else if character == "R" {
				columnRange = columnRange.lowerBound + (columnRange.count / 2)...columnRange.upperBound
			}
		}
		column = columnRange.lowerBound

		return row * 8 + column
	}

}
