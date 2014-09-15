//
//  CLMove.h
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

@interface CLMove : NSObject

/**
 *  The location to move from.
 */
@property (assign, nonatomic) CLBoardLocation fromLocation;

/**
 *  The location to move to.
 */
@property (assign, nonatomic) CLBoardLocation toLocation;

/**
 *  Constructor for our move object.
 *
 *  @param from The location to move from.
 *  @param to   The location to move to.
 *
 *  @return A new move object.
 */
- (instancetype)initWithFromLocation:(CLBoardLocation)from withToLocation:(CLBoardLocation)to;

@end
