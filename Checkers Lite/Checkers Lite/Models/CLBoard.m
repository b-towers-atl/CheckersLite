//
//  CLBoard.m
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

#import "CLBoard.h"
#import "CLMove.h"

NSString * const kTotal = @"total";
NSString * const kJumps = @"jumps";
NSString * const kMoves = @"moves";

@implementation CLBoard {
    int _boardData[GRID_WIDTH][GRID_HEIGHT];
}

/**
 *  Create our board.
 *
 *  @return A new board.
 */
- (instancetype)init {
    if (self = [super init]) {
        for (int y = 0; y < GRID_HEIGHT; y++) {
            for (int x = 0; x < GRID_WIDTH; x++) {
                _boardData[y][x] = kOffLimits;
                
                if ((y % 2) == 0 && (x % 2) != 0) {
                    if (y < 3) {
                        _boardData[y][x] = kPlayerTwoSpace;
                    }
                    else if (y > 4) {
                        _boardData[y][x] = kPlayerOneSpace;
                    }
                    else {
                        _boardData[y][x] = kEmptySpace;
                    }
                }
                else if ((y % 2) != 0 && (x % 2) == 0) {
                    if (y < 3) {
                        _boardData[y][x] = kPlayerTwoSpace;
                    }
                    else if (y > 4) {
                        _boardData[y][x] = kPlayerOneSpace;
                    }
                    else {
                        _boardData[y][x] = kEmptySpace;
                    }
                }
            }
        }
    }
    
    return self;
}

#pragma mark Public Methods

/**
 *  Get the type of the space on the board.
 *
 *  @param location The location of the space.
 *
 *  @return The space type.
 */
- (SpaceType)getSpaceTypeOfLocation:(CLBoardLocation)location {
    if (location.x >= 0 && location.x < GRID_WIDTH && location.y >= 0 && location.y < GRID_HEIGHT) {
        return _boardData[location.y][location.x];
    }
    
    return kOffLimits;
}

/**
 *  Moves a piece on the board.
 *
 *  @param fromLocation The location to move the piece from.
 *  @param toLocation   The location to move the piece to.
 */
- (void)movePieceFromLocation:(CLBoardLocation)fromLocation toLocation:(CLBoardLocation)toLocation {
    _boardData[toLocation.y][toLocation.x] = _boardData[fromLocation.y][fromLocation.x];
    _boardData[fromLocation.y][fromLocation.x] = kEmptySpace;
}

/**
 *  Removes a piece from the board.
 *
 *  @param location The location of the piece to remove.
 */
- (void)removePieceFromLocation:(CLBoardLocation)location {
    if (_boardData[location.y][location.x] != kOffLimits) {
        _boardData[location.y][location.x] = kEmptySpace;
    }
}

/**
 *  Gets the available moves for the provided player.
 *
 *  @param player The player to get the moves for.
 *
 *  @return A dictionary of moves.
 */
- (NSDictionary *)availableMovesForPlayer:(PlayerTurn)player {
    NSMutableArray * listOfJumps = [[NSMutableArray alloc] init];
    NSMutableArray * listOfMoves = [[NSMutableArray alloc] init];
    
    // Which direction are we triversing?
    int yDirection = (player == kPlayerOne)?-1:1;
    
    // The player space and the enemy space.
    SpaceType playerSpace = (player == kPlayerOne)?kPlayerOneSpace:kPlayerTwoSpace;
    SpaceType enemySpace = (player == kPlayerOne)?kPlayerTwoSpace:kPlayerOneSpace;
    
    // Loop through our board.
    for (int y = 0; y < GRID_HEIGHT; y++) {
        for (int x = 0; x < GRID_WIDTH; x++) {
            // A space owned by our player.
            if (_boardData[y][x] == playerSpace) {
                // Can move left?
                if (y + yDirection > 0 && y + yDirection < GRID_HEIGHT && x - 1 >= 0) {
                    // If space is empty?
                    if (_boardData[y + yDirection][x - 1] == kEmptySpace) {
                        CLBoardLocation fromLoc;
                        fromLoc.x = x;
                        fromLoc.y = y;
                        
                        CLBoardLocation toLoc;
                        toLoc.x = x - 1;
                        toLoc.y = y + yDirection;
                        
                        [listOfMoves addObject:[[CLMove alloc] initWithFromLocation:fromLoc
                                                                     withToLocation:toLoc]];
                    }
                    // If space is enemy and next place over is available and empty? (Jumpable)
                    else if (_boardData[y + yDirection][x - 1] == enemySpace &&
                             y + (yDirection * 2) > 0 && y + (yDirection * 2) < GRID_HEIGHT && x - 2 >= 0 &&
                             _boardData[y + (yDirection * 2)][x - 2] == kEmptySpace) {
                        
                        CLBoardLocation fromLoc;
                        fromLoc.x = x;
                        fromLoc.y = y;
                        
                        CLBoardLocation toLoc;
                        toLoc.x = x - 2;
                        toLoc.y = y + (yDirection * 2);
                        
                        [listOfJumps addObject:[[CLMove alloc] initWithFromLocation:fromLoc
                                                                     withToLocation:toLoc]];
                    }
                }
                
                // Can move right?
                if (y + yDirection > 0 && y + yDirection < GRID_HEIGHT && x + 1 < GRID_WIDTH) {
                    // If space is empty?
                    if (_boardData[y + yDirection][x + 1] == kEmptySpace) {
                        CLBoardLocation fromLoc;
                        fromLoc.x = x;
                        fromLoc.y = y;
                        
                        CLBoardLocation toLoc;
                        toLoc.x = x + 1;
                        toLoc.y = y + yDirection;
                        
                        [listOfMoves addObject:[[CLMove alloc] initWithFromLocation:fromLoc
                                                                     withToLocation:toLoc]];
                    }
                    // If space is enemy and next place over is available and empty? (Jumpable)
                    else if (_boardData[y + yDirection][x + 1] == enemySpace &&
                             y + (yDirection * 2) > 0 && y + (yDirection * 2) < GRID_HEIGHT && x + 2 < GRID_WIDTH &&
                             _boardData[y + (yDirection * 2)][x + 2] == kEmptySpace) {
                        
                        CLBoardLocation fromLoc;
                        fromLoc.x = x;
                        fromLoc.y = y;
                        
                        CLBoardLocation toLoc;
                        toLoc.x = x + 2;
                        toLoc.y = y + (yDirection * 2);
                        
                        [listOfJumps addObject:[[CLMove alloc] initWithFromLocation:fromLoc
                                                                     withToLocation:toLoc]];
                    }
                }
            }
        }
    }
            
    return @{
             kTotal: [NSNumber numberWithInt:[listOfJumps count] + [listOfMoves count]],
             kJumps: listOfJumps,
             kMoves: listOfMoves
             };
}

@end
