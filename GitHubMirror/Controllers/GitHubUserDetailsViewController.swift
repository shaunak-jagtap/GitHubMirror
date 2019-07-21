//
//  GitHubUserDetailsViewController.swift
//  GitHubMirror
//
//  Created by MMT on 21/07/19.
//  Copyright © 2019 ShaunakJagtap. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class GitHubUserDetailsViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var selectedUser = GitHubUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedUser.login
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:UITableViewCell = (tableView.dequeueReusableCell(withIdentifier: "user_cell") )!
        return cell
        
    }
}
