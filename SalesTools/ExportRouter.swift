//
//  ExportRouter.swift
//  SalesTools

import Foundation


enum ExportRouter {
    static let baseURLString:String = "https://MyDomain.com"
    
    case ExportCustSales(Int, Bool, Bool, String)
    case ExportSalesByProd(String)
    case ExportProdSearch(String, String, String, String)
    case ExportCustSearch(String, String, String, String)
    
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
        case .ExportCustSearch(let id, let name, let city, let state):
            relativePath = "SalesTools/api/Export/ExportCustSearch/\(id)/\(name)/\(city)/\(state)"
        }
        
        return Router.baseURLString + "/" + relativePath
    }
}
