//
//  Direction.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 11.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

enum Direction: Int {
    case left = 0
    case right = 1
    case up
    case down

    func rotate(with currentDirection: Direction) -> Direction {
        let newDirection: Direction
        switch currentDirection {
        case .up:
            newDirection = self == .left ? .left : .right
        case .right:
            newDirection = self == .left ? .up : .down
        case .down:
            newDirection = self == .left ? .right : .left
        case .left:
            newDirection = self == .left ? .down : .up
        }
        return newDirection
    }
}
