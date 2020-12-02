import Foundation

/**
https://adventofcode.com/2020/day/2
*/

enum Day02 {
	static func solve() {
		let input = Input.get("02-Input.txt")
		print("Result Day 2 - Part One: \(getNumberOfValidPasswords(input: input))")
		print("Result Day 2 - Part Two: \(getNumberOfValidPasswordsForNewPolicy(input: input))")
	}

	struct PasswordPolicy {
		let minimumCount: Int
		let maximumCount: Int
		let character: String

		/// e.g. string equals `1-3 a`
		init(from input: String) {
			let parts = input.split(separator: "-")
			minimumCount = Int(parts[0])!
			let otherParts = parts[1].split(separator: " ")
			maximumCount = Int(otherParts[0])!
			character = String(otherParts[1])
		}

		func isValidPassword(_ password: String) -> Bool {
			let characterCount = password.filter { String($0) == character }.count
			let range = minimumCount...maximumCount
			return range.contains(characterCount)
		}
	}

	struct PasswordPolicyNew {
		let firstPosition: Int
		let secondPosition: Int
		let character: String

		/// e.g. string equals `1-3 a`
		init(from input: String) {
			let parts = input.split(separator: "-")
			firstPosition = Int(parts[0].trimmingCharacters(in: .whitespaces))!
			let otherParts = parts[1].split(separator: " ")
			secondPosition = Int(otherParts[0].trimmingCharacters(in: .whitespaces))!
			character = String(otherParts[1].trimmingCharacters(in: .whitespaces))
		}

		func isValidPassword(_ password: String) -> Bool {
			let firstPositionCharacter = password[firstPosition - 1]
			let secondPositionCharacter = password[secondPosition - 1]
			return (firstPositionCharacter == character
				|| secondPositionCharacter == character)
				&& firstPositionCharacter != secondPositionCharacter
		}
	}

	private static func getNumberOfValidPasswords(input: String) -> String {
		// 1-3 a: abcde
		var validPasswordCount = 0
		let lines = input.components(separatedBy: .newlines)
			.dropLast()
		for line in lines {
			let splittedLine = line
				.split(separator: ":")
				.map(String.init)
			let passwordPolicy = PasswordPolicy(from: splittedLine[0])
			let password = splittedLine[1]
			if passwordPolicy.isValidPassword(password) {
				validPasswordCount += 1
			}
		}
		// 569
		return String(validPasswordCount)
	}

	private static func getNumberOfValidPasswordsForNewPolicy(input: String) -> String {
		// 1-3 a: abcde
		var validPasswordCount = 0
		let lines = input.components(separatedBy: .newlines)
			.dropLast()
		for line in lines {
			let splittedLine = line
				.split(separator: ":")
				.map(String.init)
			let passwordPolicy = PasswordPolicyNew(from: splittedLine[0])
			let password = splittedLine[1].trimmingCharacters(in: .whitespaces)
			if passwordPolicy.isValidPassword(password) {
				validPasswordCount += 1
			}
		}
		// 346
		return String(validPasswordCount)
	}

}
