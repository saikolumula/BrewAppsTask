//
//  NetworkManager.swift
//  BrewAppsTask
//
//  Created by sainath on 03/12/21.
//

import Foundation
import Alamofire

class NetworkManager:NSObject{
    
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var url: URL!
    var encoding: ParameterEncoding = URLEncoding.default
    
    init(data: [String: Any], params: [String: Any], path: String, method: HTTPMethod, isJSONRequest: Bool = true){
        super.init()
        HeaderManager.shared.getHeaders().forEach({self.headers.add(name: $0.key, value: $0.value)})
        self.url = createUrl(path: path, params: params)
        
        if !isJSONRequest{
            encoding = URLEncoding.default
        }
        
        self.method = method
        print("WebServiceAPI: \(self.url!) \n data: \(parameters)")
    }
    private func createUrl(path: String, params: [String: Any]) -> URL? {
        let urlStr = WebService.StagingServer.baseURL + "/\(path)"
        guard let url =  urlStr.url(params) else { return nil }
        return url
    }
    
    func executeQuery<T>(completion: @escaping (Result<MoviesResult<T>, Error>) -> Void) where T: Codable {
        
        if Reach().connectionStatus() == .offline ||
            Reach().connectionStatus() == .unknown {
            // TODO: Present an alertview here
            return
        }
        
        AF.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseData(completionHandler: {response in
            switch response.result{
            case .success(let res):
                if let code = response.response?.statusCode{
                    switch code {
                    case 200...299:
                        do {
                            let result = try JSONDecoder().decode(MoviesResult<T>.self, from: res)
                            completion(.success(result))
                            print("print result======\(result)")
                        } catch let error {
                            print(String(data: res, encoding: .utf8) ?? "No response received")
                            completion(.failure(error))
                        }
                    default:
                        let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
