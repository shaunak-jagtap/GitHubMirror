//
//  GitHubUsersSearchViewController.swift
//  GitHubMirror
//
//  Created by Shaunak on 19/07/19.
//  Copyright © 2019 ShaunakJagtaps. All rights reserved.
//

import UIKit
import AlamofireImage

class GitHubUsersSearchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var users : GitHubUsers = GitHubUsers()
    var pageNumber:Int = 1
    let spinner = UIActivityIndicatorView(style: .gray)

    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userSearchBar.becomeFirstResponder()
    }
    
    func getUsersForSearchQuery(pageNumber:Int,_ query:String,closure:@escaping (_ completion: Any) -> Void) {
        spinner.startAnimating()
        self.usersTableView.reloadData()
        let apilinks = ApiLinks.init()
        apilinks.searchPage = pageNumber
        apilinks.searchWord = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        
        let webServiceHandler = WebServiceHandler.init()
        webServiceHandler.fetchDataFromWebService(url:apilinks.getUsersSearchUrl(),method:.get,[:], closure:
            {
                response in
                
                if let resultDictionary = response as? Dictionary<String, Any>
                {
                    let users = GitHubUsers.init(json:resultDictionary)
                    self.users.items.append(contentsOf: users.items)
                    closure("success")
                }
                else
                {
                    //Error
                    closure(response)
                }
                self.spinner.stopAnimating()
        })
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GitHubUserCell = (self.usersTableView.dequeueReusableCell(withIdentifier: "user_cell") as! GitHubUserCell?)!
        
        let url = URL(string: self.users.items[indexPath.row].avatar_url ?? "github_logo.png")!
        
        let placeholderImage = UIImage(named: "github_logo.png")!
        
        cell.userImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
        
        cell.userTitle?.text = self.users.items[indexPath.row].login ?? "Title"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        spinner.frame = CGRect(x: CGFloat(0), y: CGFloat(0), width: tableView.bounds.width, height: CGFloat(44))
        footerView.frame = CGRect.init(x: 0, y: 0, width: tableView.bounds.width, height: 44)
        footerView.addSubview(spinner)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return spinner.isAnimating ? 44 : 0
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 8.0 && !spinner.isAnimating {
            pageNumber = pageNumber + 1
            getUsersForSearchQuery(pageNumber:pageNumber,self.userSearchBar.searchTextField.text ?? "") { (result) in
                self.usersTableView.reloadData();
            }
        }
    }
        
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        users = GitHubUsers()
        getUsersForSearchQuery(pageNumber: 1,searchBar.searchTextField.text ?? "") { (result) in
                self.usersTableView.reloadData();
            }
    }
//
//    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
//        users = GitHubUsers()
//        getUsersForSearchQuery(pageNumber: 1,searchBar.searchTextField.text ?? "") { (result) in
//            self.usersTableView.reloadData();
//        }
//    }
}



