//
//  AddFriendsViewController.swift
//  Ignus
//
//  Created by Anant Jain on 2/7/15.
//  Copyright (c) 2015 Anant Jain. All rights reserved.
//

import UIKit

class AddFriendsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    @IBOutlet weak var addFriendsList: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var friendsQuery = PFQuery()
    var searchedFriends = [PFObject]()

    override func viewWillAppear(animated: Bool) {
        if let selectedIndex = addFriendsList.indexPathForSelectedRow() {
            addFriendsList.deselectRowAtIndexPath(selectedIndex, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        addFriendsList.contentInset = UIEdgeInsets(top: self.navigationController!.navigationBar.frame.size.height + UIApplication.sharedApplication().statusBarFrame.size.height, left: 0, bottom: 0, right: 0)
        
        addFriendsList.setContentOffset(CGPoint(x: 0, y: -100), animated: false)
        
        searchBar.keyboardAppearance = .Dark
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func dismissAddFriends(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if countElements(searchText) != 0 {
            friendsQuery = PFUser.query()
            friendsQuery.whereKey("username", containsString: searchText)
            friendsQuery.findObjectsInBackgroundWithBlock({ (objects: [AnyObject]!, error: NSError!) -> Void in
                if error == nil {
                    self.searchedFriends = objects as [PFObject]
                    self.addFriendsList.reloadData()
                } else {
                    println(error.localizedDescription)
                }
            })
        }
        else {
            searchedFriends = [PFObject]()
            self.addFriendsList.reloadData()
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedFriends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Friend Cell") as UITableViewCell
        
        var user = searchedFriends[indexPath.row]
        
        var friendImageView = cell.viewWithTag(1) as UIImageView
        var friendNameView = cell.viewWithTag(2) as UILabel
        var friendUsernameView = cell.viewWithTag(3) as UILabel
        
        friendImageView.image = UIImage(named: "DefaultProfile.png")
        friendNameView.text = (user["FirstName"] as String) + " " + (user["LastName"] as String)
        friendUsernameView.text = user["username"] as? String
        
        cell.backgroundColor = UIColor.clearColor()
        cell.backgroundView = UIView()
        
        var backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.grayColor()
        backgroundView.alpha = 0.5
        cell.selectedBackgroundView = backgroundView
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("Show Profile", sender: indexPath)
    }

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "Show Profile" {
            var profileVC = segue.destinationViewController as ProfileViewController
            profileVC.user = searchedFriends[(sender as NSIndexPath).row]
        }
    }

}
