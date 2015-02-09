//
//  LoginTransition.swift
//  Animation
//
//  Created by Anant Jain on 1/30/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class LoginTransition: NSObject, UIViewControllerAnimatedTransitioning {
    
    var presenting: Bool
    
    init(presenting: Bool) {
        self.presenting = presenting
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return 0.5
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        var fromVC = transitionContext.viewForKey(UITransitionContextFromViewKey)!
        var toVC = transitionContext.viewForKey(UITransitionContextToViewKey)!
        var container = transitionContext.containerView()
        
        var darkView = UIView(frame: container.frame)
        darkView.backgroundColor = UIColor.blackColor()
        
        if presenting {
            
            darkView.alpha = 0.5
            
            container.addSubview(toVC)
            container.addSubview(darkView)
            container.addSubview(fromVC)
            
            toVC.transform = CGAffineTransformMakeScale(0.9, 0.9)
            
            UIView.animateWithDuration(0.35, delay: 0, options: .CurveEaseOut, animations: { () -> Void in
                fromVC.transform = CGAffineTransformMakeTranslation(0, container.frame.size.height)
            }, completion: nil)
            
            UIView.animateWithDuration(0.3, delay: 0.30, options: .CurveEaseIn, animations: { () -> Void in
                darkView.alpha = 0.0
                toVC.transform = CGAffineTransformIdentity
                }, completion: { (completed: Bool) -> Void in
                    fromVC.removeFromSuperview()
                    fromVC.transform = CGAffineTransformIdentity
                    transitionContext.completeTransition(true)
            })
        
        }
        else {
            container.addSubview(fromVC)
            container.addSubview(darkView)
            container.addSubview(toVC)
            
            darkView.alpha = 0.0
            
            toVC.transform = CGAffineTransformMakeTranslation(0, container.frame.size.height)
            
            UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseIn, animations: { () -> Void in
                fromVC.transform = CGAffineTransformMakeScale(0.9, 0.9)
                darkView.alpha = 0.5
            }, completion: nil)
            
            UIView.animateWithDuration(0.3, delay: 0.25, options: .CurveEaseOut, animations: { () -> Void in
                toVC.transform = CGAffineTransformIdentity
                }, completion: { (completed: Bool) -> Void in
                    transitionContext.completeTransition(true)
            })
            
            
        }
    }
}
