//
//  CLConstants.h
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

#ifndef Checkers_Lite_CLConstants_h
#define Checkers_Lite_CLConstants_h

#define GRID_WIDTH 8
#define GRID_HEIGHT 8

struct CLBoardLocation {
    int x;
    int y;
};
typedef struct CLBoardLocation CLBoardLocation;

typedef enum {
    kOffLimits = -1,
    kEmptySpace,
    kPlayerOneSpace,
    kPlayerTwoSpace
} SpaceType;

typedef enum {
    kPlayerNone = 0,
    kPlayerOne,
    kPlayerTwo
} PlayerTurn;

#endif
