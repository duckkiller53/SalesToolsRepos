//
//  PIManager.swift
//  SalesTools
//
//  Created by Dave LaPorte 01/27/2016


import Foundation
import Alamofire
import SwiftyJSON

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
    
    func getProductSearch(prodid: String, description: String, active: String, warehouse: String, completionHandler: (Result<[product], NSError>) -> Void) {
        
        getProductSearch(Router.GetProductSearch(prodid, description, active, warehouse),  completionHandler: completionHandler)
        
    }
    
    func getCustomerSearch(custid: String, custname: String, city: String, state: String, completionHandler: (Result<[customer], NSError>) -> Void) {
        
        getCustomerSearch(Router.GetCustSearch(custid, custname, city, state),  completionHandler: completionHandler)
        
    }
    
    func getCustomerAR(custid: String, completionHandler: (Result<customerAR, NSError>) -> Void) {
        
        getCustomerAR(Router.GetCustAR(custid),  completionHandler: completionHandler)
        
    }
    
    func validateLogin(completionHandler: (Result<String, NSError>) -> Void)
    {
        testLogin(Router.GetLogin(),  completionHandler: completionHandler)
    }


    
    // MARK:  AlamoFire API Calls
    
    func getCustSalesData(urlRequest: URLRequestConvertible, completionHandler: (Result<[custProd], NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
            .responseArray { (response:Response<[custProd], NSError>) in
                // Begin handler
                
                if let urlResponse = response.response,
                    authError = self.checkUnauthorized(urlResponse) {
                        completionHandler(.Failure(authError))
                        return
                }
                
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
                
                if let urlResponse = response.response,
                    authError = self.checkUnauthorized(urlResponse) {
                        completionHandler(.Failure(authError))
                        return
                }

                
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
    
    func getProductSearch(urlRequest: URLRequestConvertible, completionHandler: (Result<[product], NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
            .responseArray { (response:Response<[product], NSError>) in
                // Begin handler
                
                if let urlResponse = response.response,
                    authError = self.checkUnauthorized(urlResponse) {
                        completionHandler(.Failure(authError))
                        return
                }

                
                guard response.result.error == nil,
                    let prods = response.result.value else {
                        print(response.result.error)
                        // completion bubbles up with error to getProductSearch
                        completionHandler(response.result)
                        return
                }
                
                // End handler
                completionHandler(.Success(prods)) // bubbles up to getProductSearch
        }
    }
    
    func getCustomerSearch(urlRequest: URLRequestConvertible, completionHandler: (Result<[customer], NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
            .responseArray { (response:Response<[customer], NSError>) in
                // Begin handler
                
                if let urlResponse = response.response,
                    authError = self.checkUnauthorized(urlResponse) {
                        completionHandler(.Failure(authError))
                        return
                }

                
                guard response.result.error == nil,
                    let prods = response.result.value else {
                        print(response.result.error)
                        // completion bubbles up with error to getCustomerSearch
                        completionHandler(response.result)
                        return
                }
                
                // End handler
                completionHandler(.Success(prods)) // bubbles up to getCustomerSearch
        }
    }
    
    func getCustomerAR(urlRequest: URLRequestConvertible, completionHandler: (Result<customerAR, NSError>) -> Void) {
        alamofireManager.request(urlRequest)
            .validate()
            .responseObject { (response:Response<customerAR, NSError>) in
                // Begin handler
                
                if let urlResponse = response.response,
                    authError = self.checkUnauthorized(urlResponse) {
                        completionHandler(.Failure(authError))
                        return
                }
                
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
    
    
    
    func testLogin(urlRequest: URLRequestConvertible, completionHandler: (Result<String, NSError>) -> Void)
    {
        alamofireManager.request(urlRequest)
            .validate()
            .responseString{ response in
                
                if let urlResponse = response.response,
                    authError = self.checkUnauthorized(urlResponse) {
                        completionHandler(.Failure(authError))
                        return
                }

        
                // End handler
                completionHandler(response.result) // bubbles up to getCustSales
            }
    }
    
    func checkUnauthorized(urlResponse: NSHTTPURLResponse) -> (NSError?)
    {
        if (urlResponse.statusCode == 401)
        {
            let noCredentials = NSError(domain: NSURLErrorDomain,
                code: NSURLErrorUserAuthenticationRequired,
                userInfo: [NSLocalizedDescriptionKey: "Not Logged In",
                    NSLocalizedRecoverySuggestionErrorKey: "Please re-enter your SalesTools credentials"])
            return noCredentials
        } 
        return nil
    }
    
}