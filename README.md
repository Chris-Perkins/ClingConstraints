# ClingConstraints

Yet another programmatic constraints library for iOS. The focus of ClingConstraints is to have clean, readable, and powerful constraint creation.

This was mainly created for my own use; feel free to use it how you want if you somehow stumbled here.

## Example Code

##### Copy another View's Attribute
```Swift
// This creates and activates a constraint that makes thisView's height equal to that view
thisView.copy(.height, of: thatView)
```

##### Copying Constraints with Personal Space
```Swift
// thisView copies thatView's height * 0.5 - 30.
thisView.copy(.height, of: thatView).withOffset(-30).withMultiplier(0.5)
```

##### Copying Multiple Constraints In-Line
```Swift
// thisView copies the right, top, and left anchor constraints of that view-- in one line.
thisView.copy(.right, .top, .left of: thatView)
```

##### Clinging Constraints Together
```Swift
// thisView positions itself to the right of thatView with a spacing of 5
thisView.cling(.left to: thatView, .right).withOffset(5)
```

#### What's in the box?

##### Constraint Creation:
On any UIView, you can call the following functions.

Note that these all return the created constraint. If multiple constraints are created, a list of constraints are returned.
```Swift
// This view copies the other view's attributes (returns list of created constraints)
copy(_ attributes: NSLayoutAttribute..., of: UIView)

// This view copies the other view's attribute
copy(_: NSLayoutAttribute, of: UIView)

// Clings the calling view's attribute to the other view's attribute.
cling(_: NSLayoutAttribute, to: UIView, _: NSLayoutAttribute)

// Fills the calling view left-right with the given views with the provided spacing.
// Provides inset setting if spacesInternally is enabled.
fillHorizontally(withViews: [UIView], withSpacing: CGFloat, spacesInternally: Bool = true)

// Fills the calling view top-down with the given views with the provided spacing.
// Provides inset setting if spacesInternally is enabled.
fillVertically(withViews: [UIView], withSpacing spacing: CGFloat, spacesInternally: Bool = true)

// Sets the height for this view
setHeight(_: CGFloat)

// Sets the width for this view
setWidth(_: CGFloat)
```


##### Constraint Property Chaining:
On any NSLayoutConstraint:
```Swift
withMultiplier(_: CGFloat)
withOffset(_: CGFloat)
withPriority(_: UILayoutPriority)
withRelation(_: NSLayoutRelation)
```

#### For constraint activation and deactivation:
In any collection of constraints:
```Swift
activateAllConstraints()
deactivateAllConstraints()
```

## Documentation

Read the [docs](https://htmlpreview.github.io/?https://raw.githubusercontent.com/Chris-Perkins/ClingConstraints/master/docs/index.html)

## Author

chris@chrisperkins.me

No license; do whatever
