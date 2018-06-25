//
//  UIViewExtensions.swift
//  ClingConstraintsDemo
//
//  Created by Christopher Perkins on 6/24/18.
//  Copyright © 2018 Christopher Perkins. All rights reserved.
//

import UIKit

public extension UIView {
    /**
     Creates, activates, and returns a list of NSLayoutConstraint that copies the specified
     viewToCopy's attributes.
     
     - Parameter attributes: The attributes that should be copied
     - Parameter viewToCopy: The view whose attributes should be copied from
     - Returns: A list of  NSLayoutConstraints that copy the specified viewToCopy's attributes
     */
    @discardableResult public func copy(_ attributes: NSLayoutAttribute...,
        of viewToCopy: UIView) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        return attributes.map {
            self.copy($0, of: viewToCopy)
        }
    }
    
    /**
     Creates, activates, and returns an NSLayoutConstraint that copies the specified viewToCopy's
     attribute.
     
     - Parameter attribute: The attribute that should be copied
     - Parameter viewToCopy: The view whose attribute should be copied from
     - Returns: An NSLayoutConstraint that copies the specified viewToCopy's attribute
     */
    @discardableResult public func copy(_ attribute: NSLayoutAttribute,
                                        of viewToCopy: UIView) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let copiedConstraint = NSLayoutConstraint(item: self, attribute: attribute,
                                                  relatedBy: .equal, toItem: viewToCopy,
                                                  attribute: attribute, multiplier: 1, constant: 0)
        copiedConstraint.isActive = true
        
        return copiedConstraint
    }
    
    /**
     Creates, activats, and returns a constraint that clings this view's specified attribute to the
     specified view's clingedAttribute.
     
     Example: ```cling(attribute: .left, toView: button, .right)``` would cling this view's
     left-side to the button's right-side.
     
     - Parameter clingerAttribute: The attribute that this view should cling from
     - Parameter clingedView: The view that should be clinged to
     - Parameter clingedAttribute: The attribute from the clingedView that this constraint should
     cling to
     - Returns: The constraint that was clinged to
    */
    @discardableResult public func cling(_ clingerAttribute: NSLayoutAttribute,
                                         to clingedView: UIView,
                                         _ clingedAttribute: NSLayoutAttribute) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let clingedConstraint = NSLayoutConstraint(item: self, attribute: clingerAttribute,
                                                   relatedBy: .equal, toItem: clingedView,
                                                   attribute: clingedAttribute, multiplier: 1,
                                                   constant: 0)
        clingedConstraint.isActive = true
        
        return clingedConstraint
    }
    
    /**
     Creates, activates, and returns the constraints that are created to fill this view horizontally
     with the provided views with the given spacing.
     
     If internal spacing is toggled on, there will be additional spacing before the first view's left
     and the last view's right margins with respect to this view.
     
     If internal spacing is toggled on, there will not be additional spacing before the first view's
     left and the last view's right margins with respect to this view.
     
     - Parameter views: The views that should fill this view horizontally
     - Parameter spacing: The amount of spacing between views
     - Parameter spacesInternally: Determines if additional spacing is provided for the first view
     and last view with respect to this view.
     - Returns: The constraints created to fill this view horizontally. These will be alternating
     sequences of `.left` and `.width` constraints for each view in the input variable `views`.
     */
    @discardableResult public func fillHorizontally(withViews views: [UIView],
                                                    withSpacing spacing: CGFloat,
                                                    spacesInternally: Bool = true)
        -> [NSLayoutConstraint] {
            var constraints = [NSLayoutConstraint]()
            /* If spacesInternally == true, add 1 since we account for spacing before the first view
             and spacing after the last. If false, subtract 1 since there will be 1 less space */
            let widthOfSpacing = CGFloat(views.count + (spacesInternally ? 1 : -1)) * spacing
            var lastView = self
            
            for view in views {
                constraints.append(view.cling(.left, to: lastView,
                                              lastView == self ? .left : .right)
                    /* If the last view was this view and we're not spacing interally, no spacing
                     needed. */
                    .withOffset((lastView == self && !spacesInternally) ? 0 : spacing))
                constraints.append(view.copy(.width, of: self)
                    .withMultiplier(1 / CGFloat(views.count))
                    .withOffset(-widthOfSpacing / CGFloat(views.count)))
                
                lastView = view
            }
            
            return constraints
    }
    
    /**
     Creates, activates, and returns the constraints that are created to fill this view vertically
     with the provided views with the given spacing.
     
     If internal spacing is toggled on, there will be additional spacing before the first view's top
     and the last view's bottom margins with respect to this view.
     
     If internal spacing is toggled on, there will not be additional spacing before the first view's
     top and the last view's bottom margins with respect to this view.
     
     - Parameter views: The views that should fill this view vertically
     - Parameter spacing: The amount of spacing between views
     - Parameter spacesInternally: Determines if additional spacing is provided for the first view
     and last view with respect to this view.
     - Returns: The constraints created to fill this view vertically. These will be alternating
     sequences of `.top` and `.height` constraints for each view in the input variable `views`.
    */
    @discardableResult public func fillVertically(withViews views: [UIView],
                                                  withSpacing spacing: CGFloat,
                                                  spacesInternally: Bool = true)
        -> [NSLayoutConstraint] {
            var constraints = [NSLayoutConstraint]()
            /* If spacesInternally == true, add 1 since we account for spacing before the first view
                and spacing after the last. If false, subtract 1 since there will be 1 less space */
            let heightOfSpacing = CGFloat(views.count + (spacesInternally ? 1 : -1)) * spacing
            var lastView = self
            
            for view in views {
                constraints.append(view.cling(.top, to: lastView, lastView == self ? .top : .bottom)
                    /* If the last view was this view and we're not spacing interally, no spacing
                        needed. */
                    .withOffset((lastView == self && !spacesInternally) ? 0 : spacing))
                constraints.append(view.copy(.height, of: self)
                    .withMultiplier(1 / CGFloat(views.count))
                    .withOffset(-heightOfSpacing / CGFloat(views.count)))
                
                lastView = view
            }
            
            return constraints
    }
    
    /**
     Creates, activates, and returns a constraint that sets the height for the calling view to the
     specified height.
     
     - Parameter height: The height that the NSLayoutConstraint should specify for this view
    */
    @discardableResult public func setHeight(_ height: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal,
                                            toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                            constant: height)
        constraint.isActive = true
        
        return constraint
    }
    
    /**
     Creates, activates, and returns a constraint that sets the width for the calling view to the
     specified width.
     
     - Parameter width: The width that the NSLayoutConstraint should specify for this view
     */
    @discardableResult public func setWidth(_ width: CGFloat) -> NSLayoutConstraint {
        translatesAutoresizingMaskIntoConstraints = false
        
        let constraint = NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal,
                                            toItem: nil, attribute: .notAnAttribute, multiplier: 1,
                                            constant: width)
        constraint.isActive = true
        
        return constraint
    }
}
