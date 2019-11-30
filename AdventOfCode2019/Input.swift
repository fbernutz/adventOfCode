//
//  Input.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 30.11.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

enum Input {
    static func get(_ fileName: String) -> String {
        let url = URL(fileURLWithPath: #file)
        .deletingLastPathComponent()
        .appendingPathComponent("Days")
        .appendingPathComponent(fileName)

        guard let content = try? String(contentsOf: url) else {
            fatalError("Could not read content of file")
        }
        return content
    }
}
