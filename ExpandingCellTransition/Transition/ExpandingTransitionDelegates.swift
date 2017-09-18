//
//  ExpandingTransitionDelegates.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-17.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

@objc public protocol ExpandingTransitionSourceDelegate: NSObjectProtocol {

    func transitionDuration() -> TimeInterval
    func transitionSourceImageView() -> UIImageView
    func transitionSourceImageViewFrame(forward: Bool) -> CGRect
    
    func transitionTopSection() -> UIImageView?
    func transitionBottomSection() -> UIImageView?
    func transitionMiddleSection() -> UIImageView?

    @objc optional func transitionSourceWillBegin()
    @objc optional func transitionSourceDidEnd()
    @objc optional func transitionSourceDidCancel()
}

@objc public protocol ExpandingTransitionDestinationDelegate: NSObjectProtocol {
    func transitionDuration() -> TimeInterval
    func transitionDestinationImageViewFrame(forward: Bool) -> CGRect
    
    @objc optional func transitionDestinationWillBegin()
    @objc optional func transitionDestinationDidEnd()
    @objc optional func transitionDestinationDidCancel()
}
