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
		let firstInformation: Int
		let secondInformation: Int
		let character: String
		let password: String

		/// e.g. string equals `1-3 a: abcde`
		init(from input: String) {
			password = input
				.split(separator: ":")
				.map(String.init)
				.last!
				.trimmingCharacters(in: .whitespaces)
			let parts = input
				.split(separator: ":")
				.first!
				.split(separator: "-")
				.map(String.init)
			firstInformation = Int(parts[0])!
			let otherParts = parts[1].split(separator: " ")
			secondInformation = Int(otherParts[0])!
			character = String(otherParts[1])
		}

		func isValidPassword() -> Bool {
			let characterCount = password.filter { String($0) == character }.count
			let range = firstInformation...secondInformation
			return range.contains(characterCount)
		}

		func isValidPasswordForNewPolicy() -> Bool {
			let firstPositionCharacter = password[firstInformation - 1]
			let secondPositionCharacter = password[secondInformation - 1]
			return (firstPositionCharacter == character
				|| secondPositionCharacter == character)
				&& firstPositionCharacter != secondPositionCharacter
		}
	}

	private static func getNumberOfValidPasswords(input: String) -> String {
		// 1-3 a: abcde
		let passwordPolicies = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }
			.map(PasswordPolicy.init)

		let validPasswordCount = passwordPolicies
			.map { $0.isValidPassword() }
			.filter { $0 == true }
			.count

		// 569
		return String(validPasswordCount)
	}

	private static func getNumberOfValidPasswordsForNewPolicy(input: String) -> String {
		// 1-3 a: abcde
		let passwordPolicies = input.components(separatedBy: .newlines)
			.filter { !$0.isEmpty }
			.map(PasswordPolicy.init)

		let validPasswordCount = passwordPolicies
			.map { $0.isValidPasswordForNewPolicy() }
			.filter { $0 == true }
			.count

		// 346
		return String(validPasswordCount)
	}

}
