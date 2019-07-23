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
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var animatedLabel: UILabel!
    
    var debounceTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GitHub Users"
        
        usersTableView.backgroundColor = .clear
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userSearchBar.becomeFirstResponder()
    }
    
    func getUsersForSearchQuery(pageNumber:Int,_ query:String,closure:@escaping (_ completion: Any) -> Void) {
        spinner.startAnimating()
        tableViewTopConstraint.constant = 0
        //        self.usersTableView.reloadData()
        let apilinks = ApiLinks.init()
        let webServiceHandler = WebServiceHandler.init()
        apilinks.searchPage = pageNumber
        apilinks.searchWord = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        webServiceHandler.fetchDataFromWebService(url:apilinks.getUsersSearchUrl(),method:.get,[:], closure:
            {
                response in
                
                if let resultDictionary = response as? Dictionary<String, Any>
                {
                    if let mError = resultDictionary["message"] as? String {
                        let lError:NSError = NSError.init(domain: mError, code: 999, userInfo:nil)
                        self.handleError(error: lError)
                    }
                    else
                    {
                        let users = GitHubUsers.init(json:resultDictionary)
                        self.users.items.append(contentsOf: users.items)
                        self.animateResultsLabel(resultsCount: users.total_count ?? 0)
                        
                        closure(query)
                    }
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.items.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:GitHubUserCell = (self.usersTableView.dequeueReusableCell(withIdentifier: "user_cell") as! GitHubUserCell?)!
        
        if self.users.items.count > indexPath.row {
            let url = URL(string: self.users.items[indexPath.row].avatar_url ?? "github_logo.png")!
            let placeholderImage = UIImage(named: "github_logo.png")!
            cell.userImageView.af_setImage(withURL: url, placeholderImage: placeholderImage)
            cell.userTitle?.text = self.users.items[indexPath.row].login ?? "Title"
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        spinner.center = CGPoint.init(x: tableView.bounds.width/2 - 22, y: 22)
        footerView.addSubview(spinner)
        return footerView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return spinner.isAnimating ? 44 : 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < users.items.count
        {
            let selectedItem = users.items[indexPath.row]
            performSegue(withIdentifier: "user_details_segue", sender: selectedItem)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        
        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 5 && !spinner.isAnimating {
            pageNumber = pageNumber + 1
            getUsersForSearchQuery(pageNumber:pageNumber,self.userSearchBar.searchTextField.text ?? "") { (result) in
                self.usersTableView.reloadData();
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.spinner.stopAnimating()
        users = GitHubUsers()
        getUsersForSearchQuery(pageNumber: 1,searchBar.searchTextField.text ?? "") { (result) in
            self.usersTableView.reloadData();
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "user_details_segue" {
            let userDetailsVC = segue.destination as! GitHubUserDetailsViewController
            userDetailsVC.selectedUser = sender as! GitHubUser
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if let timer = debounceTimer {
            timer.invalidate()
        }
        debounceTimer = Timer.init(timeInterval:0.4, target: self, selector: #selector(searchUsers), userInfo: nil, repeats: false)
        RunLoop.current.add(debounceTimer!, forMode: RunLoop.Mode(rawValue: "NSDefaultRunLoopMode"))
    }
    
    @objc func searchUsers()
    {
        users = GitHubUsers()
        self.spinner.stopAnimating()
        
        if userSearchBar.searchTextField.text?.count == 0
        {
            self.tableViewTopConstraint.constant = 0
            usersTableView.reloadData();
            return
        }
        
        getUsersForSearchQuery(pageNumber: 1,userSearchBar.searchTextField.text ?? "") { (result) in
            
            if let mQuery = result as? String {
                if mQuery == self.userSearchBar.searchTextField.text {
                    self.usersTableView.reloadData();
                }
            }
        }
    }
    
    func animateResultsLabel(resultsCount:Int)
    {
        self.tableViewTopConstraint.constant = 30
        self.animatedLabel.center.x = self.view.center.x
        self.animatedLabel.center.x -= self.view.bounds.width
        
        UIView.animate(withDuration:0.5, delay: 0, options: [.curveEaseOut], animations: {
            self.animatedLabel.center.x += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        self.animatedLabel.text = "Found \(resultsCount)  Results."
    }
    
    func handleError(error:Error)
    {
        if error.localizedDescription != "cancelled"
        {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
}



