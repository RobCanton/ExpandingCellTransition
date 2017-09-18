# Expanding Cell Transition

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
  
### Setup the Transition

**Preferred:**
```swift
 var transitionDelegate = ExpandingNavigationControllerDelegate()
 var selectedIndex:IndexPath!
```
