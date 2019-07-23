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
    var displayedIndexes : [IndexPath] = []
    var profilePic : UIImage!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = selectedUser.login
        
        userDetailsTableView.tableFooterView = UIView()
        userDetailsTableView.backgroundColor = .clear

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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "user_image_segue"
        {
            let userDetailsVC = segue.destination as! UserProfileImageViewController
            userDetailsVC.profileImage = profilePic
        }
        else if segue.identifier == "followers_segue"
        {
            
            guard let indexPath = sender as? IndexPath else {
                return
            }

            let followerssVC = segue.destination as! FollowersViewControl

            if indexPath.row == 0
            {
                followerssVC.displaytitle = "Followers"
            }
            else
            {
                followerssVC.displaytitle = "Following"
            }
            followerssVC.selectedUser = selectedUser
        }
        
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else
        {
            return 6
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 220
        }
        else
        {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0
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
            case 0:
                cell.userTitle.text = "Followers"
                cell.userSubTitle.text = "\(selectedUser.followers ?? 0)"
                cell.userImageView.image = UIImage(named: "followers")!
                break
                
            case 1:
                cell.userTitle.text = "Following"
                cell.userSubTitle.text = "\(selectedUser.following ?? 0)"
                cell.userImageView.image = UIImage(named: "following")!
                break
                
            case 2:
                cell.userTitle.text = "Public repos"
                cell.userSubTitle.text = "\(selectedUser.public_repos ?? 0)"
                cell.userImageView.image = UIImage(named: "fork")!
                break
                
            case 3:
                cell.userTitle.text = "Public gists"
                cell.userSubTitle.text = "\(selectedUser.public_gists ?? 0)"
                break
                
            case 4:
                cell.userTitle.text = "Updated at"
                cell.userSubTitle.text = selectedUser.updated_at
                cell.userImageView.image = UIImage(named: "updated")!
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
        
        if indexPath.section == 0
        {
            
            let mCell = cell as! UserDetailsCell

            let darkBlur = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = cell.bounds
            mCell.bgImageView.addSubview(blurView)
            
            profilePic = mCell.userImageView.image
            mCell.bgImageView.alpha = 0
            mCell.bgImageView.image = mCell.userImageView.image
            
            UIView.animate(withDuration: 0.9) {
                mCell.bgImageView.alpha = 1
            }
        }
        
        //Animation
        if ( displayedIndexes.contains(indexPath) == false && indexPath.section == 1 ) {
            displayedIndexes.append(indexPath)
            
            //animates the cell as it is being displayed for the first time
            cell.transform = CGAffineTransform(translationX: 0, y: 60/2)
            cell.alpha = 0

            UIView.animate(withDuration: 0.4, delay: 0.09*Double(indexPath.row), options: [.curveEaseInOut], animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0)
                cell.alpha = 1
            }, completion: nil)
            
        }
        
        
        //to make section corners round TODO: does not work debug later
        if (cell.responds(to: #selector(getter: UIView.tintColor)))
        {
            let cornerRadius: CGFloat = 10.0
            cell.backgroundColor = .clear
            let layer: CAShapeLayer = CAShapeLayer()
            let path: CGMutablePath = CGMutablePath()
            let bounds: CGRect = cell.bounds
//            bounds.insetBy(dx: 25.0, dy: 0.0)
            var addLine: Bool = false
            
            if indexPath.row == 0 && indexPath.row == ( tableView.numberOfRows(inSection: indexPath.section) - 1) {
                path.addRoundedRect(in: bounds, cornerWidth: cornerRadius, cornerHeight: cornerRadius)
                
            } else if indexPath.row == 0 {
                path.move(to: CGPoint(x: bounds.minX, y: bounds.maxY))
                path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.minY), tangent2End: CGPoint(x: bounds.midX, y: bounds.minY), radius: cornerRadius)
                path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.minY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY))
                
            } else if indexPath.row == (tableView.numberOfRows(inSection: indexPath.section) - 1) {
                path.move(to: CGPoint(x: bounds.minX, y: bounds.minY))
                path.addArc(tangent1End: CGPoint(x: bounds.minX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.midX, y: bounds.maxY), radius: cornerRadius)
                path.addArc(tangent1End: CGPoint(x: bounds.maxX, y: bounds.maxY), tangent2End: CGPoint(x: bounds.maxX, y: bounds.midY), radius: cornerRadius)
                path.addLine(to: CGPoint(x: bounds.maxX, y: bounds.minY))
                
            } else {
                path.addRect(bounds)
                addLine = true
            }
            
            layer.path = path
            layer.fillColor = UIColor.black.withAlphaComponent(0.8).cgColor
            
            if addLine {
                let lineLayer: CALayer = CALayer()
                let lineHeight: CGFloat = 1.0 / UIScreen.main.scale
                lineLayer.frame = CGRect(x: bounds.minX + 10.0, y: bounds.size.height - lineHeight, width: bounds.size.width, height: lineHeight)
                lineLayer.backgroundColor = tableView.separatorColor?.cgColor
                layer.addSublayer(lineLayer)
            }
            
            let testView: UIView = UIView(frame: bounds)
            testView.layer.insertSublayer(layer, at: 0)
            testView.backgroundColor = .clear
            cell.backgroundView = testView
        
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == 1 || ( indexPath.section == 1 && indexPath.row == 0 )
        {
            performSegue(withIdentifier: "followers_segue", sender: indexPath)
        }
    
    }
    
}
