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
        
        getCustSalesData(Router.GetSalesByCust(customer, type, whse),  completionHandler: completionHandler)
        
    }
    
    func getProdSales(prod: String, completionHandler: (Result<[salesProd], NSError>) -> Void) {
        
        getProdSalesData(Router.GetSalesByProd(prod),  completionHandler: completionHandler)
        
    }
    
    // MARK:  get customer products.
    
    func getCustSalesData(urlRequest: URLRequestConvertible, completionHandler: (Result<[custProd], NSError>) -> Void) {
        alamofireManager.request(urlRequest) .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
                print(totalBytesRead)
                
                // This closure is NOT called on the main queue for performance
                // reasons. To update your ui, dispatch to the main queue.
                dispatch_async(dispatch_get_main_queue()) {
                    progress!.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: false)
                    //progresslevel = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
                }
            }
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
    
    func getProdSalesData(urlRequest: URLRequestConvertible, completionHandler: (Result<[salesProd], NSError>) -> Void) {
        alamofireManager.request(urlRequest) .progress { bytesRead, totalBytesRead, totalBytesExpectedToRead in
            print(totalBytesRead)
            
            // This closure is NOT called on the main queue for performance
            // reasons. To update your ui, dispatch to the main queue.
            dispatch_async(dispatch_get_main_queue()) {
                progress!.setProgress(Float(totalBytesRead) / Float(totalBytesExpectedToRead), animated: false)
                //progresslevel = Float(totalBytesRead) / Float(totalBytesExpectedToRead)
            }
            }
            .validate()
            .responseArray { (response:Response<[salesProd], NSError>) in
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