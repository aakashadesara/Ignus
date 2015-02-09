//
//  AddPaymentTableViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/8/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class AddPaymentTableViewController: UITableViewController, SelectFriendViewControllerDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    @IBOutlet weak var selectedFriendIndicator: UILabel!
    @IBOutlet weak var moneyPickerView: UIPickerView!
    @IBOutlet weak var memoTextView: UITextView!
    
    var friendUsername: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 100
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var title = String()
        switch component {
        case 0:
            title = "$\(row)."
        case 1:
            title = row < 10 ? "0\(row)" : String(row)
        default:
            break
        }
        return NSAttributedString(string: title, attributes: [NSForegroundColorAttributeName:UIColor.whiteColor()])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func selectedFriendWithFirstName(firstName: String, username: String) {
        self.selectedFriendIndicator.text = firstName
        self.friendUsername = username
        
    }
    
    @IBAction func cancelAddPayment(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func addPayment(sender: AnyObject) {
        if friendUsername == nil {
            var errorAlert = UIAlertController(title: "Error", message: "Please select a friend who owes you money.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(errorAlert, animated: true, completion: nil)
        }
        else if moneyPickerView.selectedRowInComponent(0) == 0 && moneyPickerView.selectedRowInComponent(1) == 0 {
            var errorAlert = UIAlertController(title: "Error", message: "Please enter a valid amount owed.", preferredStyle: .Alert)
            errorAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
            presentViewController(errorAlert, animated: true, completion: nil)
        }
        else {
            var newPayment = PFObject(className: "Payments")
            newPayment["recipientUsername"] = PFUser.currentUser()["username"] as String
            newPayment["senderUsername"] = friendUsername!
            newPayment["currentStatus"] = "Requested"
            newPayment["moneyOwed"] = (("\(moneyPickerView.selectedRowInComponent(0))" + "." + "\(moneyPickerView.selectedRowInComponent(1))") as NSString).doubleValue
            newPayment["memo"] = memoTextView.text
            newPayment["rating"] = "Undecided"
            newPayment.saveInBackgroundWithBlock({ (succeeded: Bool, error: NSError!) -> Void in
                if error == nil {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                else {
                    var errorAlert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .Alert)
                    errorAlert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                    self.presentViewController(errorAlert, animated: true, completion: nil)
                }
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var selectFriendVC = segue.destinationViewController as SelectFriendViewController
        selectFriendVC.delegate = self
    }
}
