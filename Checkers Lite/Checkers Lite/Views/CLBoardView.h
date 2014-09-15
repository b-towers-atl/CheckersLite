//
//  CLBoardView.h
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

@protocol CLBoardViewDelegate;
@class CLBoard;

@interface CLBoardView : UIView

@property (weak, nonatomic) IBOutlet id <CLBoardViewDelegate> delegate;
@property (strong, nonatomic) CLBoard * boardData;

/**
 *  Set a space as selected.
 *
 *  @param location The location to select.
 */
- (void)setSelectedSpace:(CLBoardLocation)location;

/**
 *  Clear the selection on screen.
 */
- (void)clearSelection;

@end


@protocol CLBoardViewDelegate <NSObject>

@optional
- (void)gameBoard:(CLBoardView *)board placeTouchedOnCoordinate:(CLBoardLocation)location;

@end
