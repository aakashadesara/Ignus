//
//  PaymentInfoTableViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/8/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class PaymentInfoTableViewController: UITableViewController {
    
    @IBOutlet weak var recipientNameLabel: UILabel!
    @IBOutlet weak var moneyLabel: UILabel!
    @IBOutlet weak var memoTextView: UITextView!
    
    var payment: PFObject?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        var query = PFUser.query()
        query.whereKey("username", equalTo: payment!["recipientUsername"])
        var user = query.getFirstObject() as PFUser
        
        recipientNameLabel.text = (user["FirstName"] as String) + " " + (user["LastName"] as String)
        moneyLabel.text = String(format: "$%.2lf", Double(payment!["moneyOwed"] as NSNumber))
        memoTextView.text = payment!["memo"] as String
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelPayment(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Pay" {
            let payVC = segue.destinationViewController as PayViewController
            payVC.payment = self.payment
        }
    }
}
