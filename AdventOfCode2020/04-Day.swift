import Foundation

/**
https://adventofcode.com/2020/day/4
*/

enum Day04 {
	static func solve() {
		let input = Input.get("04-Input.txt")
		print("Result Day 4 - Part One: \(findValidPassportsPart1(for: input))")
		print("Result Day 4 - Part Two: \(findValidPassportsPart2(for: input))")
	}

	private static func findValidPassportsPart1(for input: String) -> String {
		let passports = input.components(separatedBy: "\n\n")
			.filter { !$0.isEmpty }
			.map { $0.replacingOccurrences(of: "\n", with: " ") }

		let numberOfValidPassports = passports
			.map { isValidPart1(input: $0) }
			.filter { $0 == true }
			.count

		// 192
		return String("\(numberOfValidPassports)")
	}

	private static func findValidPassportsPart2(for input: String) -> String {
		let passports = input.components(separatedBy: "\n\n")
			.filter { !$0.isEmpty }
			.map { $0.replacingOccurrences(of: "\n", with: " ") }

		let numberOfValidPassports = passports
			.map { isValidPart2(input: $0) }
			.filter { $0 == true }
			.count

		// 101
		return String("\(numberOfValidPassports)")
	}

	private static func isValidPart1(input: String) -> Bool {
		let validKeySet: Set<String> = [
			"byr",
			"iyr",
			"eyr",
			"hgt",
			"hcl",
			"ecl",
			"pid",
//			"cid"
		]

		let passportFields = input.split(separator: " ")
			.compactMap { $0.split(separator: ":") }
			.map { (key: String($0[0]), value: String($0[1])) }

		let keys = passportFields.map { $0.key }
		let validKeys = validKeySet.isSubset(of: Set(keys))
		return validKeys
	}

	private static func isValidPart2(input: String) -> Bool {
		let validKeySet: Set<String> = [
			"byr",
			"iyr",
			"eyr",
			"hgt",
			"hcl",
			"ecl",
			"pid",
			//			"cid"
		]

		let passportFields = input.split(separator: " ")
			.compactMap { $0.split(separator: ":") }
			.map { (key: String($0[0]), value: String($0[1])) }

		let keys = passportFields.map { $0.key }
		let validKeys = validKeySet.isSubset(of: Set(keys))

		let hasInvalidValues = passportFields
			.map { validValue(for: $0) }
			.contains(false)

		return validKeys && !hasInvalidValues
	}

	private static func validValue(for field: (key: String, value: String)) -> Bool {
		if field.key == "byr" {
			return field.value.count == 4
				&& field.value >= "1920"
				&& field.value <= "2002"
		}

		if field.key == "iyr" {
			return field.value.count == 4
				&& field.value >= "2010"
				&& field.value <= "2020"
		}

		if field.key == "eyr" {
			return field.value.count == 4
				&& field.value >= "2020"
				&& field.value <= "2030"
		}

		if field.key == "hgt" {
			if field.value.contains("cm") {
				let value = field.value.replacingOccurrences(of: "cm", with: "")
				return value >= "150"
					&& value <= "193"
			}
			if field.value.contains("in") {
				let value = field.value.replacingOccurrences(of: "in", with: "")
				return value >= "59"
					&& value <= "76"
			}
		}

		let validHairColorCharacterSet = CharacterSet(charactersIn: "#abcdef0123456789")
		if field.key == "hcl" {
			return field.value.starts(with: "#")
				&& field.value.count == 7
				&& validHairColorCharacterSet
				.isSuperset(of: CharacterSet(charactersIn: field.value))
		}

		let validEyeColorEntries = ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
		if field.key == "ecl" {
			return validEyeColorEntries.contains(field.value)
		}

		if field.key == "pid" {
			return field.value.count == 9
				&& CharacterSet.decimalDigits
				.isSuperset(of: CharacterSet(charactersIn: field.value))
		}

		if field.key == "cid" {
			return true
		}

		return false
	}
}
