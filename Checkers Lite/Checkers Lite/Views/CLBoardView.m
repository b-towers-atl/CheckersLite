//
//  CLBoardView.m
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

#import "CLBoardView.h"
#import "CLBoard.h"

@implementation CLBoardView {
    CLBoardLocation _selectedSpace;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        // Disable multi touch.
        [self setMultipleTouchEnabled:NO];
        
        // Used for detecting taps on spaces.
        UITapGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleGesture:)];
        [self addGestureRecognizer:tapRecognizer];
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context  = UIGraphicsGetCurrentContext();
    
    // Get the width and height of each of our spaces.
    CGFloat width = self.bounds.size.width / GRID_WIDTH;
    CGFloat height = self.bounds.size.width / GRID_HEIGHT;
    
    // Loop through our board.
    for (int y = 0; y < GRID_HEIGHT; y++) {
        // Alternate the starting color for each row.
        CGColorRef currentColor = ((y % 2) == 0)?[[UIColor blackColor] CGColor]:nil;
        for (int x = 0; x < GRID_WIDTH; x++) {
            // Swap the color for each column.
            if (currentColor == nil) {
                // Is the space selected?
                if (_selectedSpace.x == x && _selectedSpace.y == y) {
                    currentColor = [[UIColor blueColor] CGColor];
                }
                else {
                    currentColor = [[UIColor blackColor] CGColor];
                }
                
                // Fill in the background for the space.
                CGContextSetFillColorWithColor(context, currentColor);
                CGContextFillRect(context, CGRectMake(width * x, height * y, width, height));
                
                // Is our board data available?
                if (self.boardData != nil) {
                    CLBoardLocation loc;
                    loc.x = x;
                    loc.y = y;
                    
                    SpaceType type = [self.boardData getSpaceTypeOfLocation:loc];
                    
                    // Does player one have a piece in this space?
                    if (type == kPlayerOneSpace) {
                        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
                        CGContextFillEllipseInRect(context, CGRectMake((width * x) + 5, (height * y) + 5, width - 10, height - 10));
                    }
                    // Does player two have a piece in this space?
                    else if (type == kPlayerTwoSpace) {
                        CGContextSetFillColorWithColor(context, [[UIColor redColor] CGColor]);
                        CGContextFillEllipseInRect(context, CGRectMake((width * x) + 5, (height * y) + 5, width - 10, height - 10));
                    }
                }
            }
            // Simply just show the background color.
            else {
                currentColor = nil;
            }
        }
    }
}

#pragma mark Private Methods

- (void)handleGesture:(UIGestureRecognizer *)gestureRecognizer {
    CGPoint point = [gestureRecognizer locationInView:self];
    
    // Figure out our board location based on the touch location.
    CLBoardLocation loc;
    loc.x = abs((int) floor(point.x / (self.bounds.size.width / GRID_WIDTH)));
    loc.y = abs((int) floor(point.y / (self.bounds.size.height / GRID_HEIGHT)));
    
    // Is our delegate set and will it respond to the selector?
    if (self.delegate != nil &&
        [self.delegate respondsToSelector:@selector(gameBoard:placeTouchedOnCoordinate:)]) {
        [self.delegate gameBoard:self placeTouchedOnCoordinate:loc];
    }
}

#pragma mark Public Methods

/**
 *  Set a space as selected.
 *
 *  @param location The location to select.
 */
- (void)setSelectedSpace:(CLBoardLocation)location {
    _selectedSpace = location;
    [self setNeedsDisplay];
}

/**
 *  Clear the selection on screen.
 */
- (void)clearSelection {
    _selectedSpace.x = -1;
    _selectedSpace.y = -1;
    [self setNeedsDisplay];
}


@end
