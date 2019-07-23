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
    
    
    override init() {
        // perform some initialization here
        
    }
    
    
    func processSingleRecord() -> Bool {
        return false
    }
    

    func DisplayNetworkAvailabilityMessage()-> String{
        return "network failed"
    }
    
    func fetchDataFromWebService(url:String,method: HTTPMethod,_ parameters: Dictionary<String , AnyObject>, closure:@escaping (_ completion: Any) -> Void) {
        
        Alamofire.request(url, method: method, parameters: nil, headers: nil).responseJSON { (response:DataResponse<Any>) in
//            print(response.request)  // original URL request
//            print(response.response) // URL response
//            //                print(response.data)     // server data
//            print("Result",response.result)   // result of response serialization
//            print("parameters = \(parameters)")
            if let JSON = response.result.value {
                //                print("JSON: \(JSON)")
            }
            //TODO:Dismiss HUD
            switch response.result {
            case .success(_):
                if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                    
                    
                    if let dictionary = response.result.value as? [String: Any] {
                            DispatchQueue.main.async {
                                closure(dictionary)
                            }
                    }
                    
//                    if self.processSingleRecord() == true {
//                        //Map single object
//                    }
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
            }
            }.responseString { response in
                //                print("Success: \(response.result.isSuccess)")
                //                print("Response String: \(response.result.value)")
        }
    } }
