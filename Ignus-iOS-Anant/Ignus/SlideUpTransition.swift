//
//  SlideUpTransition.swift
//  Ignus
//
//  Created by Anant Jain on 2/8/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class SlideUpTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting = true
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var fromVC = transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!
        var toVC = transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!
        var container = transitionContext.containerView()
        
        toVC.view.layer.cornerRadius = 5
        toVC.view.layer.masksToBounds = true
        
        if self.presenting {
            toVC.view.frame.origin.x += 20
            toVC.view.frame.origin.y += 20
            toVC.view.frame.size.width -= 40
            toVC.view.frame.size.height -= 40
            
            var shadowView = UIView(frame: UIScreen.mainScreen().bounds)
            shadowView.backgroundColor = UIColor.blackColor()
            shadowView.alpha = 0.0
            
            container.addSubview(shadowView)
            container.addSubview(toVC.view)
            
            toVC.view.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.size.height - toVC.view.frame.origin.y)
            
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                shadowView.alpha = 0.5
                toVC.view.transform = CGAffineTransformIdentity
                }, completion: { (completed: Bool) -> Void in
                    transitionContext.completeTransition(true)
            })
        }
        else {
            UIView.animateWithDuration(0.5, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                fromVC.view.transform = CGAffineTransformMakeTranslation(0, UIScreen.mainScreen().bounds.size.height - toVC.view.frame.origin.y)
                }, completion: { (completed: Bool) -> Void in
                    toVC.viewDidAppear(true)
                    transitionContext.completeTransition(true)
            })
        }
    }
}
