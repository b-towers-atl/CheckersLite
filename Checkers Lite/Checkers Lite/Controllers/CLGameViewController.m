//
//  CLGameViewController.m
//  Checkers Lite
//
//  Created by Steven Mattera on 6/11/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

#import "CLGameViewController.h"
#import "CLBoard.h"
#import "CLMove.h"

@implementation CLGameViewController {
    PlayerTurn _currentTurn;
    CLBoardLocation _selectedLocation;
    
    int _playerOneScore;
    int _playerTwoScore;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // Start new game.
    [self newGame];
}

#pragma mark Private Methods

/**
 *  Starts a new game.
 */
- (void)newGame {
    // Always start with player one, non location selected, and reset the score.
    _currentTurn = kPlayerOne;
    _selectedLocation.x = -1;
    _selectedLocation.y = -1;
    _playerOneScore = 0;
    _playerTwoScore = 0;

    // Reset our labels
    [self.currentPlayerLabel setText:NSLocalizedString(@"Player1", nil)];
    [self.playerOneLabel setText:[NSString stringWithFormat:NSLocalizedString(@"p1", nil), _playerOneScore]];
    [self.playerTwoLabel setText:[NSString stringWithFormat:NSLocalizedString(@"p2", nil), _playerTwoScore]];
    
    // Reset our board.
    CLBoard * boardData = [[CLBoard alloc] init];
    [self.boardView setBoardData:boardData];
    [self.boardView clearSelection];
}

/**
 *  Call when a turn is completed.
 */
- (void)turnComplete {
    // Update score labels
    [self.playerOneLabel setText:[NSString stringWithFormat:NSLocalizedString(@"p1", nil), _playerOneScore]];
    [self.playerTwoLabel setText:[NSString stringWithFormat:NSLocalizedString(@"p2", nil), _playerTwoScore]];
    
    // If the current turn was player one.
    if (_currentTurn == kPlayerOne) {
        _currentTurn = kPlayerTwo;
        
        // Update our label
        [self.currentPlayerLabel setText:NSLocalizedString(@"Player2", nil)];
        
        // Make sure we can still make a move.
        NSDictionary * plays = [[self.boardView boardData] availableMovesForPlayer:_currentTurn];
        if ([[plays objectForKey:kTotal] intValue] > 0) {
            // AI Logic
            
            // Do we have a jump?
            if ([[plays objectForKey:kJumps] count] > 0) {
                CLMove * move = [[plays objectForKey:kJumps] objectAtIndex:0];
                
                // Get the enemy piece location.
                CLBoardLocation enemyLoc;
                enemyLoc.x = (move.fromLocation.x + move.toLocation.x) / 2;
                enemyLoc.y = (move.fromLocation.y + move.toLocation.y) / 2;
                
                // Move the piece and remove the enemy piece.
                [[self.boardView boardData] movePieceFromLocation:move.fromLocation
                                                       toLocation:move.toLocation];
                [[self.boardView boardData] removePieceFromLocation:enemyLoc];
                [self.boardView clearSelection];
                
                // Up our score.
                _playerTwoScore++;
                
                // Complete our turn.
                [self turnComplete];
            }
            else {
                // Pick a random move.
                NSArray * moves = [plays objectForKey:kMoves];
                NSUInteger randomIndex = arc4random() % [moves count];
                
                // Move the piece and complete our turn.
                CLMove * move = [moves objectAtIndex:randomIndex];
                [[self.boardView boardData] movePieceFromLocation:move.fromLocation
                                                       toLocation:move.toLocation];
                [self.boardView clearSelection];
                [self turnComplete];
            }
        }
        else {
            [self gameOver];
        }
    }
    // If the current turn is player two.
    else {
        _currentTurn = kPlayerOne;
        
        // Update our label.
        [self.currentPlayerLabel setText:NSLocalizedString(@"Player1", nil)];
        
        // Make sure we can still make a move.
        NSDictionary * moves = [[self.boardView boardData] availableMovesForPlayer:_currentTurn];
        if ([[moves objectForKey:kTotal] intValue] == 0) {
            [self gameOver];
        }
    }
}

/**
 *  Call when the game is over
 */
- (void)gameOver {
    // Prevent moves.
    _currentTurn = kPlayerNone;
    
    UIAlertView * alert;
    
    // Player 1 wins
    if (_playerOneScore > _playerTwoScore) {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GameOver", nil)
                                           message:NSLocalizedString(@"P1Wins", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"NewGame", nil)
                                 otherButtonTitles:nil];
    }
    // Player 2 wins
    else if (_playerTwoScore > _playerOneScore) {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GameOver", nil)
                                           message:NSLocalizedString(@"P2Wins", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"NewGame", nil)
                                 otherButtonTitles:nil];
    }
    // Draw
    else {
        alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"GameOver", nil)
                                           message:NSLocalizedString(@"Draw", nil)
                                          delegate:self
                                 cancelButtonTitle:NSLocalizedString(@"NewGame", nil)
                                 otherButtonTitles:nil];
    }
    
    [alert setTag:1];
    [alert show];
}

#pragma mark Public Methods

/**
 *  Action for "New Game" button.
 *
 *  @param sender The "New Game" button.
 */
- (IBAction)restartGame:(id)sender {
    // If they recieved a game over just instantly restart the game.
    if (_currentTurn == kPlayerNone) {
        [self newGame];
    }
    else {
        // Confirm the user wants to restart the game.
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppName", nil)
                                                         message:NSLocalizedString(@"Restart", nil)
                                                        delegate:self
                                               cancelButtonTitle:NSLocalizedString(@"No", nil)
                                               otherButtonTitles:NSLocalizedString(@"Yes", nil), nil];
        [alert setTag:0];
        [alert show];
    }
}

#pragma mark CLGameBoardDelegate Methods

- (void)gameBoard:(CLBoardView *)board placeTouchedOnCoordinate:(CLBoardLocation)location {
    // Make sure it's player one turn.
    if (_currentTurn == kPlayerOne) {
        switch ([[board boardData] getSpaceTypeOfLocation:location]) {
            case kPlayerOneSpace:
                // Select the piece on the board.
                _selectedLocation = location;
                [board setSelectedSpace:location];
                break;

            case kEmptySpace:
                // Make sure a piece is selected.
                if (_selectedLocation.x != -1 && _selectedLocation.y != -1) {
                    // Get the move set.
                    NSDictionary * moves = [[self.boardView boardData] availableMovesForPlayer:_currentTurn];
                    
                    
                    if ([[moves objectForKey:kJumps] count] == 0 && location.y == (_selectedLocation.y - 1)) {
                        // Left of selected location?
                        if (location.x == (_selectedLocation.x - 1)) {
                            [[board boardData] movePieceFromLocation:_selectedLocation toLocation:location];
                            [board clearSelection];
                            [self turnComplete];
                        }
                        // Right of selected location?
                        else if (location.x == (_selectedLocation.x + 1)) {
                            [[board boardData] movePieceFromLocation:_selectedLocation toLocation:location];
                            [board clearSelection];
                            [self turnComplete];
                        }
                    }
                    // Skipping a piece?
                    else if (location.y == (_selectedLocation.y - 2)) {
                        // Left of location?
                        if (location.x == (_selectedLocation.x - 2)) {
                            CLBoardLocation enemyLoc;
                            enemyLoc.x = _selectedLocation.x - 1;
                            enemyLoc.y = _selectedLocation.y - 1;
                            
                            if ([[board boardData] getSpaceTypeOfLocation:enemyLoc] == kPlayerTwoSpace) {
                                [[board boardData] movePieceFromLocation:_selectedLocation toLocation:location];
                                [[board boardData] removePieceFromLocation:enemyLoc];
                                [board clearSelection];
                                
                                _playerOneScore++;
                                
                                [self turnComplete];
                            }
                        }
                        // Right of location?
                        else if (location.x == (_selectedLocation.x + 2)) {
                            CLBoardLocation enemyLoc;
                            enemyLoc.x = _selectedLocation.x + 1;
                            enemyLoc.y = _selectedLocation.y - 1;
                            
                            if ([[board boardData] getSpaceTypeOfLocation:enemyLoc] == kPlayerTwoSpace) {
                                [[board boardData] movePieceFromLocation:_selectedLocation toLocation:location];
                                [[board boardData] removePieceFromLocation:enemyLoc];
                                [board clearSelection];
                                
                                _playerOneScore++;
                                
                                [self turnComplete];
                            }
                        }
                    }
                }
                else {
                    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppName", nil)
                                                                     message:NSLocalizedString(@"SelectTile", nil)
                                                                    delegate:nil
                                                           cancelButtonTitle:NSLocalizedString(@"Ok", nil)
                                                           otherButtonTitles:nil];
                    [alert show];
                }
                break;
                
            default:
                break;
        }
    }
}

#pragma mark UIAlertViewDelegate Methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // New Game Alert View - Yes Button
    if (alertView.tag == 0 && buttonIndex == 1) {
        [self newGame];
    }
    // Game Over Alert View
    else if (alertView.tag == 1) {
        [self newGame];
    }
}

@end
