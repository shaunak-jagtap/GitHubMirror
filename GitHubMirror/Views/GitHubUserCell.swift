//
//  GitHubUserCell.swift
//  GitHubMirror
//
//  Created by MMT on 20/07/19.
//  Copyright © 2019 ShaunakJagtap. All rights reserved.
//
import UIKit

class GitHubUserCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var userTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
