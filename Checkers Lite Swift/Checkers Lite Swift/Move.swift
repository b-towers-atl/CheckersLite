//
//  Move.swift
//  Checkers Lite
//
//  Created by Steven Mattera on 6/13/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

import Foundation

class Move {
    var fromLocation: BoardLocation
    var toLocation: BoardLocation
    
    init(_ fromLocation: BoardLocation, _ toLocation: BoardLocation) {
        self.fromLocation = fromLocation
        self.toLocation = toLocation
    }
}