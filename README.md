# Expanding Cell Transition (Swift)

A custom transition animation where the selected image cell expands into the detail view, and the top and bottom sections of the screen expand outwards. Similar to the animation used in the [Airbnb app](https://itunes.apple.com/ca/app/airbnb/id401626263?mt=8).

![Alt Text](https://github.com/RobCanton/ExpandingCellTransition/blob/master/Misc/recording1.gif)

## Getting Started

### Install
Copy the files in the 'Transition' folder into your project
  * ExpandingNavigationControllerDelegate.swift
  * ExpandingCellTransition.swift
  * ExpandingTransitionDelegates
  * Extensions.swift
  
  
### Setup the Source View Controller

**Add these properties**
```swift
 var transitionDelegate = ExpandingNavigationControllerDelegate()
 var selectedIndex:IndexPath!
```

**Set the navigation controller delegate**
```swift
override func viewDidLoad() {
	super.viewDidLoad()
	...
	navigationController?.delegate = transitionDelegate
}
```

**Implement the source delegate methods**

See the demo project for example implementations of each method.

```swift
// Duration of the push transition
func transitionDuration() -> TimeInterval

// The imageView in the selected cell
func transitionSourceImageView() -> UIImageView

// The frame of the imageView in the selected cell
func transitionSourceImageViewFrame(forward: Bool) -> CGRect

// A snapshot of the area above the selected cell
func transitionTopSection() -> UIImageView?

// A snapshot of the area below the selected cell
func transitionBottomSection() -> UIImageView?

// A snapshot of the title area below the imageView in the cell
func transitionMiddleSection() -> UIImageView?

// Called when the transiton begins, ends, and is cancelled
func transitionSourceEvent(event: ExpandingCellTransitionEvent) -> Void
```

### Setup the Destination View Controller

**Implement the destination delegate methods**

See the demo project for example implementations of each method.

```swift
// Duration of the pop transition
func transitionDuration() -> TimeInterval

// The frame of the imageView in the header
func transitionDestinationImageViewFrame(forward: Bool) -> CGRect

// Called when the transiton begins, ends, and is cancelled
func transitionDestinationEvent(event: ExpandingCellTransitionEvent) -> Void
```
