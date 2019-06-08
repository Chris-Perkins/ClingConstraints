//
//  FillMethod.swift
//  ClingConstraints
//
//  Created by Christopher Perkins on 7/1/18.
//  Copyright © 2018 Christopher Perkins. All rights reserved.
//

/// An enum defining the different ways to fill something.
///
/// - topToBottom: A method for filling something from the top to the bottom.
/// - bottomToTop: A method for filling something from the bottom to the top.
/// - leftToRight: A method for filling something from the left to the right.
/// - rightToLeft: A method for filling something from the right to the left.
public enum FillMethod {
    case topToBottom
    case bottomToTop
    case leftToRight
    case rightToLeft
}
