//
//  Board.swift
//  Checkers Lite
//
//  Created by Steven Mattera on 6/13/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

import Foundation

class Board {
    var boardData: Array<Array<SpaceType>>
    
    init() {
        self.boardData = Array<Array<SpaceType>>()
        
        for y in 0..<GRID_HEIGHT {
            self.boardData.append(Array(count:GRID_WIDTH, repeatedValue:SpaceType.OffLimits))
            for x in 0..<GRID_WIDTH {
                if (y % 2 == 0 && x % 2 != 0) || (y % 2 != 0 && x % 2 == 0) {
                    if y < 3 {
                        self.boardData[y][x] = SpaceType.PlayerTwo
                    }
                    else if y > 4 {
                        self.boardData[y][x] = SpaceType.PlayerOne
                    }
                    else {
                        self.boardData[y][x] = SpaceType.Empty
                    }
                }
            }
        }
    }
    
    func getSpaceType(location: BoardLocation) -> SpaceType {
        if location.x >= 0 && location.x < GRID_WIDTH && location.y >= 0 && location.y < GRID_HEIGHT {
            return self.boardData[location.y][location.x]
        }
    
        return SpaceType.OffLimits;
    }
    
    func movePiece(fromLocation: BoardLocation, _ toLocation: BoardLocation) {
        self.boardData[toLocation.y][toLocation.x] = self.boardData[fromLocation.y][fromLocation.x]
        self.boardData[fromLocation.y][fromLocation.x] = SpaceType.Empty
    }
    
    func removePiece(location: BoardLocation) {
        if self.boardData[location.y][location.x] != SpaceType.OffLimits {
            self.boardData[location.y][location.x] = SpaceType.Empty
        }
    }
    
    func availableMoves(player: PlayerTurn) -> MoveList {
        var listOfJumps = Array<Move>()
        var listOfMoves = Array<Move>()
        
        // Which direction are we triversing?
        var yDirection = -1

        // The player space and the enemy space.
        var playerSpace = SpaceType.PlayerOne
        var enemySpace = SpaceType.PlayerTwo
        
        if (player != PlayerTurn.PlayerOne) {
            yDirection = 1
            playerSpace = SpaceType.PlayerTwo
            enemySpace = SpaceType.PlayerOne
        }
        
        for y in 0..<GRID_HEIGHT {
            for x in 0..<GRID_WIDTH {
                // A space owned by our player.
                if self.boardData[y][x] == playerSpace {
                    // Can move left?
                    if y + yDirection > 0 && y + yDirection < GRID_HEIGHT && x - 1 >= 0 {
                        // If space is empty?
                        if self.boardData[y + yDirection][x - 1] == SpaceType.Empty {
                            var fromLoc = BoardLocation(x: x, y: y)
                            var toLoc = BoardLocation(x: x - 1, y: y + yDirection)
                            var move = Move(fromLoc, toLoc)
                            listOfMoves.append(move)
                        }
                        // If space is enemy and next place over is available and empty? (Jumpable)
                        else if self.boardData[y + yDirection][x - 1] == enemySpace &&
                            y + (yDirection * 2) > 0 && y + (yDirection * 2) < GRID_HEIGHT && x - 2 >= 0 &&
                            self.boardData[y + (yDirection * 2)][x - 2] == SpaceType.Empty {
                            
                                var fromLoc = BoardLocation(x: x, y: y)
                                var toLoc = BoardLocation(x: x - 2, y: y + (yDirection * 2))
                                var move = Move(fromLoc, toLoc)
                                listOfJumps.append(move)
                        }
                    }
                    
                    // Can move Right?
                    if y + yDirection > 0 && y + yDirection < GRID_HEIGHT && x + 1 < GRID_WIDTH {
                        // If space is empty?
                        if self.boardData[y + yDirection][x + 1] == SpaceType.Empty {
                            var fromLoc = BoardLocation(x: x, y: y)
                            var toLoc = BoardLocation(x: x + 1, y: y + yDirection)
                            var move = Move(fromLoc, toLoc)
                            listOfMoves.append(move)
                        }
                        // If space is enemy and next place over is available and empty? (Jumpable)
                        else if self.boardData[y + yDirection][x + 1] == enemySpace &&
                            y + (yDirection * 2) > 0 && y + (yDirection * 2) < GRID_HEIGHT && x + 2 < GRID_WIDTH &&
                            self.boardData[y + (yDirection * 2)][x + 2] == SpaceType.Empty {
                                
                                var fromLoc = BoardLocation(x: x, y: y)
                                var toLoc = BoardLocation(x: x + 2, y: y + (yDirection * 2))
                                var move = Move(fromLoc, toLoc)
                                listOfJumps.append(move)
                        }
                    }
                }
            }
        }
        
        return MoveList(total: (listOfJumps.count + listOfMoves.count), jumps: listOfJumps, moves: listOfMoves)
    }
}