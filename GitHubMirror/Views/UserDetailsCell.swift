//
//  UserDetailsCell.swift
//  GitHubMirror
//
//  Created by Shaunak Jagtap on 05/06/19.
//  Copyright © 2019 Shaunak Jagtap. All rights reserved.
//

import UIKit

class UserDetailsCell: UITableViewCell {
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var bgImageView: UIImageView!
    @IBOutlet weak var bgBlurView: UIVisualEffectView!
    @IBOutlet weak var userTitle: UILabel!
    @IBOutlet weak var userLocation: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        userImageView.layer.cornerRadius = 40;
        userImageView.layer.borderWidth = 2;
        userImageView.layer.borderColor = UIColor.white.cgColor
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
