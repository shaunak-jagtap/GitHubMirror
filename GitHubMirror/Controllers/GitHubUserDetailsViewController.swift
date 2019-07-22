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
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else
        {
            return 5
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
                break
                
            case 1:
                cell.userTitle.text = "Following"
                cell.userSubTitle.text = "\(selectedUser.following ?? 0)"
                break
                
            case 2:
                cell.userTitle.text = "Public repos"
                cell.userSubTitle.text = "\(selectedUser.public_repos ?? 0)"
                break
                
            case 3:
                cell.userTitle.text = "Public gists"
                cell.userSubTitle.text = "\(selectedUser.public_gists ?? 0)"
                break
                
            case 4:
                cell.userTitle.text = "Updated at"
                cell.userSubTitle.text = selectedUser.updated_at
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
            mCell.bgImageView.image = mCell.userImageView.image
            let darkBlur = UIBlurEffect(style: .dark)
            let blurView = UIVisualEffectView(effect: darkBlur)
            blurView.frame = cell.bounds
            mCell.bgImageView.addSubview(blurView)
        }
        
        
        
        if (cell.responds(to: #selector(getter: UIView.tintColor)))
        {
            let cornerRadius: CGFloat = 10.0
            cell.backgroundColor = .clear
            let layer: CAShapeLayer = CAShapeLayer()
            let path: CGMutablePath = CGMutablePath()
            let bounds: CGRect = cell.bounds
            bounds.insetBy(dx: 25.0, dy: 0.0)
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
            layer.fillColor = UIColor.yellow.withAlphaComponent(0.8).cgColor
            
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
    
    
}
