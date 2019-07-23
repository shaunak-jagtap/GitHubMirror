//
//  FollowersViewControl.swift
//  GitHubMirror
//
//  Created by MMT on 23/07/19.
//  Copyright © 2019 ShaunakJagtap. All rights reserved.
//

import UIKit

class FollowersViewControl: GitUserBaseViewController{
    
    var selectedUser:GitHubUser!
    var displaytitle:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = displaytitle
        
        let username = selectedUser.login ?? ""
        if username.count > 0 {
            
            var social = "following"
            if displaytitle == "Followers" {
                social = "followers"
            }
            
            getFollowersForUser(username, type: social, closure: { (result) in
                self.usersTableView.reloadData();
            })
        }
        

        
        usersTableView.reloadData()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < users.items.count
        {
            let selectedItem = users.items[indexPath.row]
            performSegue(withIdentifier: "followers_details_segue", sender: selectedItem)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "followers_details_segue" {
            let userDetailsVC = segue.destination as! GitHubUserDetailsViewController
            userDetailsVC.selectedUser = sender as! GitHubUser
        }
    }
    
    
    func getFollowersForUser(_ username:String, type:String, closure:@escaping (_ completion: Any) -> Void) {
        spinner.startAnimating()
        let apilinks = ApiLinks.init()
        let webServiceHandler = WebServiceHandler.init()
        apilinks.searchPage = pageNumber
        apilinks.username = username.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        webServiceHandler.fetchDataFromWebService(url:apilinks.getFollowersFollowingForUserUrl(social:type),method:.get,[:], closure:
            {
                response in
                
                if let resultArray = response as? [Dictionary<String, Any>]
                {
                    for gitHubUserObj in resultArray
                    {
                        self.users.items.append(GitHubUser.init(json: gitHubUserObj))
                    }
                    closure("success")
                }
                else
                {
                    //Error
                    closure(response)
                    self.handleError(error: response as! Error)
                }
                //                self.usersTableView.reloadData()
                self.spinner.stopAnimating()
        })
    }
    
    
}
