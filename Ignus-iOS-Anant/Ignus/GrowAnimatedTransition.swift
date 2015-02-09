//
//  GrowAnimatedTransition.swift
//  Usef
//
//  Created by Anant Jain on 12/26/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

class GrowAnimatedTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    var sourceButtonFrame: CGRect
    
    init(presenting: Bool, sourceButtonFrame: CGRect) {
        self.presenting = presenting
        self.sourceButtonFrame = sourceButtonFrame
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return self.presenting ? 0.5 : 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var containerView = transitionContext.containerView()
        
        var screenSize = UIScreen.mainScreen().bounds
        
        fromVC.view.userInteractionEnabled = false
        
        if (self.presenting) {
            toVC.view.alpha = 0.0
            
            toVC.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(sourceButtonFrame.size.width / screenSize.size.width, sourceButtonFrame.size.height / screenSize.size.height), CGAffineTransformMakeTranslation(CGRectGetMidX(sourceButtonFrame) - CGRectGetMidX(toVC.view.frame), CGRectGetMidY(sourceButtonFrame) - CGRectGetMidY(toVC.view.frame)))
            
            containerView.addSubview(toVC.view)
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 20, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                toVC.view.transform = CGAffineTransformIdentity
                toVC.view.alpha = 1.0
                }, completion: { (completed: Bool) -> Void in
                transitionContext.completeTransition(true)
            })
        }
        else {
            fromVC.view.userInteractionEnabled = false
            
            UIView.animateWithDuration(transitionDuration(transitionContext), delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                fromVC.view.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(self.sourceButtonFrame.size.width / screenSize.size.width, self.sourceButtonFrame.size.height / screenSize.size.height), CGAffineTransformMakeTranslation(CGRectGetMidX(self.sourceButtonFrame) - CGRectGetMidX(fromVC.view.frame), CGRectGetMidY(self.sourceButtonFrame) - CGRectGetMidY(fromVC.view.frame)))
                fromVC.view.alpha = 0.0
                }, completion: { (completed: Bool) -> Void in
                    toVC.view.userInteractionEnabled = true
                    transitionContext.completeTransition(true)
            })
        }
    }
   
}