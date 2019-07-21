//
//  GitHubUsers.swift
//  GitHubMirror
//
//  Created by Shaunak on 19/07/19.
//  Copyright © 2019 ShaunakJagtaps. All rights reserved.
//

import Foundation

class GitHubUsers {
    var total_count         : Double?
    var incomplete_results  : Bool?
    var items               : [GitHubUser] = []
    
    init(json:Dictionary<String, Any>) {
        total_count   = json["total_count"] as? Double
        incomplete_results  = json["incomplete_results"] as? Bool
        if let items_data = json["items"] as? [[String:Any]]
        {
            for gitHubUserObj in items_data
            {
                items.append(GitHubUser.init(json: gitHubUserObj))
            }
        }
    }
    
    init() {}
}
