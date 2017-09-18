//
//  ExpandingCellTransition.swift
//  ExpandingCellTransition
//
//  Created by Robert Canton on 2017-09-17.
//  Copyright © 2017 Robert Canton. All rights reserved.
//

import UIKit

public final class ExpandingCellTransition: NSObject {
    
    var source: ExpandingTransitionSourceDelegate
    var destination: ExpandingTransitionDestinationDelegate
    var forward: Bool
    
    var topSection:UIImageView?
    var midSection:UIImageView?
    var botSection:UIImageView?
    
    required public init(source: ExpandingTransitionSourceDelegate, destination: ExpandingTransitionDestinationDelegate, forward: Bool) {
        self.source = source
        self.destination = destination
        self.forward = forward

        super.init()
    }
}



extension ExpandingCellTransition: UIViewControllerAnimatedTransitioning {

    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        if forward {
            return source.transitionDuration()
        } else {
            return destination.transitionDuration()
        }
    }

    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        if forward {
            animateTransitionForPush(transitionContext)
        } else {
            animateTransitionForPop(transitionContext)
        }
    }

    private func animateTransitionForPush(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.from),
            let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.to) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }

        let containerView = transitionContext.containerView
        let transitionDuration = destination.transitionDuration()
        let transitioningImageView = transitioningPushImageView()
        
        topSection = source.transitionTopSection()

        topSection?.frame = CGRect(x: 0, y: 0, width: topSection!.frame.width, height: topSection!.frame.height)
        
        botSection = source.transitionBottomSection()
        botSection?.frame = CGRect(x: 0, y: sourceView.frame.height - botSection!.frame.height, width: botSection!.frame.width, height: botSection!.frame.height)
        
        midSection = source.transitionMiddleSection()
        midSection?.frame = CGRect(x: 0, y: midSection!.frame.origin.y, width: midSection!.frame.width, height: midSection!.frame.height)

        containerView.backgroundColor = UIColor.white
        sourceView.alpha = 0.0
        destinationView.alpha = 0.0

        containerView.insertSubview(destinationView, belowSubview: sourceView)
       
        // Add top section if it exists
        if topSection != nil {
            containerView.addSubview(topSection!)
        }
        
        // Add bottom section if it exists
        if botSection != nil {
           containerView.addSubview(botSection!)
        }
        
        // Add middle section if it exists
        if midSection != nil {
            containerView.addSubview(midSection!)
        }
        
        
        containerView.addSubview(transitioningImageView)

        
        destinationView.frame = CGRect(x: 0, y: transitioningImageView.frame.origin.y, width: destinationView.frame.width, height: destinationView.frame.height)
        
        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()
        
        UIView.animate(
            withDuration: transitionDuration/2,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                self.midSection?.alpha = 0.0
        })
        
        UIView.animate(
            withDuration: transitionDuration/2,
            delay: transitionDuration/2,
            options: .curveEaseOut,
            animations: {
                destinationView.alpha = 1.0
        })
        
        let endCellFrame = self.destination.transitionDestinationImageViewFrame(forward: self.forward)
        
        if #available(iOS 10.0, *) {

            let cubicTimingParameters = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.25, y: 0.1), controlPoint2: CGPoint(x: 0.25, y: 1))
            
            
            let animator = UIViewPropertyAnimator(duration: transitionDuration, timingParameters: cubicTimingParameters)
            animator.addAnimations {
                self.topSection?.frame = CGRect(x: 0,
                                                y: -self.topSection!.frame.height,
                                                width: self.topSection!.frame.width,
                                                height: self.topSection!.frame.height)
                self.botSection?.frame = CGRect(x: 0,
                                        y: sourceView.frame.height + self.botSection!.frame.height,
                                        width: self.botSection!.frame.width,
                                        height: self.botSection!.frame.height)
                
                sourceView.alpha = 0.0
                destinationView.frame = CGRect(x: 0, y: 0, width: destinationView.frame.width, height: destinationView.frame.height)
                transitioningImageView.frame = endCellFrame
                self.midSection?.frame = CGRect(x: 0,
                                                y: endCellFrame.origin.y + endCellFrame.height,
                                                width: self.midSection!.frame.width,
                                                height: self.midSection!.frame.height)
            }
            
            animator.addCompletion({ _ in
                self.topSection?.removeFromSuperview()
                self.botSection?.removeFromSuperview()
                self.midSection?.removeFromSuperview()
                sourceView.alpha = 1.0
                transitioningImageView.alpha = 0.0
                transitioningImageView.removeFromSuperview()
                
                self.source.transitionSourceDidEnd?()
                self.destination.transitionDestinationDidEnd?()

                transitionContext.completeTransition(true)
            })
            
            animator.startAnimation()
            
        } else {
            // Fallback on earlier versions
            UIView.animate(
                withDuration: transitionDuration,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
                    self.topSection?.frame = CGRect(x: 0,
                                                    y: -self.topSection!.frame.height,
                                                    width: self.topSection!.frame.width,
                                                    height: self.topSection!.frame.height)
                    self.botSection?.frame = CGRect(x: 0,
                                            y: sourceView.frame.height + self.botSection!.frame.height,
                                            width: self.botSection!.frame.width,
                                            height: self.botSection!.frame.height)
                    
                    sourceView.alpha = 0.0
                    destinationView.frame = CGRect(x: 0, y: 0, width: destinationView.frame.width, height: destinationView.frame.height)
                    transitioningImageView.frame = endCellFrame
                    self.midSection?.frame = CGRect(x: 0,
                                                    y: endCellFrame.origin.y + endCellFrame.height,
                                                    width: self.midSection!.frame.width,
                                                    height: self.midSection!.frame.height)
            },
                completion: { _ in
                    self.topSection?.removeFromSuperview()
                    self.botSection?.removeFromSuperview()
                    self.midSection?.removeFromSuperview()
                    sourceView.alpha = 1.0
                    transitioningImageView.alpha = 0.0
                    transitioningImageView.removeFromSuperview()
                    
                    self.source.transitionSourceDidEnd?()
                    self.destination.transitionDestinationDidEnd?()
                    
                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    private func animateTransitionForPop(_ transitionContext: UIViewControllerContextTransitioning) {
        guard let sourceView = transitionContext.view(forKey: UITransitionContextViewKey.to),
            let destinationView = transitionContext.view(forKey: UITransitionContextViewKey.from) else {
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
                return
        }

        let containerView = transitionContext.containerView
        let transitionDuration = destination.transitionDuration()
        let pushImageView = transitioningPushImageView()
        let transitioningImageView = transitioningPopImageView()
        
        containerView.backgroundColor = UIColor.white//destinationView.backgroundColor
        destinationView.alpha = 1.0
        sourceView.alpha = 0.0
        
        // Set the initial position of the top section off-screen
        self.topSection?.alpha = 0.0
        self.topSection?.frame = CGRect(x: 0,
                                        y: -self.topSection!.frame.height,
                                        width: self.topSection!.frame.width,
                                        height: self.topSection!.frame.height)
        
        containerView.insertSubview(sourceView, belowSubview: destinationView)
        
        // Set the initial position of the bottom section off-screen
        self.botSection?.alpha = 0.0
        self.botSection?.frame = CGRect(x: 0,
                                y: sourceView.frame.height + self.botSection!.frame.height,
                                width: self.botSection!.frame.width,
                                height: self.botSection!.frame.height)
        
        
        let startCellFrame = self.destination.transitionDestinationImageViewFrame(forward: self.forward)
        self.midSection?.frame = CGRect(x: 0,
                                        y: startCellFrame.origin.y + startCellFrame.height + 20,
                                        width: self.midSection!.frame.width,
                                        height: self.midSection!.frame.height)
        self.midSection?.alpha = 0.0
        containerView.addSubview(transitioningImageView)
        
        // Add top section if it exists
        if self.topSection != nil {
            containerView.addSubview(self.topSection!)
        }
        
        // Add bottom section if it exists
        if self.botSection != nil {
            containerView.addSubview(self.botSection!)
        }
        
        // Add middle section if it exists
        if midSection != nil {
            containerView.addSubview(midSection!)
        }
        
        source.transitionSourceWillBegin?()
        destination.transitionDestinationWillBegin?()

        if transitioningImageView.frame.maxY < 0.0 {
            transitioningImageView.frame.origin.y = -transitioningImageView.frame.height
        }
        
        UIView.animate(
            withDuration: transitionDuration/2,
            delay: 0.0,
            options: .curveEaseOut,
            animations: {
                destinationView.alpha = 0.0
        })
        
        UIView.animate(
            withDuration: transitionDuration/2,
            delay: transitionDuration/2,
            options: .curveEaseOut,
            animations: {
                self.midSection?.alpha = 1.0
        })
        
        let endCellFrame = self.source.transitionSourceImageViewFrame(forward: self.forward)
        
        if #available(iOS 10.0, *) {
            
            let cubicTimingParameters = UICubicTimingParameters(controlPoint1: CGPoint(x: 0.25, y: 0.1), controlPoint2: CGPoint(x: 0.25, y: 1))

            let animator = UIViewPropertyAnimator(duration: transitionDuration, timingParameters: cubicTimingParameters)
            animator.addAnimations {
                self.topSection?.alpha = 1.0
                self.botSection?.alpha = 1.0
                self.topSection?.frame = CGRect(x: 0,
                                                y: 0,
                                                width: self.topSection!.frame.width,
                                                height: self.topSection!.frame.height)
                self.botSection?.frame = CGRect(x: 0,
                                                y: sourceView.frame.height - self.botSection!.frame.height,
                                                width: self.botSection!.frame.width,
                                                height: self.botSection!.frame.height)
                self.midSection?.frame = CGRect(x: 0,
                                                y: endCellFrame.origin.y + endCellFrame.height,
                                                width: self.midSection!.frame.width,
                                                height: self.midSection!.frame.height)
                
                destinationView.frame = CGRect(x: 0, y: pushImageView.frame.origin.y + pushImageView.frame.height - transitioningImageView.frame.height, width: destinationView.frame.width, height: destinationView.frame.height)
                transitioningImageView.frame = endCellFrame
            }
            
            animator.addCompletion({ _ in
                self.topSection?.removeFromSuperview()
                self.botSection?.removeFromSuperview()
                self.midSection?.removeFromSuperview()
                self.cleanUp()
                destinationView.alpha = 1.0
                sourceView.alpha = 1.0
                transitioningImageView.removeFromSuperview()
                
                self.source.transitionSourceDidEnd?()
                self.destination.transitionDestinationDidEnd?()

                transitionContext.completeTransition(true)
            })
            
            animator.startAnimation()
            
        } else {
            UIView.animate(
                withDuration: transitionDuration,
                delay: 0.0,
                options: .curveEaseOut,
                animations: {
                    self.topSection?.alpha = 1.0
                    self.botSection?.alpha = 1.0
                    self.topSection?.frame = CGRect(x: 0,
                                                    y: 0,
                                                    width: self.topSection!.frame.width,
                                                    height: self.topSection!.frame.height)
                    self.botSection?.frame = CGRect(x: 0,
                                                    y: sourceView.frame.height - self.botSection!.frame.height,
                                                    width: self.botSection!.frame.width,
                                                    height: self.botSection!.frame.height)
                    self.midSection?.frame = CGRect(x: 0,
                                                    y: endCellFrame.origin.y + endCellFrame.height,
                                                    width: self.midSection!.frame.width,
                                                    height: self.midSection!.frame.height)
                    
                    destinationView.frame = CGRect(x: 0, y: pushImageView.frame.origin.y + pushImageView.frame.height - transitioningImageView.frame.height, width: destinationView.frame.width, height: destinationView.frame.height)
                    transitioningImageView.frame = endCellFrame
                },
                completion: { _ in
                    self.topSection?.removeFromSuperview()
                    self.botSection?.removeFromSuperview()
                    self.midSection?.removeFromSuperview()
                    self.cleanUp()
                    
                    destinationView.alpha = 1.0
                    sourceView.alpha = 1.0
                    transitioningImageView.removeFromSuperview()
                    
                    self.source.transitionSourceDidEnd?()
                    self.destination.transitionDestinationDidEnd?()

                    transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            })
        }
    }

    private func transitioningPushImageView() -> UIImageView {
        let imageView = source.transitionSourceImageView()
        let frame = source.transitionSourceImageViewFrame(forward: forward)
        return UIImageView(baseImageView: imageView, frame: frame)
    }

    private func transitioningPopImageView() -> UIImageView {
        let imageView = source.transitionSourceImageView()
        let frame = destination.transitionDestinationImageViewFrame(forward: forward)
        return UIImageView(baseImageView: imageView, frame: frame)
    }
    
    func cleanUp() {
        topSection = nil
        midSection = nil
        botSection = nil
    }
}

