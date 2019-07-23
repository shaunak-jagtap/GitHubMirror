//
//  GitUserBaseViewController.swift
//  GitHubMirror
//
//  Created by MMT on 23/07/19.
//  Copyright © 2019 ShaunakJagtap. All rights reserved.
//


import UIKit
import AlamofireImage

class GitUserBaseViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var users : GitHubUsers = GitHubUsers()
    var pageNumber:Int = 1
    let spinner = UIActivityIndicatorView(style: .gray)
    
    @IBOutlet weak var tableViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var usersTableView: UITableView!
    @IBOutlet weak var animatedLabel: UILabel!
    
    var debounceTimer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usersTableView.backgroundColor = .clear
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
//            performSegue(withIdentifier: "user_details_segue", sender: selectedItem)
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height

        // Change 10.0 to adjust the distance from bottom
        if maximumOffset - currentOffset <= 5 && !spinner.isAnimating {
            pageNumber = pageNumber + 1
            
            fetchDataForNextPage()
        }
    }
    
    func fetchDataForNextPage()
    {
        
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
