# Expanding Cell Transition (Swift)

A custom transition animation where the selected image cell expands into the detail view, and the top and bottom sections of the screen expand outwards. Similar to the animation used in the [Airbnb app](https://itunes.apple.com/ca/app/airbnb/id401626263?mt=8).

![Alt Text](https://github.com/RobCanton/ExpandingCellTransition/blob/master/Misc/recording1.gif)

## Getting Started

### Install
1. Manual
Copy the files in the 'Transition' folder into your project
  * ExpandingNavigationControllerDelegate.swift
  * ExpandingCellTransition.swift
  * ExpandingTransitionDelegates
  * Extensions.swift
  
 2. Cocoapods (Coming Soon)

  
### Setup the Source View Controller
See the demo project for example implementations of each method.

**Add these properties**
```swift
 var transitionDelegate = ExpandingNavigationControllerDelegate()
 var selectedIndex:IndexPath!
```

**Set the navigation controller delegate**
```swift
navigationController?.delegate = transitionDelegate
```

**Implement the delegate methods**

```swift
func transitionDuration() -> TimeInterval
func transitionSourceImageView() -> UIImageView
func transitionSourceImageViewFrame(forward: Bool) -> CGRect

func transitionTopSection() -> UIImageView?
func transitionBottomSection() -> UIImageView?
func transitionMiddleSection() -> UIImageView?

func transitionSourceEvent(event: ExpandingCellTransitionEvent) -> Void
```

### Setup the Destination View Controller

**Implement the delegate methods**

```swift
func transitionDuration() -> TimeInterval
func transitionDestinationImageViewFrame(forward: Bool) -> CGRect
func transitionDestinationEvent(event: ExpandingCellTransitionEvent) -> Void
```
