
import Foundation
import Alamofire

enum QSRouter: URLRequestConvertible {
    
    case GetHeirachy([String])    
   
    
    var URLRequest: NSMutableURLRequest {
        
        var method: Alamofire.Method {
            switch self {
            case .GetHeirachy:
                return .GET
            }
        }

        // set up URL as components
        let urlComponents = NSURLComponents()
        urlComponents.scheme = "https";
        urlComponents.host = "volmac-web.volmbag.com";
        urlComponents.path = "/SalesTools/api/SalesTools/GetHierachy";
        
        switch self
        {
        case .GetHeirachy(let param):
            let queryItem1 = NSURLQueryItem(name: "val", value: param[0])
            let queryItem2 = NSURLQueryItem(name: "val", value: param[1])
            let queryItem3 = NSURLQueryItem(name: "val", value: param[2])
            let queryItem4 = NSURLQueryItem(name: "val", value: param[3])
            let queryItem5 = NSURLQueryItem(name: "val", value: param[4])
            urlComponents.queryItems = [queryItem1, queryItem2, queryItem3, queryItem4, queryItem5]
        }
        
        
        // Note:  .URL will automaticlly escap special char's.
        guard let url = urlComponents.URL else {
            print("not a valid URL")
            return NSMutableURLRequest()
        }
        
        let URLRequest = NSMutableURLRequest(URL: url)
        
        // Set Basic auth
        var username = ""
        var password = ""
        
        if let credentials:appUser = PersistenceManager.loadObject(.Credentials) {
            username = credentials.username!
            password = credentials.password!
        } else {
            print("Failed to read credentials")
        }
        
        let credentialData = "\(username):\(password)".dataUsingEncoding(NSUTF8StringEncoding)!
        let base64Credentials = credentialData.base64EncodedStringWithOptions([])
        URLRequest.setValue("Basic \(base64Credentials)", forHTTPHeaderField: "Authorization")
        
        return URLRequest
    }
}