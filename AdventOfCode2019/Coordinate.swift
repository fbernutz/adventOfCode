//
//  Coordinate.swift
//  AdventOfCode2019
//
//  Created by Felizia Bernutz on 11.12.19.
//  Copyright © 2019 fbe. All rights reserved.
//

import Foundation

struct Coordinate: Hashable {
    let x: Int
    let y: Int

    var distance: Int {
        return abs(x) + abs(y)
    }

    func moveForward(in direction: Direction) -> Coordinate {
        let newCoordinate: Coordinate
        switch direction {
        case .left:
            newCoordinate = Coordinate(x: x - 1, y: y)
        case .right:
            newCoordinate = Coordinate(x: x + 1, y: y)
        case .up:
            newCoordinate = Coordinate(x: x, y: y + 1)
        case .down:
            newCoordinate = Coordinate(x: x, y: y - 1)
        }
        return newCoordinate
    }
}
