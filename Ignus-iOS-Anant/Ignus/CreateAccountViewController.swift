//
//  CreateAccountViewController.swift
//  Usef
//
//  Created by Anant Jain on 12/26/14.
//  Copyright (c) 2014 Anant Jain. All rights reserved.
//

import UIKit

protocol CreateAccountViewControllerDelegate {
    func createdAccountWithUsername(username: String, password: String)
}

class CreateAccountViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var firstNameTextFieldBox: UIView!
    @IBOutlet weak var lastNameTextFieldBox: UIView!
    @IBOutlet weak var emailTextFieldBox: UIView!
    @IBOutlet weak var usernameTextFieldBox: UIView!
    @IBOutlet weak var passwordTextFieldBox: UIView!
    @IBOutlet weak var confirmPasswordTextFieldBox: UIView!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    
    var delegate: CreateAccountViewControllerDelegate?
    
    var toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: UIScreen.mainScreen().bounds.size.width, height: 44))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        //scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width, 300)
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
        usernameTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        
        toolbar.barStyle = .Black
        toolbar.tintColor = UIColor.whiteColor()
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil), UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "resignTextBoxFirstResponder")]
        
        firstNameTextField.inputAccessoryView = toolbar
        lastNameTextField.inputAccessoryView = toolbar
        emailTextField.inputAccessoryView = toolbar
        usernameTextField.inputAccessoryView = toolbar
        passwordTextField.inputAccessoryView = toolbar
        confirmPasswordTextField.inputAccessoryView = toolbar
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resignTextBoxFirstResponder() {
        if firstNameTextField.isFirstResponder() {
            firstNameTextField.resignFirstResponder()
        }
        else if lastNameTextField.isFirstResponder() {
            lastNameTextField.resignFirstResponder()
        }
        else if emailTextField.isFirstResponder() {
            emailTextField.resignFirstResponder()
        }
        else if usernameTextField.isFirstResponder() {
            usernameTextField.resignFirstResponder()
        }
        else if passwordTextField.isFirstResponder() {
            passwordTextField.resignFirstResponder()
        }
        else if confirmPasswordTextField.isFirstResponder() {
            confirmPasswordTextField.resignFirstResponder()
        }
    }
    
    @IBAction func selectFirstNameTextField(sender: AnyObject) {
        firstNameTextField.becomeFirstResponder()
    }
    
    @IBAction func selectLastNameTextField(sender: AnyObject) {
        lastNameTextField.becomeFirstResponder()
    }
    
    @IBAction func selectEmailTextField(sender: AnyObject) {
        emailTextField.becomeFirstResponder()
    }
    
    @IBAction func selectUsernameTextField(sender: AnyObject) {
        usernameTextFieldBox.becomeFirstResponder()
    }
    
    @IBAction func selectPasswordTextField(sender: AnyObject) {
        passwordTextField.becomeFirstResponder()
    }
    
    @IBAction func selectConfirmPasswordTextField(sender: AnyObject) {
        confirmPasswordTextField.becomeFirstResponder()
    }
    
    @IBAction func cancelAccountCreation(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func signUp(sender: AnyObject) {
        if (countElements(firstNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)) == 0) {
            var alert = UIAlertController(title: "Error", message: "Please enter a valid first name.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else if (countElements(lastNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)) == 0) {
            var alert = UIAlertController(title: "Error", message: "Please enter a valid last name.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else if (countElements(emailTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)) == 0) {
            var alert = UIAlertController(title: "Error", message: "Please enter a valid email address.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else if (countElements(usernameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)) == 0) {
            var alert = UIAlertController(title: "Error", message: "Please enter a valid username.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else if (countElements(passwordTextField.text) == 0) {
            var alert = UIAlertController(title: "Error", message: "Please enter a valid password.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else if (countElements(confirmPasswordTextField.text) == 0) {
            var alert = UIAlertController(title: "Error", message: "Please confirm your password.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else if (passwordTextField.text != confirmPasswordTextField.text) {
            var alert = UIAlertController(title: "Error", message: "The password and the confirmation password are not the same.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(alert, animated: true, completion: nil)
        }
        else {
            var newUser = PFUser()
            newUser.username = usernameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            newUser.password = passwordTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            newUser.email = emailTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            newUser["FirstName"] = firstNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            newUser["LastName"] = lastNameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
            var profileFile = PFFile(data: UIImagePNGRepresentation(UIImage(named: "DefaultProfile.png")))
            var coverFile = PFFile(data: UIImageJPEGRepresentation(UIImage(named: "DefaultCover.jpg"), 0.5))
            
            profileFile.saveInBackgroundWithBlock({ (completed: Bool, error: NSError!) -> Void in
                if error == nil {
                    newUser["Profile"] = profileFile
                }
                else {
                    println(error.localizedDescription)
                }
            })
            coverFile.saveInBackgroundWithBlock({ (completed: Bool, error: NSError!) -> Void in
                if error == nil {
                    newUser["Cover"] = coverFile
                }
            })
            
            newUser["Friends"] = [String]()
            
            newUser.signUpInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in
                        if (self.delegate != nil) {
                            self.delegate!.createdAccountWithUsername(self.usernameTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil), password: self.passwordTextField.text.stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil))
                        }
                    })
                }
                else {
                    var errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                    errorAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                }
            })
        }
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        var offset = textField.superview!.frame.origin
        offset.x = 0
        offset.y -= 20
        
        scrollView.setContentOffset(offset, animated: true)
        return true
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        switch textField {
        case firstNameTextField:
            lastNameTextField.becomeFirstResponder()
        case lastNameTextField:
            emailTextField.becomeFirstResponder()
        case emailTextField:
            usernameTextField.becomeFirstResponder()
        case usernameTextField:
            passwordTextField.becomeFirstResponder()
        case passwordTextField:
            confirmPasswordTextField.becomeFirstResponder()
        case confirmPasswordTextField:
            confirmPasswordTextField.resignFirstResponder()
            var offset = firstNameTextFieldBox.frame.origin
            offset.x = 0
            offset.y += 20
            scrollView.setContentOffset(offset, animated: true)
        default:
            break
        }
        return true
    }
}
