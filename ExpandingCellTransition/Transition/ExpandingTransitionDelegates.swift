//
//  ExpandingTransitionDelegates.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-17.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

public protocol ExpandingTransitionSourceDelegate: NSObjectProtocol {

    func transitionDuration() -> TimeInterval
    func transitionSourceImageView() -> UIImageView
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect
    
    func transitionTopSection() -> UIImageView?
    func transitionBottomSection() -> UIImageView?
    func transitionMiddleSection() -> UIImageView?
    
    func transitionSourceEvent(event: ExpandingCellTransitionEvent) ->Void
}

public protocol ExpandingTransitionDestinationDelegate: NSObjectProtocol {
    func transitionDuration() -> TimeInterval
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect
    func transitionDestinationEvent(event: ExpandingCellTransitionEvent) -> Void

}
