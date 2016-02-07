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
    
    func getProdSales(prodid: String, completionHandler: (Result<[salesProd], NSError>) -> Void) {
        
        getProdSalesData(Router.GetSalesByProd(prodid),  completionHandler: completionHandler)
        
    }
    
    func getProduct(prodid: String, completionHandler: (Result<product, NSError>) -> Void) {
        
        getSingleProd(Router.GetProduct(prodid),  completionHandler: completionHandler)
        
    }
    
    func getCustomer(custid: String, completionHandler: (Result<customer, NSError>) -> Void) {
        
        getCustomerInfo(Router.GetCustInfo(custid),  completionHandler: completionHandler)
        
    }
    
    func getCustomerAR(custid: String, completionHandler: (Result<customerAR, NSError>) -> Void) {
        
        getCustomerAR(Router.GetCustAR(custid),  completionHandler: completionHandler)
        
    }

    
    // MARK:  AlamoFire API Calls
    
    func getCustSalesData(urlRequest: URLRequestConvertible, completionHandler: (Result<[custProd], NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
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
        alamofireManager.request(urlRequest)
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
    
    func getSingleProd(urlRequest: URLRequestConvertible, completionHandler: (Result<product, NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
            .responseObject { (response:Response<product, NSError>) in
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
    
    func getCustomerInfo(urlRequest: URLRequestConvertible, completionHandler: (Result<customer, NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
            .responseObject { (response:Response<customer, NSError>) in
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
    
    func getCustomerAR(urlRequest: URLRequestConvertible, completionHandler: (Result<customerAR, NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
            .responseObject { (response:Response<customerAR, NSError>) in
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