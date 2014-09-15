//
//  CLGameViewController.h
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

#import "CLBoardView.h"

@interface CLGameViewController : UIViewController <CLBoardViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel * currentPlayerLabel;
@property (weak, nonatomic) IBOutlet UILabel * playerOneLabel;
@property (weak, nonatomic) IBOutlet UILabel * playerTwoLabel;
@property (weak, nonatomic) IBOutlet CLBoardView * boardView;

- (IBAction)restartGame:(id)sender;

@end
