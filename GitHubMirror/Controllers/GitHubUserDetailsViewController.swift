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
    
    @IBOutlet weak var userDetailsTableView: UITableView!
    var selectedUser = GitHubUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedUser.login
        
        let apilinks = ApiLinks.init()
        let webServiceHandler = WebServiceHandler.init()
        apilinks.username = selectedUser.login ?? ""
    webServiceHandler.fetchDataFromWebService(url:apilinks.getUserDetailsSearchUrl(),method:.get,[:], closure:
        {
            response in
            if let resultDictionary = response as? Dictionary<String, Any>
            {
                let gitUser:GitHubUser = GitHubUser.init(json: resultDictionary)
                self.selectedUser = gitUser
                self.userDetailsTableView.reloadData()
            }
            else
            {
                //Error
            }
        })
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return 220
        }
        else
        {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0
        {
            let cell:UserDetailsCell = (userDetailsTableView.dequeueReusableCell(withIdentifier: "user_details_cell") as! UserDetailsCell?)!
            
            let url = URL(string: selectedUser.avatar_url ?? "github_logo.png")!
            let placeholderImage = UIImage(named: "github_logo.png")!
            cell.userImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            cell.userTitle?.text = selectedUser.login ?? "Title"
            cell.userLocation.text = selectedUser.location
            
            return cell
        }
        else
        {
            let cell:GitUserDetailCell = (userDetailsTableView.dequeueReusableCell(withIdentifier: "git_user_detail") as! GitUserDetailCell?)!
            
            switch indexPath.row {
            case 1:
                cell.userTitle.text = "Followers"
                cell.userSubTitle.text = "\(selectedUser.followers ?? 0)"
                cell.userImageView.image = UIImage(named: "followers")!
                break
                
            case 2:
                cell.userTitle.text = "Following"
                cell.userSubTitle.text = "\(selectedUser.following ?? 0)"
                cell.userImageView.image = UIImage(named: "following")!
                break
                
            case 3:
                cell.userTitle.text = "Public repos"
                cell.userSubTitle.text = "\(selectedUser.public_repos ?? 0)"
                cell.userImageView.image = UIImage(named: "fork")!
                break
                
            case 4:
                cell.userTitle.text = "Updated at"
                cell.userSubTitle.text = selectedUser.updated_at
                cell.userImageView.image = UIImage(named: "updated")!
                break
                
            case 5:
                cell.userTitle.text = "Public gists"
                cell.userSubTitle.text = "\(selectedUser.public_gists ?? 0)"
                break
                
            case 6:
                cell.userTitle.text = "Bio"
                cell.userSubTitle.text = selectedUser.bio
                cell.userImageView.image = UIImage(named: "bio")!
                break
                
            default:
                cell.userTitle.text = ""
                
            }
            
            return cell
        }
        
        
        
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0
        {
            let mCell = cell as! UserDetailsCell
            
            mCell.bgImageView.image = mCell.userImageView.image
            
            let darkBlur = UIBlurEffect(style: .dark)
            // 2
            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = cell.bounds
            
            // 3
            mCell.bgImageView.addSubview(blurView)
        }

    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let viewController = storyboard.instantiateViewController(withIdentifier :"listVC")
//        self.present(viewController, animated: true)
//    }
    
}
