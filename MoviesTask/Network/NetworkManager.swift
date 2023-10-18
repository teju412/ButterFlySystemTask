//
//  NetworkManager.swift
//  MoviesTask
//
//  Created by TejaDanasvi on 18/10/2023.
//

import Foundation

typealias Parameters = [String: Any]

enum HTTPMethod: String {
    case get     = "GET"
    case post    = "POST"
}

protocol Request {
    associatedtype ResponseType: Decodable
    var path: String { get }
    var method: HTTPMethod { get }
    var queryParams: Parameters? { get }
    var headers: [String: String]? { get }
}

extension Request{
    
    var method: HTTPMethod { return .get }
    var queryParams: Parameters? { return nil }
    var headers: [String: String]? { return ["Content-Type":"application/json"] }
    
    /// Transforms an Request into a standard URL request
    /// - Parameter baseURL: API Base URL to be used
    /// - Returns: A ready to use URLRequest
    func asURLRequest() -> URLRequest? {
        guard
            var urlComponents = URLComponents(string: APPURL.BASE_URL)
        else { return nil }
        urlComponents.path = "\(urlComponents.path)\(path)"
        
        if let queryParams = queryParams {
            urlComponents.queryItems = queryParams.toURLQueryItems()
           // debugPrint("queryParams", queryParams)
        }
        guard
            let finalURL = urlComponents.url
        else { return nil }
        debugPrint(finalURL)
        var request = URLRequest(url: finalURL)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = headers
        return request
    }
}

protocol NetworkProtocol {
    func fetch<T:Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkRequestError>) -> Void)
    func httpError(_ statusCode: Int) -> NetworkRequestError
    func handleError(_ error: Error) -> NetworkRequestError
}

struct NetworkManager: NetworkProtocol {
    
    func fetch<T:Codable>(request: URLRequest, completion: @escaping (Result<T, NetworkRequestError>) -> Void)  {
        URLSession.shared.dataTask(with: request) { [self] (data, response, error) in
            
            if let error = error {
                let err = (error as? URLError)?.code
                if  err == .cannotFindHost {
                    completion(.failure(NetworkRequestError.errorMessage("A server with the specified hostname could not be found.")))
                }else if err == .timedOut {
                    completion(.failure(NetworkRequestError.errorMessage("The request timed out., please try again")))
                }else{
                    completion(.failure(NetworkRequestError.serverError))
                }
                return
            }
            if let response = response as? HTTPURLResponse,
               !(200...299).contains(response.statusCode){
                completion(.failure(self.httpError(response.statusCode)))
                return
            }
            
            guard
                let data = data
            else {
                completion(.failure(NetworkRequestError.notFound))
                return
            }
            let _ = String(data: data, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue)) ?? ""
//            NSLog(dataString)
            do{
                let result = try JSONDecoder().decode(T.self, from: data)
                completion(.success(result))
            }catch{
                completion(.failure(handleError(error)))
            }
            
        }.resume()
    }
    
    /// Parses a HTTP StatusCode and returns a proper error
    /// - Parameter statusCode: HTTP status code
    /// - Returns: Mapped Error
     func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    /// Parses URLSession Publisher errors and return proper ones
    /// - Parameter error: URLSession publisher error
    /// - Returns: Readable NetworkRequestError
      func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}


