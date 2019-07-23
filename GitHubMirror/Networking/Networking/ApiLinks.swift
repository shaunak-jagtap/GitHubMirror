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
    
    var localHost = "chroniclingamerica.loc.gov/"
    var separater = "/"
    var host = String()
    
    static let sharedInstance = ApiLinks()

    
    func getAgencySearchUrl(page:Int) -> String {
        
        let apiExtension = "search/titles/results/?state=&county=&city=&year1=1690&year2=2019&terms=&frequency=&language=&ethnicity=&labor=&material_type=&lccn=&rows=20&page=\(page)&format=json"
        
        return "\(self.httpPart)\(localHost)\(apiExtension)"
        
    }
}
