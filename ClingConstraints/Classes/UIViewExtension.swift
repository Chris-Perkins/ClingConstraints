//
//  UIViewExtensions.swift
//  ClingConstraintsDemo
//
//  Created by Christopher Perkins on 6/24/18.
//  Copyright © 2018 Christopher Perkins. All rights reserved.
//

import UIKit

public extension UIView {

    /// Creates, activates, and returns a list of NSLayoutConstraint that copies the specified object's attributes.
    ///
    /// - Parameters:
    ///   - attributes: The attributes that should be copied
    ///   - objectToCopy: The object whose attributes should be copied from
    /// - Returns: A list of  NSLayoutConstraints that copy the specified objectToCopy's attributes
    @discardableResult func copy(_ attributes: NSLayoutConstraint.Attribute...,
                                 of objectToCopy: UIView) -> [NSLayoutConstraint] {
        return attributes.map { self.copy($0, of: objectToCopy) }
    }

    /// Creates, activates, and returns an NSLayoutConstraint that copies the specified object's attribute.
    ///
    /// - Parameters:
    ///   - attribute: The attribute that should be copied
    ///   - objectToCopy: The object whose attribute should be copied from
    /// - Returns: An NSLayoutConstraint that copies the specified objectToCopy's attribute
    @discardableResult func copy(_ attribute: NSLayoutConstraint.Attribute,
                                 of objectToCopy: Any) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let copiedConstraint = NSLayoutConstraint(item: self,
                                                  attribute: attribute,
                                                  relatedBy: .equal,
                                                  toItem: objectToCopy,
                                                  attribute: attribute,
                                                  multiplier: 1,
                                                  constant: 0)
        copiedConstraint.isActive = true

        return copiedConstraint
    }

    /// Creates, activats, and returns a constraint that clings this view's specified attribute to the specified
    /// object's clingedAttribute.
    ///
    /// - Parameters:
    ///   - clingerAttribute: The attribute that this view should cling from
    ///   - clingedObject: The view that should be clinged to
    ///   - clingedAttribute: The attribute from the clingedView that this constraint should cling to
    /// - Returns: The constraint that clings this view to the clingedObject with the specified attribute.
    ///
    /// Example: `cling(attribute: .left, toView: button, .right)` would cling this view's left-side to the button's
    /// right-side.
    @discardableResult func cling(_ clingerAttribute: NSLayoutConstraint.Attribute,
                                  to clingedObject: Any,
                                  _ clingedAttribute: NSLayoutConstraint.Attribute) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let clingedConstraint = NSLayoutConstraint(item: self,
                                                   attribute: clingerAttribute,
                                                   relatedBy: .equal,
                                                   toItem: clingedObject,
                                                   attribute: clingedAttribute,
                                                   multiplier: 1,
                                                   constant: 0)
        clingedConstraint.isActive = true

        return clingedConstraint
    }

    /// Creates, activates, and returns the constraints that are created to fill this view with the provided views with
    /// the given spacing for the provided fill method.
    ///
    /// - Parameters:
    ///   - fillMethod: The method that should be used to fill this view
    ///   - views: The views that should fill this view
    ///   - spacing: The amount of spacing between views
    ///   - spacesInternally: Determines if additional spacing is provided for the first view and last view with respect
    /// to this view.
    /// - Returns: The constraints created to fill this view. This will be a series of alternating constraints in the
    /// sequence of views provided.
    ///
    /// If internal spacing is toggled on, there will be additional spacing before the first view's left and the last
    /// view's right margins with respect to this view.
    ///
    /// If internal spacing is toggled off, there will not be additional spacing before the first view's left and the
    /// last view's right margins with respect to this view.
    ///
    /// - Note: No constraints beyond those needed to fill the view are created. For instance, if a view should be
    /// filled with other views .topToBottom, no width or centering horizontally constraints will be created.
    @discardableResult func fill(_ fillMethod: FillMethod,
                                 withViews views: [UIView],
                                 withSpacing spacing: CGFloat,
                                 spacesInternally: Bool = true) -> [NSLayoutConstraint] {
        switch (fillMethod) {
        case .bottomToTop, .topToBottom:
            return fillVertically(fillMethod,
                                  withViews: views,
                                  withSpacing: spacing,
                                  spacesInternally: spacesInternally)
        case .leftToRight, .rightToLeft:
            return fillHorizontally(fillMethod,
                                    withViews: views,
                                    withSpacing: spacing,
                                    spacesInternally: spacesInternally)
        }
    }

    /// Creates, activates, and returns the constraints that are created to fill this view horizontally with the
    /// provided views with the given spacing.
    ///
    /// - Parameters:
    ///   - fillMethod: The method of filling horizontally. **Must be .leftToRight or .rightToLeft or a fatalError will
    /// occur. This is considered programmer error.**
    ///   - views: The views that should fill this view horizontally
    ///   - spacing: The amount of spacing between views
    ///   - spacesInternally: Determines if additional spacing is provided for the first view and last view with respect
    /// to this view.
    /// - Returns:  The constraints created to fill this view horizontally. These will be alternating sequences of
    /// `.left` and `.width` constraints for each view in the input variable `views`.
    ///
    /// If internal spacing is toggled off, there will not be additional spacing before the first view's left/right and
    /// the last view's right/left margins with respect to this view.
    @discardableResult private func fillHorizontally(_ fillMethod: FillMethod,
                                                     withViews views: [UIView],
                                                     withSpacing spacing: CGFloat,
                                                     spacesInternally: Bool = true) -> [NSLayoutConstraint] {
        guard fillMethod == .leftToRight || fillMethod == .rightToLeft else {
            fatalError("FillMethod for `fillHorizontally` call is expected to be of .leftToRight or .rightToLeft, but"
                + "was not. \(fillMethod.self)")
        }

        var constraints = [NSLayoutConstraint]()
        /* If spacesInternally == true, add 1 since we account for spacing before the first view
         and spacing after the last. If false, subtract 1 since there will be 1 less space */
        let widthOfSpacing = CGFloat(views.count + (spacesInternally ? 1 : -1)) * spacing
        var lastView = self

        for view in views {
            // Regarding the `withOffset(...)`: If the last view was this view and we're not spacing interally,
            // no spacing needed
            constraints.append(view.cling(fillMethod == .leftToRight ? .left : .right,
                                          to: lastView,
                                          lastView == self ?
                                            (fillMethod == .leftToRight ? .left : .right)
                                            : (fillMethod == .leftToRight ? .right : .left)
                ).withOffset((lastView == self && !spacesInternally) ? 0 : spacing))

            constraints.append(view.copy(.width, of: self)
                .withMultiplier(1 / CGFloat(views.count))
                .withOffset(-widthOfSpacing / CGFloat(views.count)))

            lastView = view
        }

        return constraints
    }

    /// Creates, activates, and returns the constraints that are created to fill this view vertically with the provided
    /// views with the given spacing.
    ///
    /// - Parameters:
    ///   - fillMethod: The method of filling vertically. **Must be .topToBottom or .bottomToTop or a fatalError
    /// will occur. This is considered programmer error.**
    ///   - views: The views that should fill this view vertically
    ///   - spacing: The amount of spacing between views
    ///   - spacesInternally: Determines if additional spacing is provided for the first view and last view with respect
    /// to this view.
    /// - Returns: The constraints created to fill this view vertically. These will be alternating sequences of `.top`
    /// and `.height` constraints for each view in the input variable `views`.
    ///
    /// If internal spacing is toggled off, there will not be additional spacing before the first view's top/bottom and
    /// the last view's bottom/top margins with respect to this view.
    @discardableResult private func fillVertically(_ fillMethod: FillMethod,
                                                   withViews views: [UIView],
                                                   withSpacing spacing: CGFloat,
                                                   spacesInternally: Bool = true) -> [NSLayoutConstraint] {
        guard fillMethod == .topToBottom || fillMethod == .bottomToTop else {
            fatalError("FillMethod for `fillHorizontally` call is expected to be of .leftToRight or .rightToLeft, but"
                + "was not. \(fillMethod.self)")
        }

        var constraints = [NSLayoutConstraint]()
        /* If spacesInternally == true, add 1 since we account for spacing before the first view
         and spacing after the last. If false, subtract 1 since there will be 1 less space */
        let heightOfSpacing = CGFloat(views.count + (spacesInternally ? 1 : -1)) * spacing
        var lastView = self

        for view in views {
            constraints.append(view.cling(fillMethod == .topToBottom ? .top : .bottom,
                                          to: lastView, lastView == self ?
                                            (fillMethod == .topToBottom ? .top : .bottom)
                                            : (fillMethod == .topToBottom ? .bottom : .top)
                ).withOffset((lastView == self && !spacesInternally) ? 0 : spacing))

            constraints.append(view.copy(.height, of: self)
                .withMultiplier(1 / CGFloat(views.count))
                .withOffset(-heightOfSpacing / CGFloat(views.count)))

            lastView = view
        }

        return constraints
    }

    /// Creates, activates, and returns a constraint that sets the height for the calling view to the specified height.
    ///
    /// - Parameter height: The height that the NSLayoutConstraint should specify for this view
    /// - Returns: The new, activated constraint
    @discardableResult func setHeight(_ height: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .height,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: height)
        constraint.isActive = true

        return constraint
    }

    /// Creates, activates, and returns a constraint that sets the width for the calling view to the specified width.
    ///
    /// - Parameter width: The width that the NSLayoutConstraint should specify for this view
    /// - Returns: The new, activated constraint
    @discardableResult func setWidth(_ width: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false

        let constraint = NSLayoutConstraint(item: self,
                                            attribute: .width,
                                            relatedBy: .equal,
                                            toItem: nil,
                                            attribute: .notAnAttribute,
                                            multiplier: 1,
                                            constant: width)
        constraint.isActive = true

        return constraint
    }
}
