//
//  UserProfileImageViewController.swift
//  GitHubMirror
//
//  Created by Sagar  Patil on 23/07/19.
//  Copyright © 2019 ShaunakJagtap. All rights reserved.
//

import UIKit

class UserProfileImageViewController: UIViewController {
    
    @IBOutlet weak var profileImageview: UIImageView!
    @IBOutlet weak var bgImageview: UIImageView!

    var defaultorigin: CGPoint!
    var profileImage:UIImage!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        defaultorigin = profileImageview.frame.origin
        
        profileImageview.image = profileImage
        profileImageview.frame.origin = CGPoint(x: profileImageview.frame.origin.x, y: profileImageview.frame.origin.y - UIScreen.main.bounds.size.height)
        
        
        bgImageview.image = profileImage
        let darkBlur = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: darkBlur)
        blurView.frame = UIScreen.main.bounds
        bgImageview.addSubview(blurView)
        bgImageview.alpha = 0;
        
        UIView.animate(withDuration:2,
                       delay: 0.3,
                       usingSpringWithDamping: 0.5,
                       initialSpringVelocity: 0.8,
                       options: .curveEaseIn,
                       animations: {
                        self.profileImageview.frame.origin = self.defaultorigin
                        self.bgImageview.alpha = 1
        }, completion: {
            //Code to run after animating
            (value: Bool) in
        })
        
    }
    
}
