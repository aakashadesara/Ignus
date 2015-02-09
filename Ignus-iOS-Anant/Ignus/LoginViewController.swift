//
//  LoginViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/7/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController, UITextFieldDelegate, UIViewControllerTransitioningDelegate, CreateAccountViewControllerDelegate {

    @IBOutlet weak var backgroundImageView: UIImageView!
    
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var launchBackgroundImageView: UIImageView!
    @IBOutlet weak var logoLine: UIView!
    @IBOutlet weak var logoTextView: UILabel!
    @IBOutlet weak var loginLoadingCircle: UIImageView!
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var usernameTextFieldBox: UIView!
    @IBOutlet weak var passwordTextFieldBox: UIView!
    
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    var didAnimateEntrance = false
    
    var seguePresenting = String()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Enlarges and centers logo
        if (!didAnimateEntrance) {
            logoImageView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(2.15517241, 2.15517241), CGAffineTransformMakeTranslation(0, self.view.center.y - logoImageView.center.y))
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if (!didAnimateEntrance) {
            UIView.animateWithDuration(0.75, delay: 0.25, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.logoImageView.transform = CGAffineTransformIdentity
                self.launchBackgroundImageView.alpha = 0
                }) { (finished: Bool) -> Void in
                    self.launchBackgroundImageView.hidden = true
                    self.didAnimateEntrance = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Sets the placeholder text in the text boxes to white color
        usernameTextField.attributedPlaceholder = NSAttributedString(string: usernameTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: passwordTextField.placeholder!, attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        
        // Creates animation for background
        var animationImages : [UIImage] = Array()
        
        for i in 1...23 {
            animationImages.append(UIImage(named: String(format: "%d", i))!)
        }
        
        backgroundImageView.animationImages = animationImages
        backgroundImageView.animationDuration = 2.0
        
        backgroundImageView.startAnimating()
        
        // Adds parallax effect
        var parallaxX = UIInterpolatingMotionEffect(keyPath: "center.x", type: UIInterpolatingMotionEffectType.TiltAlongHorizontalAxis)
        var parallaxY = UIInterpolatingMotionEffect(keyPath: "center.y", type: UIInterpolatingMotionEffectType.TiltAlongVerticalAxis)
        
        parallaxX.minimumRelativeValue = -15
        parallaxX.maximumRelativeValue = 15
        
        parallaxY.minimumRelativeValue = -15
        parallaxY.maximumRelativeValue = 15
        
        var group = UIMotionEffectGroup()
        group.motionEffects = [parallaxX, parallaxY]
        
        logoImageView.addMotionEffect(group)
        logoLine.addMotionEffect(group)
        logoTextView.addMotionEffect(group)
        usernameTextFieldBox.addMotionEffect(group)
        passwordTextFieldBox.addMotionEffect(group)
        logInButton.addMotionEffect(group)
        createAccountButton.addMotionEffect(group)
        
        var currentUser = PFUser.currentUser()
        if currentUser != nil {
            var contex = LAContext()
            var aError: NSError?
            if (contex.canEvaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, error: &aError)) {
                contex.evaluatePolicy(LAPolicy.DeviceOwnerAuthenticationWithBiometrics, localizedReason: "Authentication is needed to log in.", reply: { (success: Bool, error: NSError?) -> Void in
                    if success {
                        self.logIn()
                    }
                })
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField === usernameTextField {
            usernameTextField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        }
        else if textField === passwordTextField {
            passwordTextField.resignFirstResponder()
        }
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        if textField === usernameTextField {
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 25, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.usernameTextFieldBox.transform = CGAffineTransformMakeTranslation(0, 150 - self.usernameTextFieldBox.center.y)
                }, completion: nil)
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.logoImageView.alpha = 0
                self.logoLine.alpha = 0
                self.logoTextView.alpha = 0
                
                self.passwordTextFieldBox.alpha = 0
                
                self.logInButton.alpha = 0
                self.createAccountButton.alpha = 0
            })
            
        }
        else if textField === passwordTextField {
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 25, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.passwordTextFieldBox.transform = CGAffineTransformMakeTranslation(0, 150 - self.passwordTextFieldBox.center.y)
                }, completion: nil)
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.logoImageView.alpha = 0
                self.logoLine.alpha = 0
                self.logoTextView.alpha = 0
                
                self.usernameTextFieldBox.alpha = 0
                
                self.logInButton.alpha = 0
                self.createAccountButton.alpha = 0
            })
            
        }
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        
        if textField === usernameTextField {
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 25, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.usernameTextFieldBox.transform = CGAffineTransformIdentity
                }, completion: nil)
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.logoImageView.alpha = 1
                self.logoLine.alpha = 1
                self.logoTextView.alpha = 1
                
                self.passwordTextFieldBox.alpha = 1
                
                self.logInButton.alpha = 1
                self.createAccountButton.alpha = 1
            })
            
        }
        else if textField === passwordTextField {
            
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 10, initialSpringVelocity: 25, options: UIViewAnimationOptions.CurveLinear, animations: { () -> Void in
                self.passwordTextFieldBox.transform = CGAffineTransformIdentity
                }, completion: nil)
            
            UIView.animateWithDuration(0.25, animations: { () -> Void in
                self.logoImageView.alpha = 1
                self.logoLine.alpha = 1
                self.logoTextView.alpha = 1
                
                self.usernameTextFieldBox.alpha = 1
                
                self.logInButton.alpha = 1
                self.createAccountButton.alpha = 1
            })
            
        }
    }
    
    @IBAction func dismissKeyboardTap(sender: AnyObject) {
        if usernameTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
        }
        else if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func enterUsernameTap(sender: AnyObject) {
        usernameTextField.becomeFirstResponder()
    }
    
    @IBAction func enterPasswordTap(sender: AnyObject) {
        passwordTextField.becomeFirstResponder()
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return seguePresenting == "Create Account" ? GrowAnimatedTransition(presenting: true, sourceButtonFrame: createAccountButton.frame) : LoginTransition(presenting: true)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return seguePresenting == "Create Account" ? GrowAnimatedTransition(presenting: false, sourceButtonFrame: createAccountButton.frame) : LoginTransition(presenting: false)
    }
    
    @IBAction func pressedLoginButton(sender: AnyObject) {
        
        self.loginLoadingCircle.hidden = false
        
        var rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = M_PI * 2.0
        rotationAnimation.duration = 1.0
        rotationAnimation.cumulative = true
        rotationAnimation.repeatCount = 999
        
        self.loginLoadingCircle.layer.addAnimation(rotationAnimation, forKey: "rotationAnimation")
        
        UIView.animateWithDuration(0.15, delay: 0, usingSpringWithDamping: 20, initialSpringVelocity: 30, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.logoImageView.transform = CGAffineTransformMakeTranslation(0, CGRectGetMidY(UIScreen.mainScreen().bounds) - self.logoImageView.center.y)
        }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
            self.logoLine.alpha = 0.0
            self.logoTextView.alpha = 0.0
            
            self.usernameTextFieldBox.alpha = 0.0
            self.passwordTextFieldBox.alpha = 0.0
            
            self.usernameTextFieldBox.userInteractionEnabled = false
            self.passwordTextFieldBox.userInteractionEnabled = false
            
            self.logInButton.alpha = 0.0
            self.createAccountButton.alpha = 0.0
            
            self.logInButton.enabled = false
            self.createAccountButton.enabled = false
            }, completion: { (completed: Bool) -> Void in
                self.loginLoadingCircle.transform = CGAffineTransformMakeTranslation(0, CGRectGetMidY(UIScreen.mainScreen().bounds) - self.loginLoadingCircle.center.y)
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.loginLoadingCircle.alpha = 1.0
                })
                })
        
        PFUser.logInWithUsernameInBackground(usernameTextField.text, password: passwordTextField.text) { (user: PFUser!, error: NSError!) -> Void in
            if error == nil {
                self.logIn()
            }
            else {
                var errorAlert = UIAlertController(title: "Error", message: error.code == 101 ? "The username or password is incorrect." : error.localizedDescription, preferredStyle: .Alert)
                errorAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                self.presentViewController(errorAlert, animated: true, completion: nil)
                self.restoreLoginScreen()
            }
        }
    }
    
    func logIn() {
        self.performSegueWithIdentifier("Log In", sender: nil)
        self.passwordTextField.text = ""
        restoreLoginScreen()
    }
    
    func restoreLoginScreen() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.loginLoadingCircle.alpha = 0.0
            self.loginLoadingCircle.layer.removeAllAnimations()
            }, completion: { (completed: Bool) -> Void in
                UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseIn, animations: { () -> Void in
                    self.loginLoadingCircle.hidden = true
                    self.logoLine.alpha = 1.0
                    self.logoTextView.alpha = 1.0
                    
                    self.usernameTextFieldBox.alpha = 1.0
                    self.passwordTextFieldBox.alpha = 1.0
                    
                    self.usernameTextFieldBox.userInteractionEnabled = true
                    self.passwordTextFieldBox.userInteractionEnabled = true
                    
                    self.logInButton.alpha = 1.0
                    self.createAccountButton.alpha = 1.0
                    
                    self.logInButton.enabled = true
                    self.createAccountButton.enabled = true
                    
                    self.logoImageView.transform = CGAffineTransformIdentity
                    //self.loginLoadingCircle.transform = CGAffineTransformIdentity
                    }, completion: nil)
        })
    }
    
    func createdAccountWithUsername(username: String, password: String) {
        usernameTextField.text = username
        passwordTextField.text = password
        pressedLoginButton(String())
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        seguePresenting = segue.identifier!
        if segue.identifier == "Create Account" {
            let createAccountVC = segue.destinationViewController as CreateAccountViewController
            createAccountVC.modalPresentationStyle = UIModalPresentationStyle.Custom
            createAccountVC.transitioningDelegate = self
            createAccountVC.delegate = self
        }
        else if segue.identifier == "Log In" {
            let accountTabBarVC = segue.destinationViewController as UITabBarController
            accountTabBarVC.modalPresentationStyle = .FullScreen
            accountTabBarVC.transitioningDelegate = self
        }
    }
}
