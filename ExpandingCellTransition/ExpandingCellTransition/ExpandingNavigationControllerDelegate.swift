//
//  ExpandingNavigationControllerDelegate.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-17.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

public final class ExpandingNavigationControllerDelegate: NSObject, UINavigationControllerDelegate {

    fileprivate var transition:ExpandingCellTransition?
    
    var isExpandingTransitionEnabled = true
    
    public func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        
        if transition == nil {
            if let source = fromVC as? ExpandingTransitionSourceDelegate, let destination = toVC as? ExpandingTransitionDestinationDelegate, operation == .push {
                transition = ExpandingCellTransition(source: source, destination: destination, forward: operation == .push )
            } else if let source = toVC as? ExpandingTransitionSourceDelegate, let destination = fromVC as? ExpandingTransitionDestinationDelegate, operation == .pop {
                transition = ExpandingCellTransition(source: source, destination: destination, forward: false)
            }
            
        } else {
            if let source = fromVC as? ExpandingTransitionSourceDelegate, let destination = toVC as? ExpandingTransitionDestinationDelegate, operation == .push {
                transition?.forward = true
                transition?.source = source
                transition?.destination = destination
            } else if let source = toVC as? ExpandingTransitionSourceDelegate, let destination = fromVC as? ExpandingTransitionDestinationDelegate, operation == .pop {
                transition?.forward = false
                transition?.source = source
                transition?.destination = destination
            }
        }
        
        return isExpandingTransitionEnabled ? transition : nil
    }
}


