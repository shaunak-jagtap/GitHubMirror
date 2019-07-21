//
//  NetworkManager.swift
//  NewsArchives
//
//  Created by Shaunak Jagtap on 05/06/19.
//  Copyright © 2019 Shaunak Jagtap. All rights reserved.
//

import Foundation
import Alamofire

class WebServiceHandler : NSObject {
    
    
    override init() {}
    
    func processSingleRecord() -> Bool {
        return false
    }
    

    func DisplayNetworkAvailabilityMessage()-> String {
        return "network failed"
    }
    
    func fetchDataFromWebService(url:String,method: HTTPMethod,_ parameters: Dictionary<String , AnyObject>, closure:@escaping (_ completion: Any) -> Void) {
        
//        //Cancel All Requests
//        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessionDataTask, uploadData, downloadData) in
//            sessionDataTask.forEach { $0.cancel() }
//            uploadData.forEach { $0.cancel() }
//            downloadData.forEach { $0.cancel() }
//
//        }
        
//        //Add Delay
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
//
//        })
        
        Alamofire.request(url, method: method, parameters: nil, headers: nil).responseJSON { (response:DataResponse<Any>) in
            
            //TODO:Dismiss HUD
            switch response.result {
            case .success(_):
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    
                    if let result = response.result.value {
                        let JSON = result as! NSDictionary
                        DispatchQueue.main.async {
                            closure(JSON)
                        }
                    }
                }
                else if response.response?.statusCode == 0{
                    
                }
                else  {
                    if let _ = response.result.value as? Error {
                    }
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    closure(error)
                }
                //TODO:Dismiss HUD
            }}
        
    }
    
}
