//
//  AppLinks.swift
//  NewsArchives
//
//  Created by Shaunak Jagtap on 05/06/19.
//  Copyright © 2019 Shaunak Jagtap. All rights reserved.
//

import Foundation
class ApiLinks : NSObject {
    
    var httpPart = "https://"
    var localHost = "api.github.com"
    var searchEndPoint = "/search/"
    var userDetailsEndPoint = "/users/"
    var searchWord = "query"
    var username = "username"
    var userDetailsApiExtension = "userName"
    var searchPage = 0
    var host = String()
    
    static let sharedInstance = ApiLinks()

    
    func getUsersSearchUrl() -> String {
        let usersApiExtension = "users?q=\(searchWord)&page=\(searchPage)"
        return "\(self.httpPart)\(localHost)\(searchEndPoint)\(usersApiExtension)"
    }

    func getUserDetailsSearchUrl() -> String {
        return "\(self.httpPart)\(localHost)\(userDetailsEndPoint)\(username)"
    }
}
