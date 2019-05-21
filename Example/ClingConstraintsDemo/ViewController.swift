//
//  ViewController.swift
//  ClingConstraintsDemo
//
//  Created by Christopher Perkins on 6/24/18.
//  Copyright © 2018 Christopher Perkins. All rights reserved.
//

import UIKit

/**
 A UIViewController that creates a grid of squares that pulses using programmatic constraints
 */
class ViewController: UIViewController {
    /**
     The amount of spacing when the square pulses inwards.
    */
    private static let bigSpacingAmount: CGFloat = 30
    /**
     The amount of spacing when the square pulses outwards.
    */
    private static let smallSpacingAmount: CGFloat = 5
    /**
     The number of squares per row/column.
    */
    private static let gridSize : Int = 3

    /**
     Calls the super method for viewDidLoad and creates the grid/it's child view constraints.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a view that's centered in the view
        let centerView = UIView()
        centerView.backgroundColor = UIColor.gray
        view.addSubview(centerView)
        centerView.copy(.centerX, .centerY, of: view)
        
        // If possible, take the maximum width possible while still remaining square
        centerView.copy(.width, of: view).withMultiplier(0.9).withPriority(.defaultLow)
        centerView.cling(.height, to: centerView, .width).withPriority(.defaultLow)
        
        /* In landscape, the width would cause the square to go off the screen!
            These constraints prevents that. Prevent the height from becoming greater than the
            screen's height, and make it square. */
        centerView.copy(.height, of: view).withRelation(.lessThanOrEqual).withOffset(-50)
            .withPriority(.defaultHigh)
        centerView.cling(.width, to: centerView, .height).withRelation(.lessThanOrEqual)
            .withPriority(.defaultHigh)
        
        var containedViews = [[UIView]]()
        var containerViews = [UIView]()
        for i in 1...ViewController.gridSize {
            let containerView = UIView()
            centerView.addSubview(containerView)
            // Copy the left and right constraints so this spans the horizontal space of the center
            containerView.copy(.left, .right, of: centerView)
            
            containerViews.append(containerView)
            containedViews.append([UIView]())
            
            for j in 1...ViewController.gridSize {
                let containedView = UIView()
                containedView.backgroundColor = (i + j) % 2 == 0 ? UIColor.red : UIColor.green
                containerView.addSubview(containedView)
                
                /* Copy the top and bottom of the containerView so this spans the vertical space of
                 the containedView */
                containedView.copy(.top, .bottom, of: containerView)
                
                containedViews[containedViews.count - 1].append(containedView)
            }
        }
        
        // These will hold the different types of constraints so we can pulse through them later.
        var spacedConstraints = [NSLayoutConstraint]()
        var unspacedConstraints = [NSLayoutConstraint]()
        
        /* Fill in the centerView vertically with the different containerViews; do this with and
            without spacing. */
        spacedConstraints.append(contentsOf: centerView
            .fill(.topToBottom, withViews: containerViews,withSpacing: ViewController.bigSpacingAmount))
        // De-activate to prevent breaking when creating unspaced constraints
        spacedConstraints.deactivateAllConstraints()
        unspacedConstraints.append(contentsOf: centerView
            .fill(.topToBottom, withViews: containerViews,
                  withSpacing: ViewController.smallSpacingAmount))
        
        for (index, viewsList) in containedViews.enumerated() {
            /* Because of the order we appended in, we know the containerView at the specified index
                contains the views in the viewsList at the same index. */
            spacedConstraints.append(contentsOf: containerViews[index]
                .fill(.leftToRight, withViews: viewsList,
                      withSpacing: ViewController.bigSpacingAmount))
            // De-activate to prevent breaking when creating unspaced constraints
            spacedConstraints.deactivateAllConstraints()
            unspacedConstraints.append(contentsOf: containerViews[index]
                .fill(.leftToRight, withViews: viewsList,
                      withSpacing: ViewController.smallSpacingAmount))
        }
        
        pulseBetween(initialPulseConstraints: spacedConstraints,
                     andOtherConstraints: unspacedConstraints, inContainingView: centerView)
    }
    
    /**
     Pulses between the initialPulseConstraints and the otherConstraints. Calls the containingView
     layoutIfNeeded whenever animation should be done.
     
     - Parameter initialPulseConstraints: The constraints that will be activated first
     - Parameter otherConstraints: The constraints that will be activated after the initial
        constraints
     - Parameter containingView: The view that will be called when the constraint animations should
        be performed.
    */
    private func pulseBetween(initialPulseConstraints: [NSLayoutConstraint],
                              andOtherConstraints otherConstraints: [NSLayoutConstraint],
                              inContainingView containingView: UIView) {
        /* NOTE: If you're confused on how the view zooms in... It's because we call containingView
         layoutIfNeeded() and not self.view.layoutIfNeeded() :) */
        
        Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { (timer) in
            otherConstraints.deactivateAllConstraints()
            initialPulseConstraints.activateAllConstraints()
            UIView.animate(withDuration: 4, animations: {
                containingView.layoutIfNeeded()
            })
            
            Timer.scheduledTimer(withTimeInterval: 5, repeats: false, block: { (timer2) in
                initialPulseConstraints.deactivateAllConstraints()
                otherConstraints.activateAllConstraints()
                UIView.animate(withDuration: 4, animations: {
                    containingView.layoutIfNeeded()
                })
            })
            }.fire()
    }
}

