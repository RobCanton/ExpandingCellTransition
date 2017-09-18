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
See the demo project for example implementations of each method.

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

```swift
func transitionDuration() -> TimeInterval // Duration of the push transition
func transitionSourceImageView() -> UIImageView // The imageView in the selected cell
func transitionSourceImageViewFrame(forward: Bool) -> CGRect // The frame of the imageView in the selected cell

func transitionTopSection() -> UIImageView? // A snapshot of the area above the selected cell
func transitionBottomSection() -> UIImageView? // A snapshot of the area below the selected cell
func transitionMiddleSection() -> UIImageView? // A snapshot of the title area below the imageView in the cell

func transitionSourceEvent(event: ExpandingCellTransitionEvent) -> Void // Called when the transiton begins, ends, and is cancelled
```

### Setup the Destination View Controller

**Implement the destination delegate methods**

```swift
func transitionDuration() -> TimeInterval // Duration of the pop transition
func transitionDestinationImageViewFrame(forward: Bool) -> CGRect // The imageView in the header
func transitionDestinationEvent(event: ExpandingCellTransitionEvent) -> Void // Called when the transiton begins, ends, and is cancelled
```
