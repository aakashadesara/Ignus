//
//  SelectFriendViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/8/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

protocol SelectFriendViewControllerDelegate {
    func selectedFriendWithFirstName(firstName: String, username: String);
}

class SelectFriendViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var friendsTable: UITableView!
    @IBOutlet weak var noFriendsLabel: UILabel!
    
    var delegate: SelectFriendViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if (PFUser.currentUser()["Friends"] as [String]).count == 0 {
            self.friendsTable.hidden = true
        }
        else {
            self.noFriendsLabel.hidden = true
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (PFUser.currentUser()["Friends"] as [String]).count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Friend Cell") as UITableViewCell
        
        var username = (PFUser.currentUser()["Friends"] as [String])[indexPath.row]
        var query = PFUser.query()
        query.whereKey("username", equalTo: username)
        var user = query.getFirstObject() as PFObject
        
        var profileImageView = cell.viewWithTag(1) as UIImageView
        var nameTextView = cell.viewWithTag(2) as UILabel
        var usernameTextView = cell.viewWithTag(3) as UILabel
        
        profileImageView.image = UIImage(named: "DefaultProfile.png")
        nameTextView.text = (user["FirstName"] as String) + " " + (user["LastName"] as String)
        usernameTextView.text = username
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIView()
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.grayColor()
        backgroundView.alpha = 0.5
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if self.delegate != nil {
            var username = (PFUser.currentUser()["Friends"] as [String])[indexPath.row]
            var query = PFUser.query()
            query.whereKey("username", equalTo: username)
            var user = query.getFirstObject() as PFObject
            
            self.delegate?.selectedFriendWithFirstName(user["FirstName"] as String, username: user["username"] as String)
            
            self.navigationController?.popViewControllerAnimated(true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
