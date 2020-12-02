//
//  String+Index.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 02.12.20.
//  Copyright © 2020 fbe. All rights reserved.
//

import Foundation

extension String {
	subscript (index: Int) -> String {
		let start = String.Index(utf16Offset: index, in: self)
		let end = String.Index(utf16Offset: index, in: self)
		return String(self[start...end])
	}
}
