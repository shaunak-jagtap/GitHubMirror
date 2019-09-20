//
//  GitHubUsersSearchViewController.swift
//  GitHubMirror
//
//  Created by Shaunak on 19/07/19.
//  Copyright © 2019 ShaunakJagtaps. All rights reserved.
//

import UIKit
import AlamofireImage

class GitHubUsersSearchViewController:GitUserBaseViewController {
    
    @IBOutlet weak var userSearchBar: UISearchBar!
    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "GitHub Users"
        
        print("first commit...")
        print("Second commit...")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        userSearchBar.becomeFirstResponder()
        //Displayed gif in webView instead of blank tableView
        setupWebView()
    }
    
    func setupWebView() {
        webView.isOpaque = false
        let url = Bundle.main.url(forResource: "yogocat", withExtension: "gif")!
        let data = try! Data(contentsOf: url)
        webView.load(data, mimeType: "image/gif", textEncodingName: "UTF-8", baseURL: NSURL() as URL)
        webView.scalesPageToFit = true
        webView.contentMode = UIView.ContentMode.scaleAspectFit
    }
    
    /**
     * Fire nework call and fetch users from GitHub server.
     */
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
                    if let error:Error = response as? Error {
                        self.handleError(error: error)
                    }
                }
                //                self.usersTableView.reloadData()
                self.spinner.stopAnimating()
        })
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < users.items.count
        {
            let selectedItem = users.items[indexPath.row]
            performSegue(withIdentifier: "user_details_segue", sender: selectedItem)
        }
    }
    
    override func fetchDataForNextPage()
    {
        getUsersForSearchQuery(pageNumber:pageNumber,self.userSearchBar.searchTextField.text ?? "") { (result) in
            self.usersTableView.reloadData();
        }
    }
    

    //Search bar delegates
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
}



