//
//  GitHubUser.swift
//  GitHubMirror
//
//  Created by Shaunak on 19/07/19.
//  Copyright © 2019 ShaunakJagtaps. All rights reserved.
//

import Foundation

class GitHubUser {
    var login               : String?
    var git_id              : Double?
    var node_id             : String?
    var avatar_url          : String?
    var gravatar_id         : String?
    var url                 : String?
    var html_url            : String?
    var followers_url       : String?
    var gists_url           : String?
    var starred_url         : String?
    var subscriptions_url   : String?
    var organizations_url   : String?
    var repos_url           : String?
    var events_url          : String?
    var received_events_url : String?
    var type                : String?
    var site_admin          : Bool?
    var score               : Double?
    
    
    init(json:Dictionary<String, Any>) {
        login   = json["login"] as? String
        git_id  = json["git_id"] as? Double
        node_id = json["node_id"] as? String
        avatar_url   = json["avatar_url"] as? String
        url  = json["url"] as? String
        html_url = json["html_url"] as? String
        followers_url   = json["followers_url"] as? String
        gists_url  = json["gists_url"] as? String
        starred_url = json["starred_url"] as? String
        subscriptions_url   = json["subscriptions_url"] as? String
        organizations_url  = json["organizations_url"] as? String
        repos_url = json["repos_url"] as? String
        events_url   = json["events_url"] as? String
        received_events_url  = json["received_events_url"] as? String
        type = json["type"] as? String
        site_admin = json["site_admin"] as? Bool
        score = json["score"] as? Double
    }

    
}

