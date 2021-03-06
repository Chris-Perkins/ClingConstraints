//
//  NSLayoutConstraintExtension.swift
//  ClingConstraintsDemo
//
//  Created by Christopher Perkins on 6/24/18.
//  Copyright © 2018 Christopher Perkins. All rights reserved.
//

import UIKit

public extension NSLayoutConstraint {

    /// Creates a new constraint with the given multiplier and the original constraint's other properties, deactivates
    /// and removes the old constraint, activates the created constraint if the original constraint was active, and
    /// returns the created constraint.
    ///
    /// - Parameter newMultiplier: The multiplier that should be set for the new constraint
    /// - Returns: The new activated constraint with the provided `newMultiplier` value
    @discardableResult func withMultiplier(_ newMultiplier: CGFloat) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(item: firstItem!,
                                               attribute: firstAttribute,
                                               relatedBy: relation,
                                               toItem: secondItem,
                                               attribute: secondAttribute,
                                               multiplier: newMultiplier,
                                               constant: constant)
        let originallyActive = isActive
        isActive = false
        firstItem?.removeConstraint(self)
        newConstraint.isActive = originallyActive

        return newConstraint
    }

    /// Sets the offset of this constraint and returns it again.
    ///
    /// - Parameter offset: The offset that the constraint should have
    /// - Returns: This constraint with the offset of the provided offset value
    @discardableResult func withOffset(_ offset: CGFloat) -> NSLayoutConstraint {
        let originallyActive = isActive
        isActive = false
        constant = offset
        isActive = originallyActive
        
        return self
    }

    /// Creates a new constraint with the given priority and the original constraint's other properties, deactivates and
    /// removes the old constraint, activates the created constraint if the original constraint was active, and returns
    /// the created constraint.
    ///
    /// - Parameter priority: The priority that should be set for the new constraint
    /// - Returns: The new constraint with the provided `priority` value
    @discardableResult func withPriority( _ priority: UILayoutPriority) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(item: firstItem!,
                                               attribute: firstAttribute,
                                               relatedBy: relation,
                                               toItem: secondItem,
                                               attribute: secondAttribute,
                                               multiplier: multiplier,
                                               constant: constant)
        newConstraint.priority = priority

        let originallyActive = isActive
        isActive = false
        firstItem?.removeConstraint(self)
        newConstraint.isActive = originallyActive
        return self
    }

    /// Creates a new constraint with the given relation and the original constraint's other properties, deactivates and
    /// removes the old constraint, activates the created constraint if the original constraint was active, and returns
    /// the created constraint.
    ///
    /// - Parameter newRelation: The relation that should be set for the new constraint
    /// - Returns: The new constraint with the provided `newRelation` value
    @discardableResult func withRelation(_ newRelation: NSLayoutConstraint.Relation) -> NSLayoutConstraint {
        let newConstraint = NSLayoutConstraint(item: firstItem!,
                                               attribute: firstAttribute,
                                               relatedBy: newRelation,
                                               toItem: secondItem,
                                               attribute: secondAttribute,
                                               multiplier: multiplier,
                                               constant: constant)
        let originallyActive = isActive
        isActive = false
        firstItem?.removeConstraint(self)
        newConstraint.isActive = originallyActive

        return newConstraint
    }
}
