//
//  ViewController.swift
//  Checkers Lite
//
//  Created by Steven Mattera on 6/13/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, BoardViewDelegate, UIAlertViewDelegate {
    @IBOutlet weak var currentPlayerLabel: UILabel!
    @IBOutlet weak var playerOneLabel: UILabel!
    @IBOutlet weak var playerTwoLabel: UILabel!
    @IBOutlet weak var boardView: BoardView!
    
    var currentTurn = PlayerTurn.PlayerOne
    var selectedLocation: BoardLocation?
    var playerOneScore = 0
    var playerTwoScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.boardView.delegate = self
        
        // Start new game
        self.newGame()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func newGame() {
        self.currentTurn = PlayerTurn.PlayerOne
        self.selectedLocation = nil
        self.playerOneScore = 0
        self.playerTwoScore = 0
        
        self.currentPlayerLabel.text = "Player One"
        self.playerOneLabel.text = "P1: 0"
        self.playerTwoLabel.text = "P2: 0"
        
        let boardData = Board()
        self.boardView.boardData = boardData
        self.boardView.selectedSpace = nil
        self.boardView.setNeedsDisplay()
    }
    
    func turnComplete() {
        // Update score labels
        self.playerOneLabel.text = "P1: \(self.playerOneScore)"
        self.playerTwoLabel.text = "P2: \(self.playerTwoScore)"
        
        // If the current turn was player one.
        if self.currentTurn == PlayerTurn.PlayerOne {
            self.currentTurn = PlayerTurn.PlayerTwo
            self.currentPlayerLabel!.text = "Player Two"
            
            // Make sure we can still make a move.
            let moves = self.boardView.boardData!.availableMoves(self.currentTurn)
            if moves.total > 0 {
                // AI Logic
                
                // Do we have a jump?
                if moves.jumps.count > 0 {
                    let move = moves.jumps[0]
                    
                    // Get the enemy piece location.
                    let enemyLoc = BoardLocation(x: (move.fromLocation.x + move.toLocation.x) / 2, y: (move.fromLocation.y + move.toLocation.y) / 2)
                    self.boardView.boardData!.movePiece(move.fromLocation, move.toLocation)
                    self.boardView.boardData!.removePiece(enemyLoc)
                    
                    self.playerTwoScore++

                    self.boardView.selectedSpace = nil
                    self.selectedLocation = nil
                    self.boardView.setNeedsDisplay()
                    self.turnComplete()
                }
                else {
                    var randomIndex = arc4random() % UInt32(moves.moves.count);
                    let move = moves.moves[Int(randomIndex)]
                    self.boardView.boardData!.movePiece(move.fromLocation, move.toLocation)
                    self.boardView.selectedSpace = nil
                    self.selectedLocation = nil
                    self.boardView.setNeedsDisplay()
                    self.turnComplete()
                }
            }
            else {
               self.gameOver()
            }
        }
        else {
            self.currentTurn = PlayerTurn.PlayerOne
            self.currentPlayerLabel.text = "Player One"

            // Make sure we can still make a move.
            let moves = self.boardView.boardData!.availableMoves(self.currentTurn)
            if moves.total == 0 {
                self.gameOver()
            }
        }
    }
    
    func gameOver() {
        self.currentTurn = PlayerTurn.None;
        
        var alert = UIAlertView()
        alert.title = "Game Over"
        alert.delegate = self
        alert.addButtonWithTitle("New Game")
        alert.tag = 1

        // Player 1 wins
        if (self.playerOneScore > self.playerTwoScore) {
            alert.message = "Player One Wins!"
        }
        // Player 2 wins
        else if (self.playerTwoScore > self.playerOneScore) {
            alert.message = "Player Two Wins!"
        }
        // Draw
        else {
            alert.message = "Draw!"
        }
        
        alert.show()
    }
    
    @IBAction func restartGame() {
        if self.currentTurn == PlayerTurn.None {
            self.newGame()
        }
        else {
            var alert = UIAlertView()
            alert.title = "Checkers Lite"
            alert.message = "Are you sure you want to restart the game?"
            alert.delegate = self
            alert.addButtonWithTitle("No")
            alert.addButtonWithTitle("Yes")
            alert.tag = 0
            alert.show()
        }
    }
    
    func placeTouched(board: BoardView, _ location: BoardLocation) {
        if self.currentTurn == PlayerTurn.PlayerOne {
            let space = board.boardData!.getSpaceType(location)
            
            if space == SpaceType.PlayerOne {
                self.selectedLocation = location
                board.selectedSpace = location
                board.setNeedsDisplay()
            }
            else if space == SpaceType.Empty {
                if self.selectedLocation != nil {
                    // Get the move set.
                    let moves: MoveList = self.boardView.boardData!.availableMoves(self.currentTurn)
                    
                    // If there is no jumps and the location to move to is 1 space up.
                    if moves.jumps.count == 0 && location.y == self.selectedLocation!.y - 1 {
                        // Left or Right of selected location?
                        if location.x == self.selectedLocation!.x - 1 || location.x == self.selectedLocation!.x + 1 {
                            self.boardView.boardData!.movePiece(self.selectedLocation!, location)
                            self.boardView.selectedSpace = nil
                            self.selectedLocation = nil
                            self.boardView.setNeedsDisplay()
                            self.turnComplete()
                        }
                    }
                    // Skipping a piece?
                    else if (location.y == self.selectedLocation!.y - 2) {
                        // Left of selected location?
                        if location.x == self.selectedLocation!.x - 2 {
                            let enemyLoc = BoardLocation(x: self.selectedLocation!.x - 1, y: self.selectedLocation!.y - 1)
                            let enemySpaceType = self.boardView.boardData!.getSpaceType(enemyLoc)

                            if enemySpaceType == SpaceType.PlayerTwo {
                                self.boardView.boardData!.movePiece(self.selectedLocation!, location)
                                self.boardView.boardData!.removePiece(enemyLoc)
                                
                                self.playerOneScore++
                                
                                self.boardView.selectedSpace = nil
                                self.selectedLocation = nil
                                self.boardView.setNeedsDisplay()
                                self.turnComplete()
                            }
                        }
                        // Right of selected location?
                        else if location.x == self.selectedLocation!.x + 2 {
                            let enemyLoc = BoardLocation(x: self.selectedLocation!.x + 1, y: self.selectedLocation!.y - 1)
                            let enemySpaceType = self.boardView.boardData!.getSpaceType(enemyLoc)
                            
                            if enemySpaceType == SpaceType.PlayerTwo {
                                self.boardView.boardData!.movePiece(self.selectedLocation!, location)
                                self.boardView.boardData!.removePiece(enemyLoc)
                                
                                self.playerOneScore++
                                
                                self.boardView.selectedSpace = nil
                                self.selectedLocation = nil
                                self.boardView.setNeedsDisplay()
                                self.turnComplete()
                            }
                        }
                    }
                }
            }
        }
    }
    
    func alertView(alertView: UIAlertView!, clickedButtonAtIndex buttonIndex: Int) {
        // New Game Alert View - Yes Button
        if alertView.tag == 0 && buttonIndex == 1 {
            self.newGame()
        }
        // Game Over Alert View
        else if alertView.tag == 1 {
            self.newGame()
        }
    }
}

