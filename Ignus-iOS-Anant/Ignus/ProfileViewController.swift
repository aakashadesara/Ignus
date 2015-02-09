//
//  ProfileViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/7/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, XYPieChartDataSource, XYPieChartDelegate, UITableViewDataSource {
    
    var user: PFObject?
    
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var coverPictureView: UIImageView!
    @IBOutlet weak var nameTextView: UILabel!
    
    @IBOutlet weak var numConnectionsLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    
    @IBOutlet weak var toggleFriendButton: UIButton!
    
    @IBOutlet weak var pieChart: XYPieChart!
    
    @IBOutlet weak var chartPercentageLabel: UILabel!
    
    @IBOutlet weak var userSegmentedControl: UISegmentedControl!
    @IBOutlet weak var paymentsView: UIView!
    
    @IBOutlet weak var paymentsSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var noPaymentsLabel: UILabel!
    @IBOutlet weak var paymentsTable: UITableView!
    
    var sentPayments = [PFObject]()
    var receivedPayments = [PFObject]()
    
    var ratings = [1853, 103, 313]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = user!["FirstName"] as? String
        self.nameTextView.text = (user!["FirstName"] as String) + " " + (user!["LastName"] as String)
        self.profilePictureView.image = UIImage(named: "DefaultProfile.png")
        self.coverPictureView.image = UIImage(named: "DefaultCover.jpg")
        
        pieChart.dataSource = self
        pieChart.delegate = self
        
        pieChart.animationSpeed = 1.0
        pieChart.labelFont = UIFont(name: "Gotham-Book", size: 20)
        pieChart.labelRadius = 65
        
        pieChart.reloadData()
        
        chartPercentageLabel.text = String(format: "%.1lf%%",(1853.0 / Double(1853 + 103 + 313)) * 100.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func userSegmentedControlChanged(sender: AnyObject) {
        if userSegmentedControl.selectedSegmentIndex == 0 {
            paymentsView.hidden = true
            pieChart.hidden = false
        }
        else if userSegmentedControl.selectedSegmentIndex == 1 {
            paymentsView.hidden = false
            pieChart.hidden = true
            
            paymentsSegmentedControlChanged(paymentsSegmentedControl)
        }
        else {
            paymentsView.hidden = true
            pieChart.hidden = true
        }
    }
    
    @IBAction func paymentsSegmentedControlChanged(sender: AnyObject) {
        if paymentsSegmentedControl.selectedSegmentIndex == 0 {
            var query = PFQuery(className: "Transactions")
            query.whereKey("currentStatus", notEqualTo: "Requested")
            query.whereKey("recipientUsername", equalTo: user!["username"])
            query.whereKey("senderUsername", equalTo: PFUser.currentUser()["username"])
            sentPayments = query.findObjects() as [PFObject]
            
            if sentPayments.count == 0 {
                self.paymentsTable.hidden = true
                self.noPaymentsLabel.hidden = false
            }
            else {
                self.paymentsTable.hidden = false
                self.noPaymentsLabel.hidden = true
            }
            self.paymentsTable.reloadData()
        }
        else {
            var query = PFQuery(className: "Transactions")
            query.whereKey("currentStatus", notEqualTo: "Requested")
            query.whereKey("senderUsername", equalTo: user!["username"])
            query.whereKey("recipientUsername", equalTo: PFUser.currentUser()["username"])
            receivedPayments = query.findObjects() as [PFObject]
            
            if receivedPayments.count == 0 {
                self.paymentsTable.hidden = true
                self.noPaymentsLabel.hidden = false
            }
            else {
                self.paymentsTable.hidden = false
                self.noPaymentsLabel.hidden = true
            }
            self.paymentsTable.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return paymentsSegmentedControl.selectedSegmentIndex == 0 ? sentPayments.count : receivedPayments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Payment Cell") as UITableViewCell
        
        var profileImage = cell.viewWithTag(1) as UIImageView
        profileImage.image = UIImage(named: "DefaultProfile.png")
        
        var nameLabel = cell.viewWithTag(2) as UILabel
        var moneyLabel = cell.viewWithTag(3) as UILabel
        
        nameLabel.text = (user!["FirstName"] as String) + " " + (user!["LastName"] as String)
        
        if paymentsSegmentedControl.selectedSegmentIndex == 0 {
            moneyLabel.text = String(format: "%.2f", Double(sentPayments[indexPath.row]["moneyOwed"] as NSNumber))
        }
        else {
            moneyLabel.text = String(format: "%.2f", Double(receivedPayments[indexPath.row]["moneyOwed"] as NSNumber))
        }
        
        cell.backgroundView = UIView()
        
        return cell
    }
    
    
    func pieChart(pieChart: XYPieChart!, valueForSliceAtIndex index: UInt) -> CGFloat {
        return CGFloat(ratings[Int(index)])
    }
    
    func pieChart(pieChart: XYPieChart!, colorForSliceAtIndex index: UInt) -> UIColor! {
        switch index {
        case 0:
            return UIColor(red: 85/255.0, green: 205/255.0, blue: 41/255.0, alpha: 1.0)
        case 1:
            return UIColor.redColor()
        case 2:
            return UIColor.yellowColor()
        default:
            return UIColor.whiteColor()
        }
    }
    
    func numberOfSlicesInPieChart(pieChart: XYPieChart!) -> UInt {
        return 3
    }
    
    func pieChart(pieChart: XYPieChart!, didSelectSliceAtIndex index: UInt) {
        UIView.transitionWithView(chartPercentageLabel, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.chartPercentageLabel.text = String(format: "%.1lf%%", Double(self.ratings[Int(index)]) / Double(1853 + 103 + 313) * 100.0)
        }, completion: nil)
    }
    
    func pieChart(pieChart: XYPieChart!, didDeselectSliceAtIndex index: UInt) {
        UIView.transitionWithView(chartPercentageLabel, duration: 0.3, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: { () -> Void in
            self.chartPercentageLabel.text = String(format: "%.1lf%%", 1853.0 / Double(1853 + 103 + 313) * 100.0)
            }, completion: nil)
    }
    
    @IBAction func sendFriendRequest(sender: AnyObject) {
        var newRequest = PFObject(className: "FriendRequests")
        newRequest["senderUsername"] = PFUser.currentUser()!["username"] as String
        newRequest["recipientUsername"] = user!["username"] as String
        newRequest["currentStatus"] = "Requested"
        
        newRequest.saveInBackgroundWithBlock { (completed: Bool, error: NSError!) -> Void in
            if error == nil {
                self.toggleFriendButton.setTitle("Request Sent", forState: .Normal)
                self.toggleFriendButton.setTitleColor(UIColor.lightGrayColor(), forState: .Normal)
                self.toggleFriendButton.enabled = false
            }
            else {
                var alert = UIAlertController(title: "Error", message: "The friend request could not be sent at this time. Please try again later.", preferredStyle: .Alert)
                alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
