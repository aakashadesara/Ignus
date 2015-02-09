//
//  PaymentsViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/8/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class PaymentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIViewControllerTransitioningDelegate {
    
    @IBOutlet weak var paymentsTable: UITableView!
    @IBOutlet weak var noPaymentsView: UIView!
    @IBOutlet weak var paymentsFilterSegmentedControl: UISegmentedControl!
    
    var myPaymentsList = [PFObject]()
    var incomingPaymentsList = [PFObject]()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        var query = PFQuery(className: "Payments")
        query.whereKey("recipientUsername", equalTo: PFUser.currentUser()["username"] as String)
        query.whereKey("currentStatus", equalTo: "Requested")
        myPaymentsList = query.findObjects() as [PFObject]
        
        query = PFQuery(className: "Payments")
        query.whereKey("senderUsername", equalTo: PFUser.currentUser()["username"] as String)
        query.whereKey("currentStatus", equalTo: "Requested")
        incomingPaymentsList = query.findObjects() as [PFObject]
        
        if paymentsFilterSegmentedControl.selectedSegmentIndex == 0 {
            if myPaymentsList.count == 0 {
                self.paymentsTable.hidden = true
                self.noPaymentsView.hidden = false
            }
            else {
                self.paymentsTable.hidden = false
                self.noPaymentsView.hidden = true
            }
        }
        else if paymentsFilterSegmentedControl.selectedSegmentIndex == 1 {
            if incomingPaymentsList.count == 0 {
                self.paymentsTable.hidden = true
                self.noPaymentsView.hidden = false
            }
            else {
                self.paymentsTable.hidden = false
                self.noPaymentsView.hidden = true
            }
        }
        
        self.paymentsTable.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if let selectedIndex = paymentsTable.indexPathForSelectedRow() {
            paymentsTable.deselectRowAtIndexPath(selectedIndex, animated: true)
        }
    }
    
    @IBAction func changeFilter(sender: AnyObject) {
        self.viewWillAppear(true)
        println(incomingPaymentsList.count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch (paymentsFilterSegmentedControl.selectedSegmentIndex) {
        case 0:
            return myPaymentsList.count
        case 1:
            return incomingPaymentsList.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Payment Cell") as UITableViewCell
        
        var profileView = cell.viewWithTag(1) as UIImageView
        var nameView = cell.viewWithTag(2) as UILabel
        var moneyView = cell.viewWithTag(3) as UILabel
        
        profileView.image = UIImage(named: "DefaultProfile.png")
        
        if paymentsFilterSegmentedControl.selectedSegmentIndex == 0 {
            var payment = myPaymentsList[indexPath.row]
            
            var query = PFUser.query()
            query.whereKey("username", equalTo: payment["senderUsername"] as String)
            var user = query.getFirstObject()
            
            nameView.text = (user["FirstName"] as String) + " " + (user["LastName"] as String)
            println(payment)
            let money = payment["moneyOwed"] as Double
            moneyView.text = String(format: "$%.2lf", money as NSNumber)
            cell.userInteractionEnabled = false
        }
        else if paymentsFilterSegmentedControl.selectedSegmentIndex == 1 {
            var payment = incomingPaymentsList[indexPath.row]
            
            var query = PFUser.query()
            query.whereKey("username", equalTo: payment["recipientUsername"] as String)
            var user = query.getFirstObject()
            
            nameView.text = (user["FirstName"] as String) + " " + (user["LastName"] as String)
            let money = payment["moneyOwed"] as Double
            moneyView.text = String(format: "$%.2lf", money as NSNumber)
            cell.userInteractionEnabled = true
        }
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIView()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.grayColor()
        backgroundView.alpha = 0.5
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if (paymentsFilterSegmentedControl.selectedSegmentIndex == 1) {
            performSegueWithIdentifier("Show Payment Info", sender: incomingPaymentsList[indexPath.row])
        }
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = SlideUpTransition()
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        var transition = SlideUpTransition()
        transition.presenting = false
        return transition
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Payment Info" {
            let paymentInfoNavVC = segue.destinationViewController as UINavigationController
            let paymentInfoVC = paymentInfoNavVC.topViewController as PaymentInfoTableViewController
            paymentInfoVC.payment = sender as? PFObject
            paymentInfoNavVC.modalPresentationStyle = .Custom
            paymentInfoNavVC.transitioningDelegate = self
        }
    }
    
}
