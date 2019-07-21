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
    
    var localHost = "api.github.com/search/"
    var searchWord = ""
    var searchPage = 0
    var host = String()
    
    static let sharedInstance = ApiLinks()

    
    func getUsersSearchUrl() -> String {
        
        let apiExtension = "users?q=\(searchWord)&page=\(searchPage)"
        
        return "\(self.httpPart)\(localHost)\(apiExtension)"
        
    }
}
