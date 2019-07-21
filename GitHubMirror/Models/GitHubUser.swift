//
//  GitHubUser.swift
//  GitHubMirror
//
//  Created by Shaunak on 19/07/19.
//  Copyright © 2019 ShaunakJagtaps. All rights reserved.
//

import Foundation

class GitHubUser {
    
    var login: String?
    var git_id: Double?
    var node_id: String?
    var avatar_url: String?
    var gravatar_id: String?
    var url: String?
    var html_url: String?
    var followers_url: String?
    var following_url: String?
    var gists_url: String?
    var starred_url: String?
    var subscriptions_url: String?
    var organizations_url: String?
    var repos_url: String?
    var events_url: String?
    var received_events_url: String?
    var type: String?
    var site_admin: Bool?

    var name: String?
    var company: String?
    var blog: String?
    var location: String?
    var email: String?
    var public_repos: Int?
    var public_gists: Int?
    var followers: Int?
    var following: Int?
    var score: Double?
    
    var hireable: Bool?
    var bio: String?
    var updated_at: String?
    var created_at: String?
    
    init(json:Dictionary<String, Any>) {
        login   = json["login"] as? String
        git_id  = json["id"] as? Double
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
        
        name = json["name"] as? String
        company = json["company"] as? String
        blog = json["blog"] as? String
        location = json["location"] as? String
        email = json["email"] as? String
        public_repos = json["public_repos"] as? Int? ?? 0
        public_gists = json["public_gists"] as? Int? ?? 0
        followers = json["followers"] as? Int? ?? 0
        following = json["following"] as? Int? ?? 0
        
        hireable = json["hireable"] as? Bool
        bio = json["bio"] as? String
        updated_at = json["updated_at"] as? String
        created_at = json["created_at"] as? String
    }
    
    init(){}
    
}

