//
//  FollowersViewControl.swift
//  GitHubMirror
//
//  Created by MMT on 23/07/19.
//  Copyright © 2019 ShaunakJagtap. All rights reserved.
//

import UIKit

class FollowersViewControl: GitHubUsersSearchViewController{
    
//    var users : GitHubUsers = GitHubUsers()
//    var pageNumber:Int = 1
//    let spinner = UIActivityIndicatorView(style: .gray)
//
//    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
//    @IBOutlet weak var usersTableView: UITableView!
//    @IBOutlet weak var userSearchBar: UISearchBar!
//    @IBOutlet weak var animatedLabel: UILabel!
//
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Followers"
        
        usersTableView.backgroundColor = .clear
        
        userSearchBar.isHidden = true
        
        
    }
}
