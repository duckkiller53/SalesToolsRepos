//
//  ExportRouter.swift
//  SalesTools
//
//  Created by William Volm on 3/8/16.
//  Copyright © 2016 Dave LaPorte. All rights reserved.
//

import Foundation


enum ExportRouter {
    static let baseURLString:String = "https://volmac-web.volmbag.com"
    
    case ExportCustSales(Int, Bool, Bool, String)
    case ExportSalesByProd(String)
    case ExportProdSearch(String, String, Bool, String)
    case ExportCustSearch(String, String)
    
    var endpoint: String {
        var relativePath = ""
        switch self
        {
        case .ExportCustSales(let id, let type, let exclude, let whse):
            relativePath = "SalesTools/api/Export/ExportCustSales/\(id)/\(type)/\(exclude)/\(whse)"
        case .ExportSalesByProd(let id):
            relativePath = "SalesTools/api/Export/ExportSalesByProd/\(id)"
        case .ExportProdSearch(let id, let descrip, let active, let whse):
            relativePath = "SalesTools/api/Export/ExportProdSearch/\(id)/\(descrip)/\(active)/\(whse)"
        case .ExportCustSearch(let id, let name):
            relativePath = "SalesTools/api/Export/ExportCustSearch/\(id)/\(name)"
        }
        
        return Router.baseURLString + "/" + relativePath
    }
}