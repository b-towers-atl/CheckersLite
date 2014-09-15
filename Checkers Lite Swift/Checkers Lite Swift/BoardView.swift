//
//  BoardView.swift
//  Checkers Lite
//
//  Created by Steven Mattera on 6/13/14.
//  Copyright (c) 2014 Steven Mattera. All rights reserved.
//

import UIKit

protocol BoardViewDelegate {
    func placeTouched(board: BoardView, _ location: BoardLocation)
}

class BoardView: UIView {
    var selectedSpace: BoardLocation?
    var boardData: Board?
    var delegate: BoardViewDelegate?
    
    required init(coder aDecoder: NSCoder)  {
        super.init(coder: aDecoder)

        self.multipleTouchEnabled = false
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action:"handleGesture:")
        self.addGestureRecognizer(tapRecognizer)
    }
    
    override func drawRect(rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        // Get the width and height of each of our spaces.
        let width = Double(self.bounds.size.width) / Double(GRID_WIDTH)
        let height = Double(self.bounds.size.height) / Double(GRID_HEIGHT)
        
        // Loop through our board.
        for y in 0..<GRID_HEIGHT {
            // Alternate the starting color for each row.
            var currentColor: CGColorRef?
            if y % 2 == 0 {
                currentColor = UIColor.blackColor().CGColor
            }
            else {
                currentColor = nil
            }

            for x in 0..<GRID_WIDTH {
                // Swap the color for each column.
                if currentColor == nil {
                    // Is the space selected?
                    if self.selectedSpace != nil && self.selectedSpace!.x == x && self.selectedSpace!.y == y {
                        currentColor = UIColor.blueColor().CGColor
                    }
                    else {
                        currentColor = UIColor.blackColor().CGColor
                    }
                    
                    // Fill in the background for the space.
                    CGContextSetFillColorWithColor(context, currentColor)
                    CGContextFillRect(context, CGRectMake(CGFloat(width * Double(x)), CGFloat(height * Double(y)), CGFloat(width), CGFloat(height)))
                    
                    if self.boardData != nil {
                        var loc = BoardLocation(x: x, y: y)
                        var type = self.boardData!.getSpaceType(loc)
                        
                        // Does player one have a piece in this space?
                        if type == SpaceType.PlayerOne {
                            CGContextSetFillColorWithColor(context, UIColor.whiteColor().CGColor)
                            CGContextFillEllipseInRect(context, CGRectMake(CGFloat((width * Double(x)) + Double(5)), CGFloat((height * Double(y)) + Double(5)), CGFloat(width - Double(10)), CGFloat(height - Double(10))));
                        }
                        // Does player two have a piece in this space?
                        else if type == SpaceType.PlayerTwo {
                            CGContextSetFillColorWithColor(context, UIColor.redColor().CGColor)
                            CGContextFillEllipseInRect(context, CGRectMake(CGFloat((width * Double(x)) + Double(5)), CGFloat((height * Double(y)) + Double(5)), CGFloat(width - Double(10)), CGFloat(height - Double(10))));
                        }
                    }
                }
                // Simply just show the background color.
                else {
                    currentColor = nil
                }
            }
        }
    }
    
    func handleGesture(gestureRecognizer: UIGestureRecognizer) {
        let point = gestureRecognizer.locationInView(self)
        
        // Figure out our board location based on the touch location.
        let loc = BoardLocation(x: abs(Int(floor(Double(point.x) / (Double(self.bounds.size.width) / Double(GRID_WIDTH))))), y: abs(Int(floor(Double(point.y) / (Double(self.bounds.size.height) / Double(GRID_HEIGHT))))))
        
        if delegate != nil {
            delegate!.placeTouched(self, loc)
        }
    }
}