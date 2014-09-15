//
//  CLMove.m
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

#import "CLMove.h"

@implementation CLMove

/**
 *  Constructor for our move object.
 *
 *  @param from The location to move from.
 *  @param to   The location to move to.
 *
 *  @return A new move object.
 */
- (instancetype)initWithFromLocation:(CLBoardLocation)from withToLocation:(CLBoardLocation)to {
    if (self = [super init]) {
        self.fromLocation = from;
        self.toLocation = to;
    }
    
    return self;
}

/**
 *  Useful for debugging, allows for loggin of our object.
 *
 *  @return Description of our object.
 */
-(NSString *)description{
    return [NSString stringWithFormat:@"From Location: (%d, %d) | To Location: (%d, %d)", self.fromLocation.x, self.fromLocation.y, self.toLocation.x, self.toLocation.y];
}

@end
