//
//  CLBoard.h
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

#ifndef __CLBOARD_H__
#define __CLBOARD_H__

/**
 *  Keys for the dictionary returned from our available moves method.
 */
extern NSString * const kTotal;
extern NSString * const kJumps;
extern NSString * const kMoves;

#endif

@interface CLBoard : NSObject

/**
 *  Create our board.
 *
 *  @return A new board.
 */
- (instancetype)init;

/**
 *  Get the type of the space on the board.
 *
 *  @param location The location of the space.
 *
 *  @return The space type.
 */
- (SpaceType)getSpaceTypeOfLocation:(CLBoardLocation)location;

/**
 *  Moves a piece on the board.
 *
 *  @param fromLocation The location to move the piece from.
 *  @param toLocation   The location to move the piece to.
 */
- (void)movePieceFromLocation:(CLBoardLocation)fromLocation toLocation:(CLBoardLocation)toLocation;

/**
 *  Removes a piece from the board.
 *
 *  @param location The location of the piece to remove.
 */
- (void)removePieceFromLocation:(CLBoardLocation)location;

/**
 *  Gets the available moves for the provided player.
 *
 *  @param player The player to get the moves for.
 *
 *  @return A dictionary of moves.
 */
- (NSDictionary *)availableMovesForPlayer:(PlayerTurn)player;

@end
