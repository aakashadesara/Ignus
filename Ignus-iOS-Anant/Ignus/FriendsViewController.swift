//
//  FriendsViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/7/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class FriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var noFriendsView: UIView!
    @IBOutlet weak var friendsFilterSegmentedControl: UISegmentedControl!
    
    var requests = [PFObject]()
    
    var currentUser = PFUser.currentUser()

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        var query = PFQuery(className: "FriendRequests")
        query.whereKey("recipientUsername", equalTo: currentUser.username)
        query.whereKey("currentStatus", equalTo: "Requested")
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
            if error == nil {
                self.requests = objects as [PFObject]
            }
            else {
                self.requests = [PFObject]()
            }
        })
        
        if (friendsFilterSegmentedControl.selectedSegmentIndex == 0) {
            if let friendsList = currentUser["Friends"] as? [String] {
                if friendsList.count == 0 {
                    friendsTable.hidden = true
                    friendsTable.alpha = 0.0
                    noFriendsView.alpha = 1.0
                    noFriendsView.hidden = false
                }
                else {
                    friendsTable.hidden = false
                    friendsTable.alpha = 1.0
                    noFriendsView.alpha = 0.0
                    noFriendsView.hidden = true
                }
            }
            else {
                currentUser["Friends"] = [String]()
                friendsTable.hidden = true
                friendsTable.alpha = 0.0
                noFriendsView.alpha = 1.0
                noFriendsView.hidden = false
            }
        }
        else {
            if requests.count == 0 {
                friendsTable.hidden = true
                friendsTable.alpha = 0.0
                noFriendsView.alpha = 1.0
                noFriendsView.hidden = false
            }
            else {
                friendsTable.hidden = false
                friendsTable.alpha = 1.0
                noFriendsView.alpha = 0.0
                noFriendsView.hidden = true
            }
        }
        
        self.friendsTable.reloadData()
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
        switch friendsFilterSegmentedControl.selectedSegmentIndex {
        case 0:
            if let friendsList = currentUser["Friends"] as? [String] {
                return friendsList.count
            }
            return 0
        case 1:
            return requests.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (friendsFilterSegmentedControl.selectedSegmentIndex == 0) {
            var cell = tableView.dequeueReusableCellWithIdentifier("Friend Cell") as UITableViewCell!
            
            if let friendsList = currentUser["Friends"] as? [String] {
                var personImageView = cell.viewWithTag(1) as UIImageView!
                var personNameView = cell.viewWithTag(2) as UILabel!
                var personUsernameView = cell.viewWithTag(3) as UILabel!
                
                var query = PFUser.query()
                query.whereKey("username", equalTo: friendsList[indexPath.row])
                
                if let user = query.getFirstObject() {
                    println("called")
                    personImageView.image = UIImage(named: "DefaultProfile.png")
                    personNameView.text = (user["FirstName"] as String) + " " + (user["LastName"] as String)
                    personUsernameView.text = user["username"] as? String
                }
            }
            
            cell.backgroundColor = UIColor.clearColor()
            cell.backgroundView = UIView()
            
            var backgroundView = UIView()
            backgroundView.backgroundColor = UIColor.grayColor()
            backgroundView.alpha = 0.5
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        else {
            var cell = tableView.dequeueReusableCellWithIdentifier("Friend Request") as UITableViewCell!
            
            var personImageView = cell.viewWithTag(1) as UIImageView!
            var personNameView = cell.viewWithTag(2) as UILabel!
            var personUsernameView = cell.viewWithTag(3) as UILabel!
            var acceptButton = cell.viewWithTag(4) as UIButton!
            var declineButton = cell.viewWithTag(5) as UIButton!
            
            acceptButton.addTarget(self, action: "respondToFriendRequest:", forControlEvents: .TouchUpInside)
            declineButton.addTarget(self, action: "respondToFriendRequest:", forControlEvents: .TouchUpInside)
            
            var query = PFUser.query()
            query.whereKey("username", equalTo: requests[indexPath.row]["senderUsername"] as String)
            var sender = query.getFirstObject()
            personImageView.image = UIImage(named: "DefaultProfile.png")
            personNameView.text = (sender["FirstName"] as String) + " " + (sender["LastName"] as String)
            personUsernameView.text = sender["username"] as? String
            
            cell.backgroundColor = UIColor.clearColor()
            cell.backgroundView = UIView()
            cell.selectedBackgroundView = UIView()
            
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if friendsFilterSegmentedControl.selectedSegmentIndex == 0 {
            performSegueWithIdentifier("Show Profile", sender: indexPath)
        }
    }
    
    func respondToFriendRequest(sender: UIButton) {
        var index = friendsTable.indexPathForCell(sender.superview?.superview as UITableViewCell)!.row
        var requestObject = requests[index]
        
        if sender.tag == 4 {
            var currentFriends = currentUser["Friends"] as [String]
            currentFriends.insert(requests[index]["senderUsername"] as String, atIndex: 0)
            currentUser["Friends"] = currentFriends
            currentUser.saveInBackground()
            
            var query = PFUser.query()
            query.whereKey("username", equalTo: requestObject["senderUsername"])
            var senderObject = query.getFirstObject() as PFObject
            
            var senderFriends = senderObject["Friends"] as [String]?
            senderFriends!.insert(requestObject["recipientUsername"] as String, atIndex: 0)
            senderObject["Friends"] = senderFriends
            senderObject.saveInBackground()
            
            requestObject["currentStatus"] = "Accepted"
        }
        else if sender.tag == 5 {
            requestObject["currentStatus"] = "Declined"
        }
        
        requestObject.saveInBackground()
        requests.removeAtIndex(index)
        friendsTable.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: .Automatic)
    }

    @IBAction func changeFilterMode(sender: AnyObject) {
        self.viewWillAppear(true)
    }
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Profile" {
            var query = PFUser.query()
            query.whereKey("username", equalTo: (currentUser["Friends"] as [String])[(sender as NSIndexPath).row] as String)

            var profileVC = segue.destinationViewController as ProfileViewController
            profileVC.user = query.getFirstObject()
        }
    }

}
