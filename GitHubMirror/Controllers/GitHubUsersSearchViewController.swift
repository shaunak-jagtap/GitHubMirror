//
//  GitHubUsersSearchViewController.swift
//  GitHubMirror
//
//  Created by Shaunak on 19/07/19.
//  Copyright © 2019 ShaunakJagtaps. All rights reserved.
//

import UIKit

class GitHubUsersSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var users : GitHubUsers?
    
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    func getUsersForSearchQuery()
    {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return users?.items.count ?? 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell:UITableViewCell = self.usersTableView.dequeueReusableCell(withIdentifier: "user_cell")
        else
        {
            return UITableViewCell()
        }
        
        return cell
    }
 
}


