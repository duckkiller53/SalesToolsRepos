//
//  PIManager.swift
//  SalesTools
//
//  Created by Dave LaPorte 01/27/2016


import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

class APIManager {
  static let sharedInstance = APIManager()
  var alamofireManager: Alamofire.Manager
  
    init () {
        let configuration = NSURLSessionConfiguration.defaultSessionConfiguration()
        alamofireManager = Alamofire.Manager(configuration: configuration)
    }
    
    func getCustSales(customer: Int, type: Bool, whse: String, completionHandler: (Result<[custProd], NSError>) -> Void) {
        
        getData(Router.GetSalesByCust(customer, type, whse), completionHandler: completionHandler)
        
    }
    
    // MARK:  get customer products.
    
    func getData(urlRequest: URLRequestConvertible, completionHandler: (Result<[custProd], NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .responseArray { (response:Response<[custProd], NSError>) in
                // Begin handler
                
                guard response.result.error == nil,
                    let prods = response.result.value else {
                        print(response.result.error)
                        // completion bubbles up with error to getPublicGists
                        completionHandler(response.result)
                        return
                }
                
                // End handler
                completionHandler(.Success(prods)) // bubbles up to getCustSales
        }
    }

    
    
}