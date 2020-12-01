import Foundation

/**
https://adventofcode.com/2020/day/1
*/

enum Day01 {
	static func solve() {
		let input = Input.get("01-Input.txt")
		print("Result Day 1 - Part One: \(getResultWithTwoNumbers(input: input))")
		print("Result Day 1 - Part Two: \(getResultWithThreeNumbers(input: input))")
	}

	private static func getResultWithTwoNumbers(input: String) -> String {
		let numbers = input.components(separatedBy: .newlines)
			.compactMap { Int($0) }

		// find two numbers which sum 2020,
		// then multiply those numbers
		for number1 in numbers {
			for number2 in numbers {
				if number1 + number2 == 2020 {
					//876459
					return String(number1 * number2)
				}
			}
		}
		return String("hi")
	}

	private static func getResultWithThreeNumbers(input: String) -> String {
		let numbers = input.components(separatedBy: .newlines)
			.compactMap { Int($0) }

		// find three numbers which sum 2020,
		// then multiply those numbers
		for number1 in numbers {
			for number2 in numbers {
				for number3 in numbers {
					if number1 + number2 + number3 == 2020 {
						//116168640
						return String(number1 * number2 * number3)
					}
				}
			}
		}
		return String("hi")
	}

}
