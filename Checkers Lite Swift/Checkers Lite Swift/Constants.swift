//
//  Constants.swift
//  Checkers Lite
//
//  Created by Steven Mattera on 6/13/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

let GRID_WIDTH = 8
let GRID_HEIGHT = 8

struct BoardLocation {
    var x: Int
    var y: Int
}

struct MoveList {
    var total: Int
    var jumps: Array<Move>
    var moves: Array<Move>
}

enum SpaceType {
    case OffLimits
    case Empty
    case PlayerOne
    case PlayerTwo
}

enum PlayerTurn {
    case None
    case PlayerOne
    case PlayerTwo
} ;